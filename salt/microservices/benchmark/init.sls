/home/vagrant/run_java_bench.sh:
  file.managed:
    - template: jinja
    - source: salt://microservices/benchmark/run_java_bench.sh
    - mode: 744


