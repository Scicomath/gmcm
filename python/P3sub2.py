# -*- coding: utf-8 -*-
"""
Created on Sun Feb 28 18:51:15 2016

@author: aixin
"""
import pickle
# delayType, delayTime, delayNode, extraE, lateNode, lateTime
simNum = 1000
delayTypeList = [None]*simNum
delayTimeList = [None]*simNum
delayNodeList = [None]*simNum
extraEList = [None]*simNum
lateNodeList = [None]*simNum
lateTimeList = [None]*simNum

for i in range(simNum):
    delayTypeList[i], delayTimeList[i], delayNodeList[i], extraEList[i],\
    lateNodeList[i], lateTimeList[i] = simulation()
    print("----------------------------", i, "/", simNum)

f = open("P3data.pckl","wb")
pickle.dump((delayTypeList,delayTimeList, delayNodeList, extraEList, lateNodeList, lateTimeList),f)
f.close()