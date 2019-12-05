/root/parity:
  file.directory:
    - mkdirs: True

/root/parity/parity-install.sh:
  file.managed:
    - source: https://get.parity.io/
    - mode: 744
    - skip_verify: True
    - require:
      - file: /root/parity
  cmd.run:
    - name: bash /root/parity/parity-install.sh --release beta
    - onchanges_any:
      - file: /root/parity/parity-install.sh


/usr/bin/parity:
  file.exists:
    - watch: 
      - file: /root/parity/parity-install.sh

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
  module.run:
    - names: 
      - service.systemctl_reload
    - onchanges:
      - file: /usr/bin/parity
      - file: /var/lib/parity
      - file: /etc/parity/chain-config.json
      - file: /etc/parity/config.toml
      - file: /etc/systemd/system/parity.service

parity:
  service.running:
    - require:
      - file: /etc/systemd/system/parity.service


/etc/parity/chain-config.json:
  file.managed:
    - source: salt://blockchain/parity/chain-config.json
    - template: jinja
    - require:
      - file: /usr/bin/parity
      - file: /etc/parity

/etc/parity/config.toml:
  file.managed:
    - source: salt://blockchain/parity/config.toml
    - template: jinja
    - require:
      - file: /usr/bin/parity
      - file: /etc/parity

/etc/parity/node.pwds:
  file.managed:
    - source: salt://blockchain/parity/node.pwds
    - template: jinja
    - require:
      - file: /usr/bin/parity
      - file: /etc/parity

python3-pip:
  pkg.installed

json-rpc:
  pip.installed:
    - bin_env: /usr/bin/pip3
    - require:
      - pkg: python3-pip