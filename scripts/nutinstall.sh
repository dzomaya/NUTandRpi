#!/bin/bash

# Check if script is run as sudo/root
if [ "$EUID" -ne 0 ]
        then echo "ERROR script not run as root/sudo. Please run as root or using sudo"
        exit
fi

echo "Hello Internet Freind. This is a test script."
echo " "
echo "This script is NOT production ready and, even if successful, the configuration you end up with will require some additional work to make it secure."
echo "You should really read the README (https://github.com/dzomaya/NUTandRpi/blob/main/README.md) to understand what you're getting into."
echo " "
echo " If you need a production-grade solution, I recommend contacting the Tripp Lite by Eaton team: https://tripplite.eaton.com/support/contact-us."
echo "This script will attempt to install multiple packages on this machine and configure Network UPS Tools and SNMP v2c."
echo " "
echo "IMPORTANT: WE ARE GOING TO RUN apt update"
echo "IMPORTANT: SCRIPT ASSUMES YOU DO NOT HAVE ANY OF THESE PACKAGES INSTALLED:"
echo "* nut"
echo "* nut-cgi"
echo "* snmp"
echo "* snmpd"
echo "* libsnmp-dev"
echo "* snmp-mibs-downloader"
echo "* net-snmp"
echo "* Apache or any other http server running on port 80"
read -p "Do you want to assume the risk and continue? Enter 'y' for yes or 'n' for no."
echo " "
if [[ $REPLY =~ ^[Yy]$ ]]; then
echo "WOOOOOOO! Here... we... go..."
# Make sure you are up to date
read -p "If you haven't updated your package lists with a command like apt-get update or apt update within the last day or so, you should do that now. Want us to run apt update for you? Answer y for yes or anything else for no. "
    if [[ $REPLY =~ ^[Yy]$ ]]; then
    apt update -y
    else
    echo "Ok, we will NOT run 'apt-get update'";
    fi
read -n 32 -p  "Tell me what SNMP v2c community string I should use for your configuration:" v2ccommunity
while [[ "$v2ccommunity" =~ [^a-zA-Z0-9] || -z "$v2ccommunity"  ]]
do
        echo "I cannot use that. Please only use alphanumeric characters. You can use 1-32 characters total"
        read -n 32 -p "Tell me what SNMP v2c community string I should use for your configuration:" v2ccommunity
done
echo "*********************"
# Install NUT and NUT CGI from repo
apt-get install nut nut-cgi -y
#make backups of the conf files we touch
cp /etc/nut/nut.conf /etc/nut/nut.bak
cp /etc/nut/ups.conf /etc/nut/ups.bak
# edit nut.conf
echo "MODE=netserver" > "/etc/nut/nut.conf"
#Try to run nut-scanner to create a ups.conf
nut-scanner -UNq 2>/dev/null > /etc/nut/ups.conf
#Check if nut-scanner failed, it wasn't  included with some Pi versions
    if [ $? -ne 0 ]; then
    echo "No nut-scanner. That might be ok. We will build the ups.conf manually."
    # echo ups.conf this is cheap, need to fix
    echo "[nutdev1]" >> "/etc/nut/ups.conf"
    echo "    driver=usbhid-ups" >> "/etc/nut/ups.conf"
    echo "    port = auto" >> "/etc/nut/ups.conf"
    fi
# in case driver didn't start you can try to force it
upsdrvctl start
# sleep for 10 seconds
sleep 10
# in case upsd didn't start you can try to force it
upsd
# sleep for 20 seconds
sleep 20
# check if we're talking
upsc nutdev1
# Allow CGI to work for upsset, not secure uncomment if you want to
# echo  "I_HAVE_SECURED_MY_CGI_DIRECTORY" >> "/etc/nut/upsset.conf"
# Allow NUT hosts
echo "MONITOR nutdev1@localhost \"Pepper and Egg UPS\"" >> "/etc/nut/hosts.conf"
# enable apache CGI
a2enmod cgi
# restart apache
systemctl restart apache2
# sleep 3 seconds
sleep 3
# are we working?  This will be ugly curl output, but easy quick check
curl http://localhost/cgi-bin/nut/upsstats.cgi
# Install SNMP packages
sudo apt-get install snmp snmpd libsnmp-dev snmp-mibs-downloader -y
# make backups of the conf files we touch if they exist
cp /etc/snmp/snmpd.conf /etc/snmp/old.snmpd.conf.old
# overwrite snmpd.conf with this one  line
echo "rocommunity $v2ccommunity" > /etc/snmp/snmpd.conf
# append the rest of the snmpd.conf to use upsc commands to capture variables
echo 'extend-sh upsmodel "/bin/upsc nutdev1 ups.model"' >> /etc/snmp/snmpd.conf
echo 'extend-sh upsmfr "/bin/upsc nutdev1  ups.mfr"' >> /etc/snmp/snmpd.conf
echo 'extend-sh upsserial "/bin/upsc nutdev1 ups.serial"' >> /etc/snmp/snmpd.conf
echo 'extend-sh upsstatus "/bin/upsc nutdev1 ups.status"' >> /etc/snmp/snmpd.conf
echo 'extend-sh battcharge "/bin/upsc nutdev1 battery.charge"' >> /etc/snmp/snmpd.conf
echo 'extend-sh battruntimeest "/bin/upsc nutdev1 battery.runtime"' >> /etc/snmp/snmpd.conf
echo 'extend-sh battvolts "/bin/upsc nutdev1 battery.voltage"' >> /etc/snmp/snmpd.conf
echo 'extend-sh inputvolt "/bin/upsc nutdev1 input.voltage"' >> /etc/snmp/snmpd.conf
echo 'extend-sh inputHZ "/bin/upsc nutdev1 input.frequency"' >> /etc/snmp/snmpd.conf
echo 'extend-sh outputvolt "/bin/upsc nutdev1 output.voltage"' >> /etc/snmp/snmpd.conf
echo 'extend-sh outputHZ "/bin/upsc nutdev1 output.frequency"' >> /etc/snmp/snmpd.conf
echo 'extend-sh outputload "/bin/upsc nutdev1 ups.power"' >> /etc/snmp/snmpd.conf
# enable and restart snmpd
systemctl enable snmpd
systemctl restart snmpd
# sleep for 20 seconds
sleep 20
# run our snmptest
snmpget -v2c -c "$v2ccommunity" localhost .1.3.6.1.4.1.8072.1.3.2.4.1.2.8.117.112.115.109.111.100.101.108.1 .1.3.6.1.4.1.8072.1.3.2.4.1.2.6.117.112.115.109.102.114.1 .1.3.6.1.4.1.8072.1.3.2.4.1.2.9.117.112.115.115.101.114.105.97.108.1 .1.3.6.1.4.1.8072.1.3.2.4.1.2.9.117.112.115.115.116.97.116.117.115.1 .1.3.6.1.4.1.8072.1.3.2.4.1.2.10.98.97.116.116.99.104.97.114.103.101.1 .1.3.6.1.4.1.8072.1.3.2.4.1.2.9.98.97.116.116.118.111.108.116.115.1  .1.3.6.1.4.1.8072.1.3.2.4.1.2.9.105.110.112.117.116.118.111.108.116.1 .1.3.6.1.4.1.8072.1.3.2.4.1.2.7.105.110.112.117.116.72.90.1 .1.3.6.1.4.1.8072.1.3.2.4.1.2.10.111.117.116.112.117.116.118.111.108.116.1 .1.3.6.1.4.1.8072.1.3.2.4.1.2.8.111.117.116.112.117.116.72.90.1 .1.3.6.1.4.1.8072.1.3.2.4.1.2.10.111.117.116.112.117.116.108.111.97.100.1 .1.3.6.1.4.1.8072.1.3.2.4.1.2.14.98.97.116.116.114.117.110.116.105.109.101.101.115.116.1
# Be nice
echo "You should now be able to see cool UPS stats at http://localhost/cgi-bin/nut/upsstats.cgi."
echo "snmpwalk -v2c -c $v2ccommunity localhost .1.3.6.1.4.1.8072.1.3.2.4.1.2 should give you some SNMP data too."
echo "This was fun. Thanks. Have a great day Internet Freind. Goodbye";
else
echo "Maybe another time Internet Freind. Goodbye";
fi
