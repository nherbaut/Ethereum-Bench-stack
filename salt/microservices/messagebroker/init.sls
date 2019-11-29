include:
  - docker

vromero/activemq-artemis:2.10.1-alpine:
  docker_image.present: []


artemis:
  docker_container.running:
    - image: vromero/activemq-artemis:2.10.1-alpine
    - name: mb
    - port_bindings:
      - 61616:61616
      - 8161:8161
    - environment:
      - ARTEMIS_USERNAME: {{salt["pillar.get"]("broker:user")}}
      - ARTEMIS_PASSWORD: {{salt["pillar.get"]("broker:pwd")}}
    - require:
      - vromero/activemq-artemis:2.10.1-alpine

