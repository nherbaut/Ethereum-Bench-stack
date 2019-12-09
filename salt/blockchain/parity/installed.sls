/root/parity:
  file.directory:
    - mkdirs: True
    
/root/parity/parity-install.sh:
  file.managed:
    - source: https://get.parity.io/
    - mode: 744
    - skip_verify: True
    - source_hash: 485263cea8c6eb55a2e30aa632358afd
    - require:
      - file: /root/parity
  cmd.run:
    - name: bash /root/parity/parity-install.sh --release stable
    - onchanges_any:
      - file: /root/parity/parity-install.sh
