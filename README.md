# How to monitor your UPS with free software + a Raspberry Pi

I'm going to guess you're here because you want to set up basic UPS monitoring on a Raspberry Pi or similar Linux system.

**You are in the right place, Internet Stranger.** There's a strong possibility you've been searching the Internet for a solution, so let's start with telling you what you can expect to find if you keep reading:

* **What?** A basic script that installs Network UPS Tools (NUT) and some other packages.
* **How?** By downloading our script and running it on a Raspberry Pi or similar Linux system.
* **Why?** So you can have HTTP and SNMP v2c monitoring within minutes of running the script.

Of course, there's more you may want to do with your UPS software like adding shutdown configurations, monitoring multiple UPSes, or hardening the setup with encrypted protocols and secure configurations. To help you get started with that, we'll also review how the script works and provide some tips on how you can extend it or manually configure NUT to meet specific needs. 

And, this isn't just a one-off post. We plan to update the process and script over time based on user feedback. You can even directly contribute! Just make a pull request with your suggested improvements. 

Here's an Asciicast of what the script method looks like:
[![asciicast](https://asciinema.org/a/523264.svg)](https://asciinema.org/a/523264)

## Why are we doing this?  
The [Network UPS Tools (NUT) project](https://networkupstools.org/) does a lot of good work in our industry. A lot of the UPS integrations you see in various systems (e.g., NAS devices and console servers) are made possible by NUT. Simply put, there is a lot of cool stuff you can do with NUT. 

But, we often see these problems:
* People don't know all the cool stuff NUT can do
* NUT can be complex to configure if you don't know where to start

So, we wanted to let you know about NUT and make it easy to get started. We also wanted to get some conversations going around what you want to be able to do with your Linux systems and UPSes, and make this project collaborative between us and the community. So, if you have ideas, feature requests, comments, notice bugs, or do something cool with Network UPS Tools, let us know. 

## Supported UPS list
This process *should* work with a wide variety of UPS systems with a USB port. That said, our testing has been with select Tripp Lite and Eaton branded UPSes. Here's a running list of recommended UPSes:

* [SMART1500LCD](https://www.tripplite.com/smartpro-lcd-120v-1500va-900w-line-interactive-ups-avr-2u-rack-tower-lcd-usb-db9-serial-8-outlets~smart1500lcd) 
* [Eaton 5P UPSes](https://www.eaton.com/us/en-us/catalog/backup-power-ups-surge-it-power-distribution/eaton-5p-ups.html) 

## How to use the basic script

⚠️ **Enterprise-grade security not included** We're assuming you're on a home or test network and we're not doing any production-grade security stuff. The HTTP and SNMP v2c protocols both transmit data in plaintext.  You can — and I encourage you to — modify the installation script to meet specific security requirements but we're leaving that up to you, brave Internet Stranger. 

### Prerequisites 
* A supported UPS. 
* A Linux computer running [Raspberry Pi OS](https://www.raspberrypi.com/software/), Ubuntu, or a similar operating system that uses `apt`
* root/sudo privleges
* A USB connection between the UPS and the Linux computer. You can confirm the UPS is connected using the `lsusb` command. In the example below, we see a `TRIPPLITE UPS`
![image](https://user-images.githubusercontent.com/17661803/160888626-3445f489-a3e2-4396-8b34-41b5a42fd69b.png)
* Ports 161 (UDP), 80 (TCP), and 3493 (TCP) open
* None of these packages installed: 
    - nut
    - nut-cgi
    - snmp
    - snmpd
    - libsnmp-dev
    - snmp-mibs-downloader
    - net-snmp

### Process 
1. Access your computer's terminal (e.g., via SSH) 
2. Download the script
```
wget https://raw.githubusercontent.com/dzomaya/NUTandRpi/main/scripts/nutinstall.sh
```
![image](https://user-images.githubusercontent.com/17661803/160880661-2927291b-6bc1-4521-a2aa-e3bfa0ee2760.png)
3. Make the script executable 
```
sudo chmod +x nutinstall.sh
```
![image](https://user-images.githubusercontent.com/17661803/160881172-0aaf8e44-ac22-4841-ab70-567633d2a7f0.png)

4. Run the script 
```
sudo ./nutinstall.sh
```
5. At the `If you haven't updated your package lists with a command like apt-get update or apt update within the last day or so, you should do that now. Want us to run apt update for you? Answer y for yes or anything else for no.` prompt, answer `y` if you want to run `apt update -y` now or answer `n` to skip running `apt update -y` here. If you ran `apt update` or `apt-get update` before running the script, `n` is the right answer. 
6.  At the `Do you want to assume the risk and continue? Enter 'y' for yes or 'n' for no.` prompt, enter `y` to assume the risk and continue.
![image](https://user-images.githubusercontent.com/17661803/160882265-e709bb72-2baa-497a-acc1-1e2b51c82b32.png)
7.  At the 'Tell me what SNMP v2c community string I should use for your configuration:' prompt, input a 1-32 character alphanumeric SNMP v2c community string. This is the community string that the script will use to configure your SNMP settings.
![image](https://user-images.githubusercontent.com/17661803/160882674-c6415f72-fa97-4425-97fd-1ef58065efb7.png)
8. Now the script will run and configure Network UPS Tools, the nut-cgi package (including Apache), and your SNMP settings. This can take a couple of minutes. At the end of the script, you should see a message similar to:
```
You should now be able to see cool UPS stats at http://localhost/cgi-bin/nut/upsstats.cgi.
'snmpwalk -v2c -c <the community from earlier> localhost .1.3.6.1.4.1.8072.1.3.2.4.1.2' should give you some SNMP data too.
This was fun. Thanks. Have a great day Internet Freind. Goodbye
```
![image](https://user-images.githubusercontent.com/17661803/160883129-756b483a-9899-4c02-be92-7665623e995c.png)

That's it! You're off to the races with your UPS monitoring.

Now you can do cool stuff like:

* **Browse to http://yourRasberryPiIPaddress/cgi-bin/nut/upsstats.cgi and an overview of UPS status**
 ![image](https://user-images.githubusercontent.com/17661803/160884654-38dbb526-be10-488b-89f5-5ceda95ffbd7.png)
* **Browse to http://yourRasberryPiIPaddress/cgi-bin/nut/upsstats.cgi?host=nutdev1@localhost and see a dashboard of UPS UPS statistics**
![image](https://user-images.githubusercontent.com/17661803/160884938-2f63a532-05a4-40d3-907a-f4e03b14c53c.png)
* **Browse to http://yourRasberryPiIPaddress/cgi-bin/nut/upsstats.cgi?host=nutdev1@localhost&treemode and see a list of all supported UPS variables**
![image](https://user-images.githubusercontent.com/17661803/160885216-bc0c36d6-a294-4868-8ed3-39cb7db8f3c8.png)
* **Use SNMP tools to capture UPS data, like this:**
```
snmpwalk -v2c -c yourSNMPv2cCommunity yourRasberryPiIPaddress .1.3.6.1.4.1.8072.1.3.2.4.1.2
```
Output should look similar to
```
NET-SNMP-EXTEND-MIB::nsExtendOutLine."upsmfr".1 = STRING: TRIPPLITE
NET-SNMP-EXTEND-MIB::nsExtendOutLine."inputHZ".1 = STRING: 59.9
NET-SNMP-EXTEND-MIB::nsExtendOutLine."outputHZ".1 = STRING: 59.9
NET-SNMP-EXTEND-MIB::nsExtendOutLine."upsmodel".1 = STRING: TRIPPLITE UPS
NET-SNMP-EXTEND-MIB::nsExtendOutLine."battvolts".1 = STRING: 54.0
NET-SNMP-EXTEND-MIB::nsExtendOutLine."inputvolt".1 = STRING: 126.0
NET-SNMP-EXTEND-MIB::nsExtendOutLine."upsserial".1 = STRING: 3104JLCPS795200451
NET-SNMP-EXTEND-MIB::nsExtendOutLine."upsstatus".1 = STRING: OL
NET-SNMP-EXTEND-MIB::nsExtendOutLine."battcharge".1 = STRING: 100
NET-SNMP-EXTEND-MIB::nsExtendOutLine."outputload".1 = STRING: 0.0
NET-SNMP-EXTEND-MIB::nsExtendOutLine."outputvolt".1 = STRING: 120.0
NET-SNMP-EXTEND-MIB::nsExtendOutLine."battruntimeest".1 = STRING: 65535
```
![image](https://user-images.githubusercontent.com/17661803/160885999-d31fa010-6fe3-4321-9ee2-f40b24517635.png)
Now that you've exposed the data via SNMP, you can use a wide-range of monitoring utilites like NagiOS, LibreNMS, and Observium to do all sorts of cool things.

You can read up on the OIDs we used in the [OID explainer](https://github.com/dzomaya/NUTandRpi/blob/main/OIDexplainer.md).  

## How to install and configure NUT and Net-SNMP manually
Our script won't work for everyone and you learn more doing it manually anyway, so let's walk through how you can manually install and configure NUT.

⚠️ **Enterprise-grade security not included** We're assuming you're on a home or test network and we're not doing any production-grade security stuff. The HTTP and SNMP v2c protocols both transmit data in plaintext.  You can — and I encourage you to — modify the installation script to meet specific security requirements but we're leaving that up to you, brave Internet Stranger.  

### Prerequisites 
* A supported UPS.
* A Linux computer running [Raspberry Pi OS](https://www.raspberrypi.com/software/), Ubuntu, or a similar operating system
    * Just about any \*nix system should work, our commands just assume Ubuntu-like stuff such as the `apt` command
* root/sudo privleges to run commands 
* A USB connection between the UPS and the Linux computer. You can confirm the UPS is connected using the `lsusb` command. In the example below, we see a `TRIPPLITE UPS`
![image](https://user-images.githubusercontent.com/17661803/160888626-3445f489-a3e2-4396-8b34-41b5a42fd69b.png)
* Ports 161 (UDP), 80 (TCP), and 3493 (TCP) open
* None of these packages installed: 
    - nut
    - nut-cgi
    - snmp
    - snmpd
    - libsnmp-dev
    - snmp-mibs-downloader
    - net-snmp

### (Optional) Update your system
If you haven't updated your system in a while, it's a good idea to access your computer's terminal (e.g., via SSH) and run:
```
sudo apt update
```
To make sure you get the latest available packages in the next steps. 

### Install NUT and nut-cgi
1. Access your computer's terminal (e.g., via SSH)
2. Use `apt` to install the `nut` and `nut-cgi` packages
```
sudo apt install nut nut-cgi
```
![image](https://user-images.githubusercontent.com/17661803/160892838-22814911-19a2-423c-94d9-132545433a09.png)

### Configure NUT
1. Run this command:
```
nut-scanner -UNq
```
The output should look similar to:
```
SNMP library not found. SNMP search disabled.
Neon library not found. XML search disabled.
IPMI library not found. IPMI search disabled.
[nutdev1]
        driver = "usbhid-ups"
        port = "auto"
        vendorid = "09AE"
        productid = "4004"
        bus = "003"
```
You'll need everything under (and including) `[nutdev1]` for the next step.
![image](https://user-images.githubusercontent.com/17661803/160893706-69e5ffbf-3a77-446e-a602-b82fe8ee51cc.png)

2. Use a text editor (e.g. `nano` or `vi`) to edit /etc/nut/ups.conf and append the output from step 1. Using our example output, the uncommented section of the ups.conf file should look like this:
```
maxretry = 3
[nutdev1]
        driver = "usbhid-ups"
        port = "auto"
        vendorid = "09AE"
        productid = "4004"
        bus = "003"
```
3.  Use a text editor (e.g. `nano` or `vi`) to edit /etc/nut/nut.conf to read
```
MODE=netserver
```
![image](https://user-images.githubusercontent.com/17661803/160900260-8794ca55-e75b-49d0-8adf-30a2a82cb2d5.png)
4. Make sure your UPS is now communicating by running the `upsc nutdev1` command. Output should look similar to:
```
Init SSL without certificate database
battery.charge: 100
battery.charge.low: 20
battery.charge.warning: 20
battery.runtime: 65535
battery.temperature: 28.9
battery.type: PbAc
battery.voltage: 54.0
battery.voltage.nominal: 48.0
device.mfr: TRIPPLITE
device.model: TRIPPLITE UPS
device.serial: 3104JLCPS795200451
device.type: ups
driver.name: usbhid-ups
driver.parameter.bus: 003
driver.parameter.pollfreq: 30
driver.parameter.pollinterval: 2
driver.parameter.port: auto
driver.parameter.product: TRIPPLITE UPS
driver.parameter.productid: 4004
driver.parameter.serial: 3104JLCPS795200451
driver.parameter.synchronous: no
driver.parameter.vendor: TRIPPLITE
driver.parameter.vendorid: 09AE
driver.version: 2.7.4
driver.version.data: TrippLite HID 0.82
driver.version.internal: 0.41
input.frequency: 60.0
input.transfer.high: 150.0
input.transfer.high.max: 150
input.transfer.high.min: 145
input.transfer.low: 55.0
input.transfer.low.max: 60
input.transfer.low.min: 55
input.voltage: 126.0
input.voltage.nominal: 120
output.current: 0.0
output.frequency: 60.0
output.frequency.nominal: 60
output.voltage: 120.0
output.voltage.nominal: 120
ups.beeper.status: enabled
ups.delay.shutdown: 20
ups.delay.start: 30
ups.firmware: 64
ups.load: 0
ups.mfr: TRIPPLITE
ups.model: TRIPPLITE UPS
ups.power: 0.0
ups.power.nominal: 2200
ups.productid: 4004
ups.serial: 3104JLCPS795200451
ups.status: OL
ups.test.result: Done and passed
ups.timer.reboot: 0
ups.timer.shutdown: -1
ups.timer.start: 0
ups.vendorid: 09ae
ups.watchdog.status: 0

```
![image](https://user-images.githubusercontent.com/17661803/160900562-a36dd486-0967-4a55-bd7b-4d5d71b31e44.png)

5. Add your UPS to the NUT hosts.conf file by using a text editor (e.g. `nano` or `vi`) to edit /etc/nut/hosts.conf and add this line to the end of the file:
```
MONITOR nutdev1@localhost \"Pepper and Egg UPS\"
```
![image](https://user-images.githubusercontent.com/17661803/160903160-0b3ace8d-b899-48fe-8715-c0c10281b542.png)

### Configure Apache
1. Apache was installed when we intsalled the `nut-cgi` package. Enable the cgi module with this command:
  ```
  a2enmod cgi
  ```
  You should see output similar to:
```
Your MPM seems to be threaded. Selecting cgid instead of cgi.
Enabling module cgid.
To activate the new configuration, you need to run:
  systemctl restart apache2
```

2. Restart Apache with this command:
```
systemctl restart apache2
```
![image](https://user-images.githubusercontent.com/17661803/160901530-e7eecbba-4808-420d-bf39-f1e73ea05abe.png)

### Install Net-SNMP
1.  Use `apt` to install the `snmp`, `snmpd`, `libsnmp-dev`, and `snmp-mibs-downloader` packages
'''
sudo apt install snmp snmpd libsnmp-dev snmp-mibs-downloader
'''
![image](https://user-images.githubusercontent.com/17661803/160903695-aa09cfef-c587-41ec-a76f-9eb6ad6c83e7.png)

### Configure Net-SNMP
1. Use a text editor (e.g. `nano` or `vi`) to create an /etc/snmp/snmpd.conf file and add your SNMP v2c community string to the begining. To create a read-only `tripplite`, add this entry (edit your community string to be something only you know):
```
rocommunity tripplite
```
Don't save your changes just yet, we have some more edits to make. 

2. Next, we're going to add `upsc` commands to the /etc/snmp/snmpd.conf. For our example, we'll add these 12 lines:
 ```
extend-sh upsmodel "/bin/upsc nutdev1 ups.model"
extend-sh upsmodel "/bin/upsc nutdev1 ups.model"
extend-sh upsserial "/bin/upsc nutdev1 ups.serial"
extend-sh upsstatus "/bin/upsc nutdev1 ups.status"
extend-sh battcharge "/bin/upsc nutdev1 battery.charge"
extend-sh battruntimeest "/bin/upsc nutdev1 battery.runtime"
extend-sh battvolts "/bin/upsc nutdev1 battery.voltage"
extend-sh inputvolt "/bin/upsc nutdev1 input.voltage"
extend-sh inputHZ "/bin/upsc nutdev1 input.frequency"
extend-sh outputvolt "/bin/upsc nutdev1 output.voltage"
extend-sh outputHZ "/bin/upsc nutdev1 output.frequency"
extend-sh outputHZ "/bin/upsc nutdev1 output.frequency"
 ```
 Now, save your changes. The file should look like this when you're done:

![image](https://user-images.githubusercontent.com/17661803/160909508-39a80fa9-a15b-41a1-a764-d2e4e97a19bc.png)

3. Enable the snmpd service
```
sudo systemctl enable snmpd
```

4. Restart the snmpd service
```
sudo  systemctl restart snmpd
```

### HAVE A LOT OF FUN!
That's it! You're off to the races with your UPS monitoring.

Now you can do cool stuff like:

* **Browse to http://yourRasberryPiIPaddress/cgi-bin/nut/upsstats.cgi and an overview of UPS status**
 ![image](https://user-images.githubusercontent.com/17661803/160884654-38dbb526-be10-488b-89f5-5ceda95ffbd7.png)
* **Browse to http://yourRasberryPiIPaddress/cgi-bin/nut/upsstats.cgi?host=nutdev1@localhost and see a dashboard of UPS UPS statistics**
![image](https://user-images.githubusercontent.com/17661803/160884938-2f63a532-05a4-40d3-907a-f4e03b14c53c.png)
* **Browse to http://yourRasberryPiIPaddress/cgi-bin/nut/upsstats.cgi?host=nutdev1@localhost&treemode and see a list of all supported UPS variables**
![image](https://user-images.githubusercontent.com/17661803/160885216-bc0c36d6-a294-4868-8ed3-39cb7db8f3c8.png)
* **Use SNMP tools to capture UPS data, like this:**
```
snmpwalk -v2c -c yourSNMPv2cCommunity yourRasberryPiIPaddress .1.3.6.1.4.1.8072.1.3.2.4.1.2
```
Output should look similar to
```
NET-SNMP-EXTEND-MIB::nsExtendOutLine."upsmfr".1 = STRING: TRIPPLITE
NET-SNMP-EXTEND-MIB::nsExtendOutLine."inputHZ".1 = STRING: 59.9
NET-SNMP-EXTEND-MIB::nsExtendOutLine."outputHZ".1 = STRING: 59.9
NET-SNMP-EXTEND-MIB::nsExtendOutLine."upsmodel".1 = STRING: TRIPPLITE UPS
NET-SNMP-EXTEND-MIB::nsExtendOutLine."battvolts".1 = STRING: 54.0
NET-SNMP-EXTEND-MIB::nsExtendOutLine."inputvolt".1 = STRING: 126.0
NET-SNMP-EXTEND-MIB::nsExtendOutLine."upsserial".1 = STRING: 3104JLCPS795200451
NET-SNMP-EXTEND-MIB::nsExtendOutLine."upsstatus".1 = STRING: OL
NET-SNMP-EXTEND-MIB::nsExtendOutLine."battcharge".1 = STRING: 100
NET-SNMP-EXTEND-MIB::nsExtendOutLine."outputload".1 = STRING: 0.0
NET-SNMP-EXTEND-MIB::nsExtendOutLine."outputvolt".1 = STRING: 120.0
NET-SNMP-EXTEND-MIB::nsExtendOutLine."battruntimeest".1 = STRING: 65535
```
![image](https://user-images.githubusercontent.com/17661803/160885999-d31fa010-6fe3-4321-9ee2-f40b24517635.png)
Now that you've exposed the data via SNMP, you can use a wide-range of monitoring utilites like NagiOS, LibreNMS, and Observium to do all sorts of cool things.

You can read up on the OIDs we used in the [OID explainer](https://github.com/dzomaya/NUTandRpi/blob/main/OIDexplainer.md).

## Other cool stuff you can do

What we've done here will give you a good starting point for UPS _monitoring_. That said, we know there are plenty of other things you might want to do. We might even up date this project to do some of them in the future, but for now here are some tips to point you in the right direction. 

If you just want to explore what you can do in general, Roger Price has done a great job with NUT documentation:
https://rogerprice.org/NUT/

### Operating System and UPS shutdown

Often, you'll want to gracefully shutdown operating systems and shut down UPS output based on certain UPS events. `upsmon` and section 6.3 of the [NUT User's Manual](https://networkupstools.org/docs/user-manual.chunked/ar01s06.html#UPS_shutdown) is a good place to start. There is [a full PDF version of the manual here](https://networkupstools.org/docs/user-manual.pdf). 

Additionally, [YouTuber Techno Tim has a video that walks through setting up multiple UPSes, a NUT Server and clients (including the Windows WinClient), and system shutdown](https://www.youtube.com/watch?v=vyBP7wpN72c). 

### Monitoring multiple UPSes

Again, the NUT User's Guide and Techno Tim video are good references. For a straightforward use case, consider starting with adding additional USB-connected UPSes in your `/etc/nut/ups.conf` file. 

### Create cool-looking dashboards with Grafana
[Grafana](https://github.com/grafana/grafana) is a great open source project for data visualization and graphing. Once you have NUT and Net-SNMP configured it's possible to take those values and graph them in Grafana. For example, I used Grafana, [InfluxDB](https://github.com/influxdata/influxdb), and [Telegraf](https://github.com/influxdata/telegraf) to put this together using data from one of our NUT/Net-SNMP installs.
![Grafana with NUT and Net-SNMP](https://user-images.githubusercontent.com/17661803/167516631-0c197fd5-c8e2-421d-bc7e-0cfab38a48b4.png)

Additionally, Grafana is extensible enough that you could even take SNMP out of the mix altogether and use `upsc` or similar to capture the data. 

### Configuring SNMP v3
SNMP v3 is a bit more complex than SNMP v2c, but it also uses encryption and is significantly more secure. For a deep understanding of Net-SNMP configuration, you should check out [their docs](http://www.net-snmp.org/docs/man/). 

If you're just testing, a quick way to get started creating SNMP v3 users is to use the `net-snmp-config --create-snmpv3-user` command. 

For example, to create a `PiNutAdmin` SNMP v3 user with read-only permissions that uses AES and SHA with an auth and privacy passwords both set to `pepperandegg`, we can do this:

1. Stop the snmpd service
 `sudo systemctl stop snmpd`
2. Run the command to create the user
`sudo net-snmp-config --create-snmpv3-user -ro -x AES -a SHA -A "pepperandegg" -X "pepperandegg" PiNutAdmin`
3. Start the snmpd service
`sudo systemctl start snmpd`
4. Run an `snmpwalk` to see if your user can read UPS data
`snmpwalk -v 3 -u PiNutAdmin -l AuthPriv -x AES -a SHA -X pepperandegg -A pepperandegg localhost .1.3.6.1.4.1.8072.1.3.2.4.1.2`
You should see output similar to:
```
NET-SNMP-EXTEND-MIB::nsExtendOutLine."upsmfr".1 = STRING: TRIPPLITE
NET-SNMP-EXTEND-MIB::nsExtendOutLine."inputHZ".1 = STRING: 59.9
NET-SNMP-EXTEND-MIB::nsExtendOutLine."outputHZ".1 = STRING: 59.9
NET-SNMP-EXTEND-MIB::nsExtendOutLine."upsmodel".1 = STRING: TRIPPLITE UPS
NET-SNMP-EXTEND-MIB::nsExtendOutLine."battvolts".1 = STRING: 54.0
NET-SNMP-EXTEND-MIB::nsExtendOutLine."inputvolt".1 = STRING: 126.0
NET-SNMP-EXTEND-MIB::nsExtendOutLine."upsserial".1 = STRING: 3104JLCPS795200451
NET-SNMP-EXTEND-MIB::nsExtendOutLine."upsstatus".1 = STRING: OL
NET-SNMP-EXTEND-MIB::nsExtendOutLine."battcharge".1 = STRING: 100
NET-SNMP-EXTEND-MIB::nsExtendOutLine."outputload".1 = STRING: 0.0
NET-SNMP-EXTEND-MIB::nsExtendOutLine."outputvolt".1 = STRING: 120.0
NET-SNMP-EXTEND-MIB::nsExtendOutLine."battruntimeest".1 = STRING: 65535
```
![SNMP v3 user for NUT UPS test configuration](https://user-images.githubusercontent.com/17661803/167519590-65beb360-3662-4f07-9d98-8a1a7617d5d3.png)

## Send us your feedback and contribute 
We want to hear from you.

* If you have a suggested improvement for the scripts or process, make a pull request.
* If you notice a bug or have a feature request,  report an issue. 
* If you're from an organization that needs a solution for a specific Linux/UPS application, shoot me a message. 

Good bye and good luck, Internet Stranger. 

