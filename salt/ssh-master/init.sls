/home/vagrant/.ssh/authorized_keys:
  file.exists

cat /home/vagrant/.ssh/authorized_keys >>  /root/.ssh/authorized_keys:
  cmd.run:
    - require:
      - file: /home/vagrant/.ssh/authorized_keys


/root/.ssh/id_rsa.pub:
  file.managed:
    - source: salt://ssh/id_rsa.pub
    - mode: 400

/root/.ssh/id_rsa:
  file.managed:
    - source: salt://ssh/id_rsa
    - mode: 400

cat /root/.ssh/id_rsa.pub >> /root/.ssh/authorized_keys:
  cmd.run:
    - require: 
      - file: /root/.ssh/id_rsa.pub
