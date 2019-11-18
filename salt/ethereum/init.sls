include:
  - node

/home/vagrant:
  npm.bootstrap
  


/home/vagrant/ip_list.json:
  file.managed:
    - source: salt://ethereum/ip_list.json
    - template: jinja


/home/vagrant/truffle-config.js:
  file.managed:
    - source: salt://ethereum/truffle-config.js
    - template: jinja


