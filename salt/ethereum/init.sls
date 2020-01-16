include:
  - node

/home/vagrant:
  npm.bootstrap
  

ethereum_ppa:
  pkgrepo.managed:
    - name: deb http://ppa.launchpad.net/ethereum/ethereum/ubuntu bionic main
    - ppa: ethereum/ethereum
    - keyid: 1c52189c923f6ca9
    - file: /etc/apt/sources.list.d/ethereum.list
    - keyserver: keyserver.ubuntu.com


ethereum:
  pkg.installed:
    - require:
      - pkgrepo:  ethereum_ppa

solc:
  pkg.installed:
    - require: 
      - pkgrepo: ethereum_ppa


/home/vagrant/ip_list.json:
  file.managed:
    - source: salt://ethereum/ip_list.json
    - template: jinja


/home/vagrant/truffle-config.js:
  file.managed:
    - source: salt://ethereum/truffle-config.js
    - template: jinja

/home/vagrant/graphs:
 file.directory:
    - makedirs: True

/home/vagrant/ethereum/datadir/nodekeys:
 file.directory:
    - makedirs: True

python3-pip:
  pkg.installed

python-tk:
  pkg.installed

#python-deps:
#   pip.installed:
#      - requirements: /home/vagrant/requirements.txt
#      - bin_env: /usr/bin/pip3
#      - require:
#         - pkg: python3-pip