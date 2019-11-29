{% for host in salt["mine.get"]("*","datapath_ip").keys() %}

curl -X DELETE {{host}}:8080/jms

{%endfor%}
