consul-binary:
  archive.extracted:
    - name: /usr/local/bin/
    - source: {{ salt["pillar.get"]("consul_download_link") }} 
    - source_hash: https://releases.hashicorp.com/consul/1.0.1/consul_1.0.1_SHA256SUMS
    - source_hash_update: True
    - enforce_toplevel: False

consul_systemd_unit:
  file.managed:
    - name: /etc/systemd/system/consul.service
    - source: salt://consul/consul.service.tpl
    - template: jinja
  module.run:
    - name: service.systemctl_reload
    - watch:
      - consul-binary

consul:
  service.running:
    - watch:
      - module: consul_systemd_unit
      - file: /etc/consul.d/server/config.json
    - require:
       - module:
          consul_systemd_unit

/etc/consul.d/server/config.json:
  file.managed:
    - source: salt://consul/server/config.json.tpl
    - template: jinja
    - makedirs: True
