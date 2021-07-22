#!/bin/bash
#start of enabling firewall ports
echo "Enabling firewall ports"
sudo firewall-cmd --permanent --add-port=80/tcp
sudo firewall-cmd --permanent --add-port=443/tcp
sudo firewall-cmd --permanent --add-port=5646/tcp
sudo firewall-cmd --permanent --add-port=5647/tcp
sudo firewall-cmd --permanent --add-port=5671/tcp
sudo firewall-cmd --permanent --add-port=5672/tcp  
sudo firewall-cmd --permanent --add-port=8140/tcp
sudo firewall-cmd --permanent --add-port=9090/tcp 
sudo firewall-cmd --permanent --add-port=53/udp
sudo firewall-cmd --permanent --add-port=53/tcp
sudo firewall-cmd --permanent --add-port=67/udp
sudo firewall-cmd --permanent --add-port=68/udp
sudo firewall-cmd --permanent --add-port=69/udp
sudo firewall-cmd --reload
sudo firewall-cmd --list-all
echo "Finished enabling firewall ports"
#End of enabling firewall ports
