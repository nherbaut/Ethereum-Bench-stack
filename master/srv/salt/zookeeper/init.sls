{# set zookeeper_image="nherbaut/netcont:sleep" #}
{# set kafka_image="nherbaut/netcont:sleep" #}

{% set zookeeper_image="zookeeper:%s"%salt['pillar.get']("placement:zookeeper:version") %}
{% set kafka_image="nherbaut/kafka:latest" %}


{% if grains.id in salt['pillar.get']('placement:zookeeper:hosts')  %}

  {% set zoospec=[] %}
  {% set kafspec=[] %}
  {% for host in salt['pillar.get']("placement:zookeeper:hosts")  %}
    {% if host == grains.id %}
       {% do zoospec.append("server.%s=%s:2888:3888"%(loop.index,'0.0.0.0')) %} #must bind on all ips when configuring myself (otherwise i'll get the host ip)
    {% else %}
       {% do zoospec.append("server.%s=%s:2888:3888"%(loop.index,salt['mine.get'](host,"datapath_ip")[host][0])) %}
    {% endif %}
       {% do kafspec.append("%s:2181"%(salt['mine.get'](host,"datapath_ip")[host][0])) %}
    
  {% endfor %}


zookeeper_image_pull:{{ salt['pillar.get']("placement:zookeeper:version")}}:
  docker_image.present:
    - name: zookeeper:{{ salt['pillar.get']("placement:zookeeper:version")}}

zookeeper:{{ salt['pillar.get']("placement:zookeeper:version")}}:
  docker_container.running:
    - name: zoo
    - image: zookeeper:{{ salt['pillar.get']("placement:zookeeper:version")}}
    - port_bindings:
      - {{ salt['mine.get'](grains.id,"datapath_ip")[grains.id][0] }}:2181:2181
      - {{ salt['mine.get'](grains.id,"datapath_ip")[grains.id][0] }}:2888:2888
      - {{ salt['mine.get'](grains.id,"datapath_ip")[grains.id][0] }}:3888:3888
    - environment:
      - ZOO_MY_ID: {{ salt['pillar.get']("placement:zookeeper:host_zooid_mapping:%s"%grains.id)}} 
      - ZOO_SERVERS: {{ zoospec|join(" ")}}
    - require:
      - docker_image: zookeeper_image_pull:{{ salt['pillar.get']("placement:zookeeper:version")}}

kafka:
  docker_image.present:
    - name: {{ kafka_image }}
  docker_container.running:
    - name: kafka
    - image: {{ kafka_image }}
    - port_bindings:
      - {{ salt['mine.get'](grains.id,"datapath_ip")[grains.id][0] }}:9092:9092
    - environment:
      - KAFKA_ADVERTISED_HOST_NAME: {{ salt['mine.get'](grains.id,"datapath_ip")[grains.id][0] }}
      - KAFKA_ZOOKEEPER_CONNECT : {{ kafspec|join(",") }}
    - require:
      - docker_container: zookeeper:{{ salt['pillar.get']("placement:zookeeper:version")}}



{% endif %}
