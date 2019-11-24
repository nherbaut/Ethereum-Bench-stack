{% set registry_ip=salt["mine.get"]("*","controlpath_ip")["h0"][0] %}
{% set images=salt["pillar.get"]("docker:registry-images")%}


registry:
  docker_container.running:
    - port_bindings:
      - 5000:5000
    - restart: unless-stopped
    - image: registry:2

{% for image in images %}
{{image}}:
  docker_image.present

tag {{image}}:
  cmd.run:
    - name: docker tag {{image}} {{registry_ip}}:5000/{{image}}
    - require:
      - docker_container: registry
      - docker_image: {{image}}

docker push {{registry_ip}}:5000/{{image}}:
  cmd.run:
    - require:
      - cmd: tag {{image}}


{% endfor %}

