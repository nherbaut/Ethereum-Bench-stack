include:
  - docker


nherbaut/smart-ms-stub:latest:
  docker_image.present: []

/var/lib/microservices/monitoring.csv:
  file.absent
  
/var/lib/microservices/:
  file.directory:
    - require: 
      - file: /var/lib/microservices/monitoring.csv
  


microservices_stub:
  docker_container.running:
    - image: nherbaut/smart-ms-stub:latest
    - name: mss
    - port_bindings:
      - 8080:8080
    - environment:
      - ARTEMIS_USERNAME: {{salt["pillar.get"]("broker:user")}}
      - ARTEMIS_PASSWORD: {{salt["pillar.get"]("broker:pwd")}}
      - MONITORING: /var/lib/microservices/monitoring.csv
    - binds: /var/lib/microservices:/var/lib/microservices
    - require:
      - nherbaut/smart-ms-stub:latest

/home/vagrant/init_ms_queues.sh:
  file.managed:
    - template: jinja
    - source: salt://microservices/init_ms_queues.sh
    - mode: 744

/home/vagrant/activate_jms.sh:
  file.managed:
    - template: jinja
    - source: salt://microservices/activate_jms.sh
    - mode: 744

/home/vagrant/deactivate_jms.sh:
  file.managed:
    - template: jinja
    - source: salt://microservices/deactivate_jms.sh
    - mode: 744

