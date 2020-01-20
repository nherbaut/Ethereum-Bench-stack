install ethereum binaries:
  salt.state:
    - tgt: '*'
    - sls:
      - ethereum

host name:
  salt.state:
    - tgt: '*'
    - sls:
      - etchostname

generate keys on master:
  salt.state:
    - tgt: 'h0'
    - sls:
      - ssh-master


distribute keys:
  salt.state:
    - tgt: '*'
    - sls:
      - ssh