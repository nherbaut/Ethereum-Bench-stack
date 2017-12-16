#-*- coding: utf-8 -*-
'''
:maintainer: Nicolas Herbaut
:maturity: 20150910
:requires: none
:platform: all
'''
from spy.spy import get_network_info
import logging
import json

__virtualname__ = 'dspy'

def dump(iface,*args, **kwargs):
  return get_network_info(iface)
