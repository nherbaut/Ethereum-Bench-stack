/home/vagrant/parity-send-dummy-transactions.sh:
  file.managed:
    - template: jinja
    - mode: 744
    - source: salt://blockchain/parity/parity-send-dummy-transactions.sh
    - required:
      - file: /home/vagrant

/home/vagrant/parity-check-authority-balance.sh:
  file.managed:
    - template: jinja
    - mode: 744
    - source: salt://blockchain/parity/parity-check-authority-balance.sh
    - required:
      - file: /home/vagrant


/home/vagrant/parity-check-user-balance.sh:
  file.managed:
    - template: jinja
    - mode: 744
    - source: salt://blockchain/parity/parity-check-user-balance.sh
    - required:
      - file: /home/vagrant