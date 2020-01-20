build-essential:
   pkg.installed

   
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