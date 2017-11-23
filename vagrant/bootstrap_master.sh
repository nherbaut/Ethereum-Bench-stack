#$1 is the master ip
#$2 is the nic name

echo "$1 salt" >> /etc/hosts
apt-get update
apt-get install wget
wget -O - https://repo.saltstack.com/apt/ubuntu/16.04/amd64/latest/SALTSTACK-GPG-KEY.pub | sudo apt-key add -
echo "deb http://repo.saltstack.com/apt/ubuntu/16.04/amd64/latest xenial main" >> /etc/apt/sources.list.d/saltstack.list
apt-get update
apt-get install salt-master salt-minion python-pygit2 python-git --yes

echo "\n
rejected_retry: True

mine_interval: 1

hostsfile:
   alias: controlpath_ip

mine_functions:
  datapath_ip:
    - mine_function: network.ip_addrs
    - $2
  controlpath_ip:
    - mine_function: network.ip_addrs
    - $2
  docker_spy:
    - mine_function: dspy.dump
    - $2" > /etc/salt/minion

echo "\n

open_mode: True
auto_accept: True
file_roots:
  base:
    - /srv/salt
    - /srv/formulas/hostsfile-formula
    - /srv/formulas/openssh-formula
    - /srv/formulas/docker-formula
    
" > /etc/salt/master

sudo service salt-master restart
sudo service salt-minion restart
