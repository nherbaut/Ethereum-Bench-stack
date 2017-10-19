/root/docker-compose.yaml:
  file.managed:
    - source:  salt://experiment_data/docker-compose.yaml
    - template: jinja


/root/launch_stack.sh:
  file.managed:
    - source: salt://experiment_data/launch_stack.sh
    - template: jinja
    - mode: 0755



/root/kill_stack.sh:
  file.managed:
    - source: salt://experiment_data/kill_stack.sh
    - mode: 0755

/root/reset_monitoring.sh:
  file.managed:
    - source: salt://experiment_data/reset_monitoring.sh
    - mode: 0755


