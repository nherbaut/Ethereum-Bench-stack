parity:
  service.dead: []
  
/var/lib/parity remove:
  file.absent:
    - name: /var/lib/parity
    - require:
      - service: parity

/var/lib/parity creation:
  file.directory:
    - name: /var/lib/parity
    - mkdir: True
    - require:
      - service: parity

/etc/parity remove:
  file.absent:
    - name: /etc/parity
    - require:
      - service: parity

