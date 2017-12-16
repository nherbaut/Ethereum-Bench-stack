{
"bind_addr": "{{ salt["mine.get"](grains.id,"controlpath_ip")[grains.id][0]  }}", 
"datacenter": "dc1",
"data_dir": "/var/consul",
"encrypt": "EXz7LFN8hpQ4id8EDYiFoQ==",
"log_level": "INFO",
"enable_syslog": true,
"enable_debug": true,
"node_name": "{{ grains.id }}",
"server": true,
"leave_on_terminate": false,
"skip_leave_on_interrupt": true,
"rejoin_after_leave": true,
"retry_join": [ 
{% for k, v in salt["mine.get"]("*","controlpath_ip").items() %}
    "{{ v[0] }}:8301" {{ "," if not loop.last else "" }}
{% endfor %}
  ]
 }
