#!/bin/bash

#Kevin McKinnon (10089987) worked on this alone

#delete all iptables info
sudo iptables -F

#ssh from 130.15.00-130.15.255.255 only
sudo iptables -A INPUT -s 130.15.0.0/16 -p TCP --dport 22 -j ACCEPT
sudo iptables -A INPUT -p TCP --dport 22 -j REJECT

#ssh from private networks
sudo iptables -A INPUT -s 192.168.0.0/16 -p TCP --dport 22 -j ACCEPT
sudo iptables -A INPUT -s 10.0.0.0/8 -p TCP --dport 22 -j ACCEPT
sudo iptables -A INPUT -s 172.16.0.0/12 -p TCP --dport 22 -j ACCEPT

#http and https from any IP
sudo iptables -A INPUT -p TCP --dport 80 -j ACCEPT  #http
sudo iptables -A INPUT -p TCP --dport 443 -j ACCEPT #https

#any other tcp traffic blocked
sudo iptables -A INPUT -p TCP -j REJECT

#block outgoing to IPs outside 130.15.0.0-130.15.255.255
sudo iptables -A OUTPUT -s 130.15.0.0/16 -j ACCEPT
sudo iptables -A OUTPUT -j REJECT

#only IP 130.15.100.100 can use mysql
sudo iptables -A INPUT -s 130.15.100.100/32 -p TCP --dport 3306 -j ACCEPT
sudo iptables -A INPUT -p TCP --dport 3306 -j REJECT

#drop outgoing ssh traffic
sudo iptables -A OUTPUT -p TCP --dport 22 -j REJECT

#I can't ssh the VM machine because the first rule blocks any IP addresses outside 
#130.15.0.0-130.15.255.255 which I am. To fix this, I should make the first INPUT rule
#the one about letting private networks ssh since I am connecting with a private network

