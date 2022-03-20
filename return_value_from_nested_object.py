# -*- coding: utf-8 -*-
"""
Created on Sun Mar 20 20:42:35 2022

@author: User
"""

def get_value(object,key):
    result=[]
    for values in str(object).split(":") [-1]:
        if values.isalpha():
            result.append(values)
    return ''.join([str(i) for i in result])
        
object = {"a":{"b":{"c":"d"}}}
key = "a/b/c"
print(get_value(object, key))