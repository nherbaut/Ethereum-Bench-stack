sudo docker rm -f $(docker ps -qa )  || true && salt "*" state.apply nftables,telegraf,tickstack
