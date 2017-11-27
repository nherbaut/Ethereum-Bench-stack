/etc/hosts:
  file.managed:
    - source: salt://etchostname/hosts
    - template: jinja
