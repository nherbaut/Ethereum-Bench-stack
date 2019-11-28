{% for host in salt["mine.get"]("*","datapath_ip").keys() %}

curl -X POST {{host}}:8080/jms

{%endfor%}
