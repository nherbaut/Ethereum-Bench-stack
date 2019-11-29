build-essential:
  pkg.installed

psmisc:
  pkg.installed

python3:
  pkg.installed

python3-pip:
  pkg.installed

python-pip:
  pkg.installed

backports.ssl-match-hostname:
  pip.removed

python-backports.ssl-match-hostname:
  pkg.installed

netifaces:
  pip.installed:
    -  bin_env: /usr/bin/pip3

