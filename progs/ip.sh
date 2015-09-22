#!/bin/bash

set -x

iptables --flush

# INPUT DROP & OUTPUT ACCEPT
iptables --policy INPUT DROP
iptables --policy OUTPUT ACCEPT

# localhoston i/o accept
iptables -A INPUT -i lo -j ACCEPT
# meglevo kapcs. engedelyezese
iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT

#-------------------------ssh-----------------------#
#iptables -A INPUT -p tcp --dport 8721 -j ACCEPT
iptables -A INPUT -p tcp -i eth0 --dport 3333 -m state --state NEW -j ACCEPT
#-------------------------smtp----------------------#
iptables -A INPUT -p tcp -i eth0 --dport 25 -m state --state NEW -j ACCEPT
#-------------------------domain--------------------#
iptables -A INPUT -p tcp -i eth0 --dport 53 -m state --state NEW -j ACCEPT
#iptables -A INPUT -p udp --dport 53 -j ACCEPT
#-------------------------http----------------------#
iptables -A INPUT -p tcp -i eth0 --dport 80 -m state --state NEW -j ACCEPT
#-----------------------wildfly---------------------#
iptables -A INPUT -p tcp -i eth0 --dport 8080 -m state --state NEW -j ACCEPT
iptables -A INPUT -p tcp -i eth0 --dport 9990 -m state --state NEW -j ACCEPT
#-------------------------pop3----------------------#
iptables -A INPUT -p tcp -i eth0 --dport 110 -m state --state NEW -j ACCEPT
#-------------------------imap----------------------#
iptables -A INPUT -p tcp -i eth0 --dport 143 -m state --state NEW -j ACCEPT

# vedelmek
#-------------------------syn-flood-----------------#
iptables -A FORWARD -p tcp --syn -m limit --limit 1/s -j ACCEPT

#-------------------------portscan------------------#
iptables -A FORWARD -p tcp --tcp-flags SYN,ACK,FIN,RST RST -m limit --limit 1/s -j DROP

#-------------------------ping----------------------#
iptables -A FORWARD -p icmp --icmp-type echo-request -m limit --limit 1/s -j DROP

# log
iptables -A INPUT -j LOG
iptables -A INPUT -j REJECT

