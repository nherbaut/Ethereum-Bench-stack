/tmp/Docker_Spy-0.0.2-py2.7.egg:
  file.managed:
    - source: salt://docker_spy/Docker_Spy-0.0.2-py2.7.egg


easy_install /tmp/Docker_Spy-0.0.2-py2.7.egg:
  cmd.run:
    - require:
      - file: /tmp/Docker_Spy-0.0.2-py2.7.egg

{% set contnet = salt['mine.get']("*","docker_spy") %}

{% for host in contnet  %}

  {% for container_name in contnet[host] %}

{% set chain = "output" if host!=grains.id else "filter" %}
echo "you should look at ip {{ contnet[host][container_name]['ip'] }} and ports {{ contnet[host][container_name]["ports"]|join(', ')   }} that container {{ container_name }} on {{ chain }}":
  cmd.run

  {% endfor %} 

{% endfor %}



