bible:
  archive.extracted:
  - name: /root/lorem
  - source: salt://experiment_data/bible.txt.zip
  - enforce_toplevel: False

/root/produce.sh:
  file.managed:
    - source: salt://experiment_data/produce.sh
    - template: jinja
    - mode: 0755


/root/reset_monitoring.sh:
  file.managed:
    - source: salt://experiment_data/reset_monitoring.sh
    - template: jinja
    - mode: 0755


