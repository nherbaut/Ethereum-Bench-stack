
python-dev:
  pkg.installed


/tmp/Docker_Spy-0.0.6-py3-none-any.whl:
  file.managed:
    - source: salt://docker_spy/Docker_Spy-0.0.6-py3-none-any.whl



pip install /tmp/Docker_Spy-0.0.6-py3-none-any.whl:
  cmd.run:
    - require:
      - file: /tmp/Docker_Spy-0.0.6-py3-none-any.whl
