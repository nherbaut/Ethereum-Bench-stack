ethereum_ppa:
  pkgrepo.managed:
    - name: deb http://ppa.launchpad.net/ethereum/ethereum/ubuntu bionic main
    - ppa: ethereum/ethereum
    - keyid: 1c52189c923f6ca9
    - file: /etc/apt/sources.list.d/ethereum.list
    - keyserver: keyserver.ubuntu.com


ethereum:
  pkg.installed:
    - requires: ethereum_ppa.pkgrepo

solc:
  pkg.installed:
    - requires: ethereum_ppa.pkgrepo

truffle@5.0.5:
  npm.installed


ganache-cli@6.7.0:
  npm.installed

ssh2:
  npm.installed

web3:
  npm.installed

/opt/sc-archi-gen/ip_list.json:
  file.managed:
    - source: salt://ethereum/ip_list.json
    - template: jinja


/opt/sc-archi-gen/truffle-config.js:
  file.managed:
    - source: salt://ethereum/truffle-config.js
    - template: jinja