docker stack rm mystack 
salt "*" cmd.run "docker swarm leave -f"
