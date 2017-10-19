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


nftables:
  pkg.installed

  
nft add table filter:
  cmd.run:
    - require:
      - nftables
    - unless:
        - cmd:
          - run
          - name:
            - nft list table filter

nft flush table filter:
  cmd.run:
    - require:
      - nftables
      - nft add table filter
    - unless:
        - cmd:
          - run
          - name:
            - nft list table filter




nft add chain filter output { type filter hook output priority 0 \; }:
  cmd.run:
    - require:
      - nft add table filter

nft add chain filter input { type filter hook input priority 0 \; }:
  cmd.run:
    - require:
      - nft add table filter

nft add chain filter forward { type filter hook forward priority 0 \; }:
  cmd.run:
    - require:
      - nft add table filter


nft add rule filter input flow table ift  { ip daddr . ip daddr . tcp dport counter}:
  cmd.run:
    - require:
      - nft add table filter


nft add rule filter output flow table oft  { ip saddr . ip daddr .  tcp dport counter}:
  cmd.run:
    - require:
      - nft add table filter

nft add rule filter forward flow table fft  {  ip saddr . ip daddr . tcp dport counter }:
  cmd.run:
    - require:
      - nft add table filter

