{{ show_full_context() }}

echo "create the swarm"
docker swarm init --advertise-addr {{ salt['mine.get']('vm1', 'datapath_ip')['vm1'][0] }}
echo "get the token"
SWARM_TOKEN=$(docker swarm join-token worker -q)
echo "tell minions to join the swarm"
salt "*" cmd.run "docker swarm join --token $SWARM_TOKEN {{ salt['mine.get']('vm1', 'datapath_ip')['vm1'][0] }}:2377" 
echo "drain the master"
docker node update --availability drain vm1

echo "start the stack"
docker stack deploy mystack --compose-file ./docker-compose.yaml
