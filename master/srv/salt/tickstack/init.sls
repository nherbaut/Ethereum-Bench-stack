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
      - {{ salt['mine.get']('vm1', 'network.ip_addrs')['vm1'][0] }}:8888:8888
    - link: influxdb
    - environment:
      - INFLUXDB_URL=http://{{ salt['mine.get']('vm1', 'network.ip_addrs')['vm1'][0] }}:8086
    - require:
      - chronograf:latest
      - influxdb:latest

influxdb:
  docker_container.running:
      - image: influxdb:latest
      - detach: True
      - port_bindings:
        - {{ salt['mine.get']('vm1', 'network.ip_addrs')['vm1'][0] }}:8086:8086
      - require:
        - influxdb:latest
        

