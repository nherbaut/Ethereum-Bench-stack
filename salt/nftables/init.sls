# nftables installation


{% if grains.id != salt["pillar.get"]("monitoring:host") %}
apt-transport-https:
  pkg.installed: []


python-software-properties:
  pkg.installed: []


software-properties-common:
  pkg.installed: []



nftables-ppa:
  pkgrepo.managed:
    - humanname: erGW team PPA
    - name: deb http://ppa.launchpad.net/ergw/backports/ubuntu xenial main
    - dist: xenial
    - file: /etc/apt/sources.list.d/nftables.list
    - keyid: 01305F4CF29AFD6AD18309C074EA811C58A14C3D
    - keyserver: keyserver.ubuntu.com
    - required_in:
      - nftables
    - require:
      - pkg: apt-transport-https
      - pkg: python-software-properties
      - pkg: software-properties-common


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


{% for hook in ["prerouting","postrouting","input","output","forward"]%}
{{hook}}:
  cmd.run:
    - name: nft add chain filter {{hook}} { type filter hook {{hook}} priority 0 \; }
    - require:
      - cmd: nft add table filter

nft add rule filter {{hook}} flow table ft_{{hook}} { ip saddr . ip daddr . tcp sport . tcp dport  . mark counter}:
  cmd.run: []

nft add rule filter {{hook}} flow table fte_{{hook}} { ether saddr . ether daddr . tcp sport . tcp dport  . mark counter}:
  cmd.run: []
{% endfor %}


{% set contnet = salt['mine.get']("*","docker_spy") %}
{% set local_containers = salt['mine.get'](grains.id,"docker_spy")[grains.id]|default ([]) %}

{% for remote_host in contnet  %}
  {% for remote_container, remote_container_config in contnet[remote_host].iteritems() %}
    {% for port in remote_container_config["ports"] %}
      {% for local_container in local_containers  %}
         {% set host_ip=remote_container_config['ip'] %}
         {% set remote_container_ip=remote_container_config['private_ip'] %}
         {% set local_container_ip=local_containers[local_container]['private_ip'] %}
         {% if remote_host != grains.id or remote_container!=local_container %}
           {% set outbound_chain=grains.id+"_"+local_container+"_"+remote_host+"_"+remote_container+"_%d"%port %}
           {% set inbound_chain= remote_host+"_"+remote_container+"_"+grains.id+"_"+local_container+'_%d'%port%}





inbound_chain {{ inbound_chain }}:
  cmd.run:
    - name: nft add chain filter {{ inbound_chain }}
    - require:
      - cmd: prerouting
    - required_in:
      - cmd: inbound_chain_counter {{ inbound_chain }}
      - cmd: inbound_jump {{ host_ip }} . {{ local_container_ip }} .  {{ port }}  -> {{ inbound_chain }}


inbound_chain_counter {{ inbound_chain }}:
  cmd.run:
    - name: nft add rule filter {{ inbound_chain }} counter




{% if grains.id==remote_host %}
inbound_jump {{ host_ip }} . {{ local_container_ip }} .  {{ port }} -> {{ inbound_chain }} :
  cmd.run:
   - name: nft add rule filter output ip saddr . ip daddr . tcp sport { {{host_ip}} . {{local_container_ip}} . {{port}} } jump {{inbound_chain}}
{% else %}

inbound_jump {{ host_ip }} . {{ local_container_ip }} .  {{ port }}  -> {{ inbound_chain }}:
  cmd.run:
   - name: nft add rule filter prerouting  ip saddr . ip daddr . tcp sport { {{ host_ip }} . {{ local_container_ip }} .  {{ port }} }   jump {{ inbound_chain }}

{% endif %}




outbound_chain {{ outbound_chain }}:
  cmd.run:
    - name: nft add chain filter {{ outbound_chain }}
    - require:
      - cmd: prerouting
    - required_in:
      - cmd: outbound_jump {{ host_ip }} . {{ local_container_ip }} .  {{ port }} -> {{ outbound_chain }}
      - cmd:  outbound_chain_counter {{ outbound_chain }}


outbound_chain_counter {{ outbound_chain }}:
  cmd.run:
    - name: nft add rule filter {{ outbound_chain }} counter



outbound_jump {{ host_ip }} . {{ local_container_ip }} .  {{ port }} -> {{ outbound_chain }} :
  cmd.run:
   - name: nft add rule filter prerouting  ip daddr . ip saddr . tcp dport { {{ host_ip }} . {{ local_container_ip }} .  {{ port }} }   jump {{ outbound_chain }}




         {% endif %}
      {% endfor %}
    {% endfor %}
  {% endfor %}

{% endfor %}
{% endif %}
