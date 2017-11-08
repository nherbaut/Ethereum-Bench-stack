sudo /sbin/iptables -F 
sudo sysctl -w net.ipv4.ip_forward=1
sudo /sbin/iptables -A FORWARD  -j ACCEPT
sudo  /sbin/iptables -t nat -A POSTROUTING  -j MASQUERADE
