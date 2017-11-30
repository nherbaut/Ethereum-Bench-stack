  {% set zoospec=[] %}
  {% set kafkaspec=[] %}
  {% set cassandraspec=[] %}
  {% for host in salt['pillar.get']("placement:zookeeper:hosts")  %}
       {% set host_ip = salt['mine.get'](host,"datapath_ip")[host][0] %}
       {% do zoospec.append("%s:2181"%host_ip) %}
       {% do kafkaspec.append(host_ip) %}
  {% endfor %}

  {% for host in salt['pillar.get']("placement:cassandra:hosts")  %}
       {% set host_ip = salt['mine.get'](host,"datapath_ip")[host][0] %}
       {% do cassandraspec.append("%s:9092"%host_ip) %}
  {% endfor %}


  {% set zk_servers_ips= zoospec|join(",") %}
  {% set replication_factor=salt['pillar.get']("placement:kafka:replication_factor") %}
  {% set partition_factor=salt['pillar.get']("placement:kafka:partition_factor") %}
  {% set topic_name=salt['pillar.get']("placement:kafka:topic_name") %}




{% if grains.id in salt['pillar.get']('placement:cassandra:hosts')  %}

docker exec cass bash -c "cqlsh < /tmp/cassandra_extra.props":
  cmd.run

{% endif %}


{% if grains.id in salt['pillar.get']("placement:zookeeper:hosts") %}


docker exec kafka bash -c '/opt/kafka*/bin/kafka-topics.sh --create --zookeeper {{ zk_servers_ips }} --replication-factor {{ replication_factor }} --partitions {{ partition_factor }} --topic {{ topic_name }}':
  cmd.run


{% endif %}


{% if grains.id == salt['pillar.get']("placement:spark:master") %}

{% set spark_master_ip  = salt['mine.get'](grains.id,"datapath_ip")[grains.id][0] %}

docker exec -d spark bash -c '/opt/spark/bin/spark-submit  --class org.apache.spark.examples.streaming.DirectKafkaWordCount   --master spark://{{spark_master_ip}}:7077  --deploy-mode client /opt/wordcount/spark-wordcount-1.0-jar-with-dependencies.jar  {{ cassandraspec|join(",") }} {{ topic_name }} {{ kafkaspec|join(",") }}':
  cmd.run


{% endif %}
