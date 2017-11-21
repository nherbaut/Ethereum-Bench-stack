sudo docker rm -f $(docker ps -qa )  || true && salt "*" state.apply telegraf && salt "{{ salt['pillar.get']('monitoring:monitoring_vm')  }}" state.apply tickstack
