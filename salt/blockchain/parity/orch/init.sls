clean parity:
  salt.state:
    - tgt : "*" 
    - sls:
      - blockchain.parity.orch.cleanup

stop parity service and clean everything:
  salt.state:
    - tgt: "*"
    - sls: 
      - blockchain.parity.orch.cleanup

install parity:
  salt.state:
    - tgt: "*"
    - sls:
      -  blockchain.parity

create authorities:
  salt.state:
    - tgt: "*"
    - sls:
      -  blockchain.parity.orch.account-authority


create users:
  salt.state:
    - tgt: "*"
    - sls:
      -  blockchain.parity.orch.account-user



update parity config and relaunch:
  salt.state:
    - tgt: "*"
    - sls:
      -  blockchain.parity.updated


connect parity nodes:
  salt.state:
    - tgt: "*"
    - sls:
      -  blockchain.parity.orch.connect

update parity config and relaunch again:
  salt.state:
    - tgt: "*"
    - sls:
      -  blockchain.parity


connect parity nodes for real:
  salt.state:
    - tgt: "*"
    - sls:
      -  blockchain.parity.orch.connect