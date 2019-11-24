

#install docker and configure docker damemon to allow unsecure registry to make user nodes can download docker images from the salt-master
install_docker:
  salt.state:
    - tgt: "*"
    - sls:
      - docker
      - docker.unsecure_registry

# read a list of docker images to download form the docker hub in pillar/docker.sls. Make sure that this images are available through the master docker image registry
pull_docker_images:
  salt.state:
    - tgt: 'h0'
    - sls:
      - docker.load_registry

# tell the nodes to download all the docker images from the master registry
disseminate_docker_images:
  salt.state:
    - tgt: '*'
    - sls:
      - docker.pull_local_registry


# launch the monitoring tools
launch_tickstack:
  salt.state:
    - tgt: "h0"
    - sls:
      - monitoring.tickstack
      - monitoring.nftables
      - monitoring.telegraf




# make sure that every custom module is available on every node (include our custom module docker_spy)
sync_modules:
  salt.function:
    - name: saltutil.sync_all
    - tgt: "*"

# make sure that we have and fresh copy of the salt-mine (including our docker_spy mine function that provide info on the running container of every machine)
refresh_mine:
  salt.function:
    - name: mine.update
    - tgt: '*'

# from the info collected through docker_spy, populate the netfilter tables so we can monitor container2container traffic
nftables:
  salt.state:
    - tgt: "*"
    - sls:
      - monitoring.nftables
      - monitoring.telegraf


