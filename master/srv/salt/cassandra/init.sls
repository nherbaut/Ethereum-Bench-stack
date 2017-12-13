

{% if grains.id in salt['pillar.get']('placement:cassandra:hosts')  %}


/tmp/cassandra_extra.props:
  file.managed:
    - source: salt://init-components/cassandra_extra.props

#if it's not the first node
{% set first_node_name = salt['pillar.get']('placement:cassandra:first_cqlsh_host') %}
{% set first_node =  (grains.id == first_node_name ) %}


cassandra:{{ salt['pillar.get']("placement:cassandra:version")}}:
  docker_image.present: []
  docker_container.running:
    - name: cass
    - image: cassandra:{{ salt['pillar.get']("placement:cassandra:version")}}
    - port_bindings:
      - 7000:7000
      - 7001:7001
      - 7199:7199
      - 9042:9042
      - 9160:9160
    - binds: 
      - /tmp:/tmp
    - environment:
      - CASSANDRA_BROADCAST_ADDRESS : {{ salt['mine.get'](grains.id,"datapath_ip")[grains.id][0] }}
        {% if not first_node %}  
      - CASSANDRA_SEEDS : {{ salt['mine.get'](first_node_name,"datapath_ip")[first_node_name][0] }}
        {% endif %}
    {% if not first_node %}
    - require:
      - cmd: wait_cassandra
    {% endif %}


{% if not first_node %}
wait_cassandra:
  cmd.run:
    - name: sleep 60
{% endif %}

{% endif %}
