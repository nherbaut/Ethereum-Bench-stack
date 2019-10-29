passwordless_login:
  ssh_auth.present:
    - user: root
    - source: salt://ssh/id_rsa.pub
    - config: '%h/.ssh/authorized_keys'
