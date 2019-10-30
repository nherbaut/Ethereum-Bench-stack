{% if grains.id ==  salt['pillar.get']('monitoring:host')   %}

chronograf:latest:
  docker_image.present: []


influxdb:latest:
   docker_image.present: []


{% set monitoring_host = salt['pillar.get']('monitoring:host') %}

{% set monitoring_host_ip = salt['mine.get'](grains.id,"datapath_ip")[grains.id][0]  %}


chronograf:
  docker_container.running:
    - image: chronograf:latest
    - port_bindings:
      - {{ monitoring_host_ip }}:8888:8888
    - link: influxdb
    - environment:
      - INFLUXDB_URL=http://{{ monitoring_host_ip  }}:8086
    - require:
      - chronograf:latest
      - influxdb:latest

influxdb:
  docker_container.running:
      - image: influxdb:latest
      - detach: True
      - port_bindings:
        - {{ monitoring_host_ip  }}:8086:8086
      - require:
        - influxdb:latest


{% endif %}