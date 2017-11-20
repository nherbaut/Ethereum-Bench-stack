include:
  - docker


{% if salt['pillar.get']('placement:iperf_server:'+grains.id+':running', "False")==True  %}

nherbaut/netcont:
  docker_image.present:
    - require: 
      - sls: docker
  docker_container.running:
    - name: iperf_server
    - image: nherbaut/netcont
    - cmd: iperf -s -p 5000
    - port_bindings:
      - 5000:5000 



{% endif %} 

{% set target= salt['pillar.get']('placement:iperf_client:'+grains.id+':target', "None") %}

{% if salt['pillar.get']('placement:iperf_client:'+grains.id+':running', "False")==True  %}
{% set target_ip = salt['mine.get'](target, 'controlpath_ip')[target][0]  %}

nherbaut/netcont:
  docker_image.present:
    - require:
      - sls: docker
  docker_container.running:
    - name: iperf_client
    - image: nherbaut/netcont
    - cmd: /bin/bash -c "while true; do iperf -c {{ target_ip }} -p 5000; sleep 2; done "



{% endif %} 
