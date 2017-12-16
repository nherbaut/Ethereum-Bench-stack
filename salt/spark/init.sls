
{% set master_hostname = salt['pillar.get']('placement:spark:master') %}
{% set master_ip = salt['mine.get'](master_hostname,"datapath_ip")[master_hostname][0] %}
{% set master_url = "%s:%d"%(master_hostname,7077) %}
{% set etc_hosts_names = [] %}
{% for host in salt['mine.get']("*","datapath_ip") %}
  {% do etc_hosts_names.append("%s %s"%(salt['mine.get']("*","datapath_ip")[host][0],host)) %}
{% endfor %}
{% set etc_hosts_content= etc_hosts_names|join("\\\n") %}
{% if grains.id == salt['pillar.get']('placement:spark:master')  %}

spark_master:
  docker_image.present:
    - name: {{ salt['pillar.get']('placement:spark:image') }} 
  docker_container.running:
    - name: spark
    - hostname: spark
    - image: {{ salt['pillar.get']('placement:spark:image') }}
    - port_bindings:
      - 4040:4040
      - 7077:7077
      - 6066:6066
      - 8080:8080
      - 40000-40004:40000-40004
      - 41000-41004:41000-41004
      - 42000-42004:42000-42004
      - 43000-43004:43000-43004
      - 44000-44004:44000-44004
      - 45000-45004:45000-45004
    - hostname: {{ grains.id }}
    - environment:
      - SPARK_BLOCK_MANAGER_PORT: 40000
      - SPARK_BROADCAST_PORT: 44000
      - SPARK_DRIVER_PORT: 41000
      - SPARK_EXECUTOR_PORT: 42000
      - SPARK_FILESERVER_PORT: 43000
      - SPARK_BROADCAST_PORT: 44000
      - SPART_BLOCKMANAGER_PORT: 45000
      - SPARK_PORT_MAXRETRIES: 4
      - SPARK_MASTER_HOST : {{ master_hostname }}
      - SPARK_MASTER_IP : 0.0.0.0 
      - SPARK_DRIVER_HOST : {{ grains.id }}
      - SPARK_PUBLIC_DNS : {{ grains.id }}
      - SPARK_LOCAL_HOSTNAME: {{ grains.id }}
      - SPARK_IDENT_STRING : {{ grains.id }}
    - command: bash -c 'tail -f `SPARK_MASTER_IP=0.0.0.0 SPARK_MASTER_HOST={{ grains.id }} /opt/spark/sbin/start-master.sh  |sed -rn "s/.*(\/opt.*out)/\1/p"`'
#    - command: bash -c 'sleep 5000'


#since salt do not support add-host yet, work around it

{% for data in etc_hosts_names %}
park_master_add_host {{ data }}:
  cmd.run: 
    - name: docker exec spark bash -c "echo '{{ data }}' >> /etc/hosts"
    - require:
      - docker_container: spark_master
{% endfor %}


{% endif %}  

{% if grains.id in salt['pillar.get']('placement:spark:slaves') %}
{% set slave_ip = salt['mine.get'](grains.id,"datapath_ip")[grains.id][0] %}

spark_slave:
  docker_image.present:
    - name: {{ salt['pillar.get']('placement:spark:image') }}
  docker_container.running:
    - name: spark
    - image: {{ salt['pillar.get']('placement:spark:image') }}
    - hostname: {{ grains.id }}
    - port_bindings:
      - 7077:7077
      - 6066:6066
      - 8081:8081
      - 2606:2606
      - 45000:45004
    - environment:
      - SPARK_BLOCK_MANAGER_PORT: 40000
      - SPARK_BROADCAST_PORT: 44000
      - SPARK_DRIVER_PORT: 41000
      - SPARK_EXECUTOR_PORT: 42000
      - SPARK_FILESERVER_PORT: 43000
      - SPARK_BROADCAST_PORT: 44000
      - SPART_BLOCKMANAGER_PORT: 45000
      - SPARK_PORT_MAXRETRIES: 4
      - SPARK_DRIVER_HOST : {{ grains.id }}
      - SPARK_PUBLIC_DNS : {{ grains.id }}
      - SPARK_LOCAL_HOSTNAME: {{ grains.id }}
      - SPARK_IDENT_STRING : {{ grains.id }}
    - command: bash -c "tail -f `SPARK_MASTER_IP={{ master_ip }} /opt/spark/sbin/start-slave.sh {{ master_url }} --port 2606 |sed -rn 's/.*(\/opt.*out)/\1/p'`"
     
{% for data in etc_hosts_names %}
spark_slave_add_host {{ data }}:
  cmd.run:
    - name: docker exec spark bash -c "echo '{{ data }}' >> /etc/hosts"
    - require:
      - docker_container: spark_slave
{% endfor %}

  
{% endif %} 
