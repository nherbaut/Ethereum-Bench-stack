include:
  - docker


{% if grains.id in salt['pillar.get']('placement:cassandra:hosts')  %}

cassandra:{{ salt['pillar.get']("placement:cassandra:version")}}:
  docker_image.present:
    - require:
      - sls: docker
  docker_container.running:
    - name: cass
    - image: cassandra:latest
    - port_bindings:
      - 7000:7000
      - 7001:7001
      - 7199:7199
      - 9042:9042
      - 9160:9160
    - environment:
      - CASSANDRA_BROADCAST_ADDRESS : {{ salt['mine.get'](grains.id,"datapath_ip")[grains.id][0] }}
        {% if grains.id != "h5" %}
      - CASSANDRA_SEEDS : {{ salt['mine.get']('h5',"datapath_ip")['h5'][0] }}
        {% endif %}
                          

{% endif %}
