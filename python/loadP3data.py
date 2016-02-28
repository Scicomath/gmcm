# -*- coding: utf-8 -*-
"""
Created on Sun Feb 28 23:17:14 2016

@author: aixin
"""
import pickle
f = open("P3data.pckl","rb")
delayTypeList,delayTimeList, delayNodeList, extraEList, lateNodeList,lateTimeList = pickle.load(f)
f.close()
