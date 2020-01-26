/var/cache/apt/archives/:
  file.directory:
    - mkdirs: True



/var/cache/apt/archives/fether_0.4.2_amd64.deb:
  file.managed:
    - source: https://github.com/paritytech/fether/releases/download/v0.4.2-beta/fether_0.4.2_amd64.deb
    - source_hash: 07f351fdc9d5b3d8d2e659ace73a5f49
    - require: 
      - file: /var/cache/apt/archives/


dpkg -i /var/cache/apt/archives/fether_0.4.2_amd64.deb:
  cmd.run:
    - require:
      - file: /var/cache/apt/archives/fether_0.4.2_amd64.deb
