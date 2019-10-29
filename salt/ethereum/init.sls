ethereum_ppa:
  pkgrepo.managed:
    - name: deb http://ppa.launchpad.net/ethereum/ethereum/ubuntu bionic main
    - ppa: ethereum/ethereum
    - keyid: 1c52189c923f6ca9
    - file: /etc/apt/sources.list.d/ethereum.list


ethereum:
  pkg.installed:
    - requires: ethereum_ppa.pkgrepo

solc:
  pkg.installed:
    - requires: ethereum_ppa.pkgrepo


/opt/sc-archi-gen/ip_list.json:
  file.managed:
    - source: salt://ethereum/ip_list.json
    - template: jinja
