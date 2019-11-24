{% set registry_ip=salt["mine.get"]("*","controlpath_ip")["h0"][0] %}
{% set images=salt["pillar.get"]("docker:registry-images")%}


{% for image in images %}
{{registry_ip}}:5000/{{image}}:
  docker_image.present

docker tag {{registry_ip}}:5000/{{image}}  {{image}}:
  cmd.run: []

{% endfor %}

