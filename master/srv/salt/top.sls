base:
  "*":
    - hostsfile
    - openssh
    - docker
    - spark
    - kafka
    - cassandra
    - nftables
    - consul
  "vm[2-9]":
    - match: pcre
    - telegraf
  "vm1":
    - experiment_data
    - tickstack
