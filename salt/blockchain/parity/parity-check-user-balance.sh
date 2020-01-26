{% set authority_nodes_dict = salt["mine.get"]("*","parity_authority") %}
{% set user_nodes_dict = salt["mine.get"]("*","parity_user") %}
{% set ip_nodes_dict = salt["mine.get"]("*","datapath_ip") %}
{%for k in authority_nodes_dict.keys() |sort%}



curl --data '{"jsonrpc":"2.0","method":"eth_getBalance","params":["{{ user_nodes_dict[k][0] }}", "latest"],"id":1}' -H "Content-Type: application/json" -X POST {{ ip_nodes_dict["h0"][0] }}:8540




{% endfor %}