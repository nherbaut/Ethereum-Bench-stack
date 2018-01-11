monitoring:
  - host: h0
placement:
  - cassandra:
    - hosts:
      - h0
    - version: 3.11.1
    - first_cqlsh_host: h0
  - zookeeper:
    - hosts : []
    - version: 3.4.11
    - host_zooid_mapping: []
  - kafka:
    - replication_factor : 3
    - partition_factor: 6
    - topic_name: words
  - spark:
    - slaves: []
    - master: []
    - image : nherbaut/spark-wordcount:latest
