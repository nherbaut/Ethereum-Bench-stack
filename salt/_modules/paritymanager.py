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

def add_parity_to_pillar():
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

def dump(*args, **kwargs):
  add_parity_to_pillar()
  file_exists_guard(PARITY_PILLAR)
  
  
  with open(PARITY_PILLAR,"r+") as target:
    data=yaml.load(target.read())
    if(data is None):
        data={}

  print(data)
  data["salut"]="nounou"

  with open(PARITY_PILLAR,"w") as target:
     yaml.dump(data,target)
  return "nounnou"

