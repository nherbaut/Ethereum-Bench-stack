#$1 is the master ip
#$2 is the nic name control
#$3 is the nic name data
#$4 is the minion id

echo "$1 salt" >> /etc/hosts
apt-get update
apt-get install wget apt-transport-https --yes
wget -O - https://repo.saltstack.com/apt/ubuntu/16.04/amd64/latest/SALTSTACK-GPG-KEY.pub | sudo apt-key add -
echo "deb http://repo.saltstack.com/apt/ubuntu/16.04/amd64/latest xenial main" >> /etc/apt/sources.list.d/saltstack.list
apt-get update && apt-get install salt-minion python-pygit2 python-git --yes



echo "rejected_retry: True
id: $4
mine_interval: 1
hostsfile:
  alias: controlpath_ip
mine_functions:
  datapath_ip:
    - mine_function: network.ip_addrs
    - $3
  controlpath_ip:
    - mine_function: network.ip_addrs
    - $2
  docker_spy:
    - mine_function: dspy.dump
    - $3" > /etc/salt/minion



sudo service salt-minion restart
