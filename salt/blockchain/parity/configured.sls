
parity:
  service.dead: []

/etc/parity:
  file.directory:
    - mkdirs: True


/var/lib/parity:
  file.directory:
    - mkdirs: True

/etc/systemd/system/parity.service:
  file.managed:
    - name: /etc/systemd/system/parity.service
    - source: salt://blockchain/parity/parity.service
    - template: jinja
    - require:
      - file: /etc/parity

/etc/parity/chain-config.json:
  file.managed:
    - source: salt://blockchain/parity/chain-config.json
    - template: jinja
    - require:
      - file: /etc/parity
      

/etc/parity/config.toml:
  file.managed:
    - source: salt://blockchain/parity/config.toml
    - template: jinja
    - require:
      - file: /etc/parity
      

/etc/parity/node.pwds:
  file.managed:
    - source: salt://blockchain/parity/node.pwds
    - template: jinja
    - require:
      - file: /etc/parity


python3-pip:
  pkg.installed

json-rpc:
  pip.installed:
    - bin_env: /usr/bin/pip3
    - require:
      - pkg: python3-pip