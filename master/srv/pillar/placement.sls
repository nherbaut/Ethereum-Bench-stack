monitoring:
  - monitoring_vm: vm1
placement:
  - cassandra:
    - vm1: true
    - vm2: true
    - vm3: true
  - kafka:
    - vm1: true
    - vm2: true
    - vm4: true
  - spark:
    - vm1: true
    - vm2: true
  - iperf_server:
    - vm1:
      - running: True
    - vm2:
      - running: True
    - vm3:
      - running: True
  - iperf_client:
    - vm3:
      - running: True
      - target:  vm1
    - vm4:
      - running: True
      - target:  vm2
    - vm2:
      - running: True
      - target: vm1
  
    

  
