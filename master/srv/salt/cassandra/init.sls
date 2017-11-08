include:
  - docker

cassandra:latest:
  docker_image.present:
    - require: 
      - sls: docker
  
