#$1 is the master ip
#$2 is the nic name (control)
#$3 is the nic name (data)
#$4 is the minion id

echo "MASTER IP: $1"
echo "CONTROL NIC: $2"
echo "DATA NIC: $3"
echo "Minion id: $4"


echo "" > /etc/apt/sources.list.d/saltstack.list

echo "$1 salt" >> /etc/hosts
apt-get update
apt-get install wget apt-transport-https --yes
wget -O - https://repo.saltstack.com/apt/debian/9/amd64/latest/SALTSTACK-GPG-KEY.pub | sudo apt-key add -
rm -rf /etc/apt/sources.list.d/saltstack.list || true
echo "deb http://repo.saltstack.com/apt/debian/9/amd64/latest stretch main" >> /etc/apt/sources.list.d/saltstack.list
apt-get update
apt-get install salt-master salt-minion python-pygit2 python-git --yes

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

echo "open_mode: True
auto_accept: True
file_roots:
  base:
    - /srv/salt
    - /srv/formulas/hostsfile-formula
    - /srv/formulas/openssh-formula
    - /srv/formulas/docker-formula

" > /etc/salt/master

rm -rf archive*
mkdir archive
wget https://gricad-gitlab.univ-grenoble-alpes.fr/vqgroup/salt-master/repository/master/archive.tar.bz2
tar -C ./archive -xvf ./archive.tar.bz2
cp -r archive/salt-master*/master/srv /
service salt-master restart
service salt-minion restart
sleep 3
salt "*" test.ping
