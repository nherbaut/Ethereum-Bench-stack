include:
  - docker


{% if salt['pillar.get']('placement:spark:'+grains.id, "False")==True  %}

  
gettyimages/spark:
  docker_image.present:
    - require: 
      - sls: docker


{% endif %}  
