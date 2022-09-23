# OID Explainer for nutinstall.sh
The [nutinstall.sh script here](https://github.com/dzomaya/NUTandRpi/blob/main/scripts/nutinstall.sh) creates several OIDs using the NET-SNMP-EXTEND-MIB. 
This document explains what those values are and provides their OIDs. 
Note that all of these values are STRINGs (see [this StackOverflow post](https://stackoverflow.com/questions/19769693/force-snmp-to-see-number-as-integer) for some backround). 
Do NOT use this unless you're testing it along with me or want to assume all risk!

## UPS Model
* OID NAME: NET-SNMP-EXTEND-MIB::nsExtendOutLine."upsmodel".1 
* OID Numeric:.1.3.6.1.4.1.8072.1.3.2.4.1.2.8.117.112.115.109.111.100.101.108.1
* Sample response:
	```
	TRIPPLITE UPS
	```

## UPS Manufacturer 
* OID NAME: NET-SNMP-EXTEND-MIB::nsExtendOutLine."upsmfr".1 
* OID Numeric:.1.3.6.1.4.1.8072.1.3.2.4.1.2.6.117.112.115.109.102.114.1
* Sample response:
	```
	TRIPPLITE
	```

## UPS Serial Number
* OID NAME: NET-SNMP-EXTEND-MIB::nsExtendOutLine."upsserial".1 
* OID Numeric:.1.3.6.1.4.1.8072.1.3.2.4.1.2.9.117.112.115.115.101.114.105.97.108.1
* Sample response:
	```
	3104JLCPS795200451
	```

## UPS Status
* OID NAME: NET-SNMP-EXTEND-MIB::nsExtendOutLine."upsstatus".1 
* OID Numeric:.1.3.6.1.4.1.8072.1.3.2.4.1.2.9.117.112.115.115.116.97.116.117.115.1
* Sample response:
	```
	OL
	```

## UPS Estimated Runtime
* OID NAME: NET-SNMP-EXTEND-MIB::nsExtendOutLine."battruntimeest".1 
* OID Numeric:.1.3.6.1.4.1.8072.1.3.2.4.1.2.14.98.97.116.116.114.117.110.116.105.109.101.101.115.116.1 
* Sample response:
	```
	65535
	``` 

## UPS Battery Charge %
* OID NAME: NET-SNMP-EXTEND-MIB::nsExtendOutLine."battcharge".1 
* OID Numeric:.1.3.6.1.4.1.8072.1.3.2.4.1.2.10.98.97.116.116.99.104.97.114.103.101.1
* Sample response:
	```
	100
	```

## UPS Battery Volts DC
* OID NAME: NET-SNMP-EXTEND-MIB::nsExtendOutLine."battvolts".1 
* OID Numeric:.1.3.6.1.4.1.8072.1.3.2.4.1.2.9.98.97.116.116.118.111.108.116.115.1 
* Sample response:
	```
	54.0
	```

## UPS Input Volts AC
* OID NAME: NET-SNMP-EXTEND-MIB::nsExtendOutLine."inputvolt".1 
* OID Numeric:.1.3.6.1.4.1.8072.1.3.2.4.1.2.9.105.110.112.117.116.118.111.108.116.1 
* Sample response:
	```
	127.0
	```

## UPS Input Freqency
* OID NAME: NET-SNMP-EXTEND-MIB::nsExtendOutLine."inputHZ".1 
* OID Numeric:.1.3.6.1.4.1.8072.1.3.2.4.1.2.7.105.110.112.117.116.72.90.1
* Sample response:
	```
	59.9
	```

## UPS Output Volts AC
* OID NAME: NET-SNMP-EXTEND-MIB::nsExtendOutLine."outputvolt".1 
* OID Numeric:.1.3.6.1.4.1.8072.1.3.2.4.1.2.10.111.117.116.112.117.116.118.111.108.116.1 
* Sample response:
	```
	120.0
	```

## UPS Output Frequency 
* OID NAME: NET-SNMP-EXTEND-MIB::nsExtendOutLine."outputHZ".1 
* OID Numeric:.1.3.6.1.4.1.8072.1.3.2.4.1.2.8.111.117.116.112.117.116.72.90.1
* Sample response:
	```
	59.9
	```

## UPS Output Load 
* OID NAME: NET-SNMP-EXTEND-MIB::nsExtendOutLine."outputload".1
* OID Numeric:.1.3.6.1.4.1.8072.1.3.2.4.1.2.10.111.117.116.112.117.116.108.111.97.100.1 
* Sample response:
	```
	0.0
	```

## Test all in a one-liner
Replace `tripplite` with your SNMP v2c community string. 
```
snmpget -v2c -c tripplite localhost .1.3.6.1.4.1.8072.1.3.2.4.1.2.8.117.112.115.109.111.100.101.108.1 .1.3.6.1.4.1.8072.1.3.2.4.1.2.6.117.112.115.109.102.114.1 .1.3.6.1.4.1.8072.1.3.2.4.1.2.9.117.112.115.115.101.114.105.97.108.1 .1.3.6.1.4.1.8072.1.3.2.4.1.2.9.117.112.115.115.116.97.116.117.115.1 .1.3.6.1.4.1.8072.1.3.2.4.1.2.10.98.97.116.116.99.104.97.114.103.101.1 .1.3.6.1.4.1.8072.1.3.2.4.1.2.9.98.97.116.116.118.111.108.116.115.1  .1.3.6.1.4.1.8072.1.3.2.4.1.2.9.105.110.112.117.116.118.111.108.116.1 .1.3.6.1.4.1.8072.1.3.2.4.1.2.7.105.110.112.117.116.72.90.1 .1.3.6.1.4.1.8072.1.3.2.4.1.2.10.111.117.116.112.117.116.118.111.108.116.1 .1.3.6.1.4.1.8072.1.3.2.4.1.2.8.111.117.116.112.117.116.72.90.1 .1.3.6.1.4.1.8072.1.3.2.4.1.2.10.111.117.116.112.117.116.108.111.97.100.1 .1.3.6.1.4.1.8072.1.3.2.4.1.2.14.98.97.116.116.114.117.110.116.105.109.101.101.115.116.1 
```
Or even simpler:
```
snmpwalk -v2c -c tripplite localhost .1.3.6.1.4.1.8072.1.3.2.4.1.2
```
