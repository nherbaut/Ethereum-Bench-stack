{% set monitoring_host := salt["pillar.get"]("monitoring:host") %}
{% set monitoring_host_ip := salt['mine.get'](monitoring_host, 'controlpath_ip')[monitoring_host][0]  %}

include:
  - docker

chronograf:latest:
  docker_image.present:
    - require:
      - sls: docker


influxdb:latest:
   docker_image.present:
     - require:
       - sls: docker



chronograf:
  docker_container.running:
    - image: chronograf:latest
    - port_bindings:
      - {{  }}:8888:8888
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
