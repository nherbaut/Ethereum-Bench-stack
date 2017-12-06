sudo docker rm -f $(docker ps -qa )  || true && salt "*" mine.update && salt "*" state.apply nftables,telegraf,tickstack
