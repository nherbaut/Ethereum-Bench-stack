#-*- coding: utf-8 -*-
'''
:maintainer: Nicolas Herbaut
:maturity: 20150910
:requires: none
:platform: all
'''

import yaml
import os
import requests
__virtualname__ = 'pman'

PARITY_PILLAR="/srv/pillar/parity.sls"

def parity_in_top_pillar_gard():
    with open("/srv/pillar/top.sls","r+") as target:
      top=yaml.load(target.read())
      states=top["base"]["*"]
      if "parity" not in states:
          states.append("parity")
          target.seek(0)
          yaml.dump(top,target)
          target.truncate()

def file_exists_guard(f=PARITY_PILLAR):
    if(not os.path.exists(PARITY_PILLAR)):
      with open(PARITY_PILLAR,"w") as target:
          print("creating " + PARITY_PILLAR + " file ")

def register_account(*args, **kwargs):

  url = "http://localhost:8540"

    # Example echo method
  payload = {
    "method": "parity_newAccountFromPhrase",
    "params": ["node0","node0"],
    "jsonrpc": "2.0",
    "id": 0,
  }

  response = requests.post(url, json=payload).json()

  return response["result"]

