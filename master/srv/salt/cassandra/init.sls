include:
  - docker


{% if salt['pillar.get']('placement:cassandra:'+grains.id, "False")==True  %}

cassandra:latest:
  docker_image.present:
    - require: 
      - sls: docker


{% endif %}  
