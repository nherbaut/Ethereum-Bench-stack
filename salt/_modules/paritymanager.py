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
import random

__virtualname__ = 'pman'

PARITY_PILLAR="/srv/pillar/parity.sls"

def get_local_ip():
    res="http://%s:8540"%(__salt__["mine.get"](__grains__["id"],"datapath_ip")[__grains__["id"]][0])
    
    return res

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


def create_user_account(*args, **kwargs):

  grains_id=__grains__["id"]
  
  
  count=int(__pillar__["parity"]["client_count"])
  
  signatures=[]
  for i in range(0,count):
    
    passphrase="user "+grains_id+" "+str(i)
    payload = {
        "method": "parity_newAccountFromPhrase",
        "params": [passphrase,grains_id],
        "jsonrpc": "2.0",
        "id": 0,
    }
    try:
        response = requests.post(get_local_ip(), json=payload)
        response=response.json()
        account_signature = response["result"]
        set_account_meta(account_signature[2:],"role","user")
        set_account_meta(account_signature[2:],"passphrase",passphrase)
        signatures.append(account_signature)
    except:
        break

  return signatures


  



def create_authority_account(*args, **kwargs):

    grains_id=__grains__["id"]


    # Example echo method




    payload = {
        "method": "parity_newAccountFromPhrase",
        "params": [grains_id,grains_id],
        "jsonrpc": "2.0",
        "id": 0,
    }
    try:
        response = requests.post(get_local_ip(), json=payload)
        response=response.json()
        account_signature = response["result"]
        set_account_meta(account_signature[2:],"role","authority")
        return account_signature
    except:
        return

  


def create_account(passphrase,passphrase_recover,role,*args, **kwargs):

  grains_id=__grains__["id"]

    # Example echo method
  payload = {
    "method": "parity_newAccountFromPhrase",
    "params": [passphrase,passphrase_recover],
    "jsonrpc": "2.0",
    "id": 0,
  }

  try:
    response = requests.post(get_local_ip(), json=payload)
    response=response.json()
    account_signature = response["result"]
    set_account_meta(account_signature[2:],"role",role)


    return account_signature
  except:
      return


def list_accounts(*args, **kwargs):
    payload = {
        "method": "parity_allAccountsInfo",
        "params": [],
        "jsonrpc": "2.0",
        "id": 1,
    }
    try:
        response = requests.post(get_local_ip(), json=payload).json()
        return [k for k in response["result"].keys()]
    except:
        return


def list_accounts_details(*args, **kwargs):
    payload = {
        "method": "parity_allAccountsInfo",
        "params": [],
        "jsonrpc": "2.0",
        "id": 1,
    }
    try:
        response = requests.post(get_local_ip(), json=payload).json()
        return response
    except Exception as e :
        return "failed to contact server"

    


def set_account_name(*args,**kwargs):
    account,name = args[0], args[1]
    payload = {
        "method": "parity_setAccountName",
        #that because salt somehow convert the 32 byte hex to an integer...
        "params": ["0x"+account,name],
        "jsonrpc": "2.0",
        "id": 1,
    }
    try:
        response = requests.post(get_local_ip(), json=payload)
        return response.json()
    except:
        return

def set_account_meta(account,key,value,*args,**kwargs):

    payload = {
        "method": "parity_allAccountsInfo",
        "params": [],
        "jsonrpc": "2.0",
        "id": 1,
    }

    previous_meta = eval(requests.post(get_local_ip(), json=payload).json()["result"]["0x"+account]["meta"])

    previous_meta[key]=value

    meta=("%s"%str(previous_meta)).replace("'",'"')

    payload = {
        "method": "parity_setAccountMeta",
        #that because salt somehow convert the 32 byte hex to an integer...
        #"params": ["0x"+account,"%s"%str(previous_meta)],
        "params": ["0x"+account,meta],
        
        "jsonrpc": "2.0",
        "id": 1,
    }

    print(payload)
    try:
        response = requests.post(get_local_ip(), json=payload)
        print("@@@@@@@@@@@@@@@@@")
        print(response)
        print("@@@@@@@@@@@@@@@@@")
        return previous_meta
    except Exception as e:
        print("*********************")
        print(res)
        print("****************")
        return

def get_accounts_by_name(name,*args,**kwargs):
    payload = {
        "method": "parity_allAccountsInfo",
        "params": [],
        "jsonrpc": "2.0",
        "id": 1,
    }

    try:
        response = requests.post(get_local_ip(), json=payload).json()
        return [k for (k,v) in response.items() if v["name"]==name]
    except:
        return

    
    


def get_accounts_by_meta(key,value,*args,**kwargs):
    payload = {
        "method": "parity_allAccountsInfo",
        "params": [],
        "jsonrpc": "2.0",
        "id": 1,
    }

    try:
        response = requests.post(get_local_ip(), json=payload).json()["result"]

        return [k for (k,v) in response.items() if eval(v["meta"]).get(key,"")==value]
    except:
        return 

def get_enode(*args,**kwargs):
    payload = {
        "method": "parity_enode",
        "params": [],
        "jsonrpc": "2.0",
        "id": 1,
    }
    try:
        response= requests.post(get_local_ip(), json=payload).json()["result"]
        return response
    except:
        return



def register_addReservedPeer(*args,**kwargs):
    
    print(__salt__["mine.get"]("*","parity_enode").items())
    for k,v in __salt__["mine.get"]("*","parity_enode").items():
        if k!=__grains__["id"]:
            try:
                payload = {
                    "method": "parity_addReservedPeer",
                    "params": [v],
                    "jsonrpc": "2.0",
                    "id": 0,
                }
                print(payload)
                response= requests.post(get_local_ip(), json=payload).json()
                print(response)
            except:
                return False
    return True

    
    

    