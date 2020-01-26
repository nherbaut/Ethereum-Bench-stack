{% set authority_nodes_dict = salt["mine.get"]("*","parity_authority") %}
{% set user_nodes_dict = salt["mine.get"]("*","parity_user") %}
{% set ip_nodes_dict = salt["mine.get"]("*","datapath_ip") %}
{%for k in authority_nodes_dict.keys() |sort%}


curl --data '{"jsonrpc":"2.0","method":"personal_sendTransaction","params":[{"from":"{{ user_nodes_dict[k][0] }}","to":"{{ authority_nodes_dict[k][0] }}","value":"0xde0b6b3a7640000"}, "{{k}}"],"id":0}' -H "Content-Type: application/json" -X  POST {{ ip_nodes_dict[k][0] }}:8540


{% endfor %}