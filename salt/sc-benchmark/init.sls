include:
  - node

build-essential:
   pkg.installed

/opt/benchmark/hyperparams.yml:
   file.managed:
     - source: salt://sc-benchmark/hyperparams.yml
     - template: jinja
     - require: 
        - git: https://github.com/nherbaut/sc-archi-gen.git


/opt/benchmark/ethereum/datadir:
  file.directory:
    - mkdirs: True

   
https://github.com/nherbaut/sc-archi-gen.git:
   git.latest:
     - name: https://github.com/nherbaut/sc-archi-gen.git
     - target: /opt/benchmark
     - force_clone: True
     - force_reset: True
     - rev: supply-chain-bench

/opt/benchmark/ip_list.json:
  file.managed:
    - source: salt://ethereum/ip_list.json
    - template: jinja
    - require:
      - git: https://github.com/nherbaut/sc-archi-gen.git


npm install -g:
  cmd.run:
    - cwd: /opt/benchmark
    - user: root
    - require:
      - git: https://github.com/nherbaut/sc-archi-gen.git
      - pkg: build-essential

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
