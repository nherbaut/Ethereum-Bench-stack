{% set contnet = salt['mine.get']("*","docker_spy") %}

{% for host in contnet  %}

  {% for container_name in contnet[host] %}

echo "you should look at ip {{ contnet[host][container_name]['ip'] }} and ports {{ contnet[host][container_name]["ports"]|join(', ')   }} that container {{ container_name }}":
  cmd.run

  {% endfor %} 

{% endfor %}



