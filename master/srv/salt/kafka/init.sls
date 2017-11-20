include:
  - docker


{% if salt['pillar.get']('placement:kafka:'+grains.id, "False")==True  %}

spotify/kafka:latest:
  docker_image.present:
    - require: 
      - sls: docker


{% endif %}  
