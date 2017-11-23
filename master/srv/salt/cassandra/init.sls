include:
  - docker


{% if salt['pillar.get']('placement:cassandra:'+grains.id, "False")==True  %}

cassandra:latest:
  docker_image.present:
    - require: 
      - sls: docker
  docker_container.running:
    - name: cass 
    - image: cassandra:latest
    - port_bindings:
      - 7000:7000
      - 7001:7001
      - 7199:7199
      - 9042:9042
      - 9160:9160
    - environment:
      - CASSANDRA_SEEDS : vm1


{% endif %}  
