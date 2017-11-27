# nftables installation

apt-transport-https:
  pkg.installed

#nftables-ppa:
#  pkgrepo.managed:
#    - humanname: erGW team PPA
#    - name: deb http://ppa.launchpad.net/ergw/backports/ubuntu xenial main
#    - dist: xenial
#    - file: /etc/apt/sources.list.d/nftables.list
#    - keyid: 01305F4CF29AFD6AD18309C074EA811C58A14C3D
#    - keyserver: keyserver.ubuntu.com
#    - required_in:
#      - nftables
#    - require:
#      - apt-transport-https


nftables:
  pkg.installed:
    - required_in:
      - nft flush ruleset


nft flush ruleset:
  cmd.run

nft add table filter:
  cmd.run:
    - check_cmd:
      - nft list table filter


prerouting:
  cmd.run:
    - name: nft add chain filter prerouting { type filter hook prerouting priority 0 \; }
    - require:
      - cmd: nft add table filter


{% set contnet = salt['mine.get']("*","docker_spy") %}
{% set local_containers = salt['mine.get'](grains.id,"docker_spy")[grains.id]|default ([]) %}
{% for remote_host in contnet  %}
  {% for container_name in contnet[remote_host] %}
    {% for port in contnet[remote_host][container_name]["ports"] %}
      {% for local_container in local_containers  %}
         {% set host_ip=contnet[remote_host][container_name]['ip'] %}
         {% set remote_container_ip=contnet[remote_host][container_name]['private_ip'] %}
         {% set local_container_ip=local_containers[local_container]['private_ip'] %}
         {% if remote_host != grains.id %}
           {% set outbound_chain=remote_host+"_"+container_name+"_"+grains.id+"_"+local_container %}
           {% set inbound_chain=grains.id+"_"+local_container+"_"+remote_host+"_"+container_name %}

inbound_chain {{ inbound_chain }}:
  cmd.run:
    - name: nft add chain filter {{ inbound_chain }}
    - require:
      - cmd: prerouting

outbound_chain {{ outbound_chain }}:
  cmd.run:
    - name: nft add chain filter {{ outbound_chain }}
    - require:
      - cmd: prerouting

inbound_chain_counter {{ inbound_chain }}:
  cmd.run:
    - name: nft add rule filter {{ inbound_chain }} counter
    - require:
      - cmd: inbound_chain {{ inbound_chain }}

outbound_chain_counter {{ outbound_chain }}:
  cmd.run:
    - name: nft add rule filter {{ outbound_chain }} counter
    - require:
      - cmd: outbound_chain {{ outbound_chain }}


nft add rule filter prerouting  ip saddr . ip daddr . tcp sport { {{ host_ip }} . {{ local_container_ip }} .  {{ port }} }   jump {{ inbound_chain }}:
  cmd.run:
   - require:
     - cmd: inbound_chain_counter {{ inbound_chain }}


nft add rule filter prerouting  ip daddr . ip saddr . tcp dport { {{ host_ip }} . {{ local_container_ip }} .  {{ port }} }   jump {{ outbound_chain }}:
  cmd.run:
   - require:
     - cmd: outbound_chain_counter {{ outbound_chain }}




         {% endif %}


echo "you should look at host {{ remote_host }} with ip {{host_ip}} and port {{ port }} and container {{ container_name }} ( {{ remote_container_ip }} ) to your container {{ local_container  }} ({{ local_container_ip }}":
  cmd.run


      {% endfor %}
    {% endfor %}
  {% endfor %}

{% endfor %}
