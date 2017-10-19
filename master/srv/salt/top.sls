base:
  "*":
    - hostsfile
    - openssh
    - docker
    - nftables
    - telegraf
  "vm1":
    - experiment_data
    - tickstack:
      - require:
        - sls: docker
