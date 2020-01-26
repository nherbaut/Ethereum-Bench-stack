/home/vagrant:
  file.directory:
    - mkdirs: True

/home/vagrant/parity-start.sh:
  file.managed:
    - mode: 744
    - source: salt://blockchain/parity/parity-start.sh
    - required:
      - file: /home/vagrant

/home/vagrant/parity-stop.sh:
  file.managed:
    - mode: 744
    - source: salt://blockchain/parity/parity-stop.sh
    - required:
      - file: /home/vagrant



