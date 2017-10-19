sudo docker rm -f $(docker ps -qa ) && salt "vm1" state.apply telegraf && salt "vm1" state.apply tickstack
