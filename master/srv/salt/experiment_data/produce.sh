  {%- set kafkaspec=[] -%}
  {%- for host in salt['pillar.get']("placement:zookeeper:hosts")  -%}
       {%- set host_ip = salt['mine.get'](host,"datapath_ip")[host][0] -%}
       {%- do kafkaspec.append("%s:%d"%(host_ip,9092)) -%}
  {%- endfor -%}


  {%- set topic_name=salt['pillar.get']("placement:kafka:topic_name") -%}



docker run -v /root/lorem:/tmp/lorem nherbaut/kafka:latest bash -c 'cat /tmp/lorem/bible.txt | /opt/kafka*/bin/kafka-console-producer.sh --broker-list {{ kafkaspec|join(",") }} --topic {{ topic_name }}'
