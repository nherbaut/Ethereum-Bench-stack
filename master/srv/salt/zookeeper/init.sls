include:
  - docker


{% if grains.id in salt['pillar.get']('placement:zookeeper:hosts')  %}

  {% set zoospec=[] %}
  {% for host in salt['pillar.get']("placement:zookeeper:hosts")  %}
    {% if host == grains.id %}
       {% do zoospec.append("server.%s=%s:2888:3888"%(loop.index,'0.0.0.0')) %} #must bind on all ips when configuring myself (otherwise i'll get the host ip)
    {% else %}
       {% do zoospec.append("server.%s=%s:2888:3888"%(loop.index,salt['mine.get'](host,"datapath_ip")[host][0])) %}
    {% endif %}
    
  {% endfor %}


zookeeper:{{ salt['pillar.get']("placement:zookeeper:version")}}:
  docker_image.present:
    - require:
      - sls: docker
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



#     - ZOO_SERVERS: server.1=zoo1:2888:3888 server.2=zoo2:2888:3888 server.3=zoo3:2888:3888


{% endif %}
