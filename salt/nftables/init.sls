# nftables installation


{% if grains.id != salt["pillar.get"]("monitoring:host") %}
apt-transport-https:
  pkg.installed: []


python-software-properties:
  pkg.installed: []


software-properties-common:
  pkg.installed: []



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


{% for hook in ["prerouting","output"]%}
{{hook}}:
  cmd.run:
    - name: nft add chain filter {{hook}} { type filter hook {{hook}} priority 0 \; }
    - require:
      - cmd: nft add table filter

#nft add rule filter {{hook}} flow table ft_{{hook}} { ip saddr . ip daddr . tcp sport . tcp dport  . mark counter}:
#  cmd.run: []

#nft add rule filter {{hook}} flow table fte_{{hook}} { ether saddr . ether daddr . tcp sport . tcp dport  . mark counter}:
#  cmd.run: []
{% endfor %}



{% endif %}
