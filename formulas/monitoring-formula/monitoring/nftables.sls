# nftables installation

{% set ignore_list = salt["pillar.get"]("monitoring:ignore") %}

apt-transport-https:
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

nft add chain filter output { type filter hook output priority 0 \; }:
  cmd.run

nft add chain filter input { type filter hook input priority 0 \; }: 
  cmd.run


{% set local_host_ip = salt["mine.get"](grains.id,"datapath_ip")[grains.id][0] %}

{% for remote_host_name, remote_host_ip  in salt["mine.get"]("*","datapath_ip").iteritems() %}


{% if grains.id != remote_host_name %}
nft add chain filter {{grains.id}}_{{remote_host_name}}:
  cmd.run

nft add rule filter {{grains.id}}_{{remote_host_name}} counter:
  cmd.run

nft add rule filter output  ip saddr . ip daddr  { {{ local_host_ip }} . {{ remote_host_ip[0] }} }   jump {{grains.id}}_{{remote_host_name}}:
  cmd.run
{% endif %}


{% if grains.id != remote_host_name %}
nft add chain filter {{remote_host_name}}_{{grains.id}}:
  cmd.run

nft add rule filter {{remote_host_name}}_{{grains.id}} counter:
  cmd.run

nft add rule filter input  ip daddr . ip saddr  { {{ local_host_ip }} . {{ remote_host_ip[0] }} }   jump {{remote_host_name}}_{{grains.id}}:
  cmd.run
{% endif %}



{% endfor %}
