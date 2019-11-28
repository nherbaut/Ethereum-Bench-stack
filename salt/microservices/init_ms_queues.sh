{% for host in salt["mine.get"]("*","datapath_ip").keys() %}

curl -H "Content-type: application/json" {{host}}:8080/jms/queues -d @ip_list.json

{%endfor%}
