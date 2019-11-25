include:
  - docker


nherbaut/smart-ms-stub:latest:
  docker_image.present: []


microservices_stub:
  docker_container.running:
    - image: nherbaut/smart-ms-stub:latest
    - name: mss
    - port_bindings:
      - 8080:8080
    - link: microservices_stub
    - require:
      - nherbaut/smart-ms-stub:latest

