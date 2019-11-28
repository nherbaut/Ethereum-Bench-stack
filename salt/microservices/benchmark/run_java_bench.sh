curl -H "Content-type: application/json" h2:8080/jms/queues -d @ip_list.json
curl -X POST h2:8080/jms
sleep 2
while true
do
curl -H "Content-type: application/json" h2:8080/START -d @wf.json -v &
sleep 0.5
done

