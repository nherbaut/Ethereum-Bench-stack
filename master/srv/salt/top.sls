base:
  "*":
    - hostsfile
    - openssh
    - docker
    - spark
    - kafka
    - cassandra
  "vm[2-9]":
    - match: pcre
    - nftables
    - telegraf
  "vm1":
    - experiment_data
    - tickstack
