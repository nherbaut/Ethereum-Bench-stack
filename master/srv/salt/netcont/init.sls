include:
  - docker
  - docker_spy


{% if grains.id in salt['pillar.get']('placement:iperf_server:hosts')  %}

server from {{ grains.id }}:
  docker_image.present:
    - name: nherbaut/netcont
    - require:
      - sls: docker
  docker_container.running:
    - name: ipsrv
    - image: nherbaut/netcont
    - cmd: iperf -s -p 5000
    - port_bindings:
      - 5000:5000

{% elif grains.id in salt['pillar.get']('placement:iperf_client:hosts')  %}

{% set target= salt['pillar.get']('placement:iperf_target:'+grains.id, "None") %}
{% set target_ip = salt['mine.get'](target, 'datapath_ip')[target][0]  %}

client to {{ target_ip }}:
  docker_image.present:
    - name: nherbaut/netcont
    - require:
      - sls: docker
  docker_container.running:
    - name: ipcli
    - image: nherbaut/netcont
    - cmd: /bin/bash -c "while true; do iperf -c {{ target_ip }} -p 5000; sleep 2; done "

{% endif %}
