/root/.ssh/id_rsa.pub:
  file.managed:
    - source: salt://ssh/id_rsa.pub
    - mode: 400

/root/.ssh/id_rsa:
  file.managed:
    - source: salt://ssh/id_rsa
    - mode: 400

