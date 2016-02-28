# -*- coding: utf-8 -*-
"""
Created on Sun Feb 28 15:27:47 2016

@author: aixin
"""

Sall2, lateNode, lateTime, extraE = delayFun(Sall, 7, 50)
print("lateNode = ", lateNode)
print("lateTime = ", lateTime)
print("extraE = ", extraE/3.6e6)
SList = [None]*Sall.num
lateNodeList = [None]*Sall.num
lateTimeList = [None]*Sall.num
extraEList = [None]*Sall.num
for i in range(Sall.num):
    SList[i], lateNodeList[i], lateTimeList[i], extraEList[i] = delayFun(Sall, i, 10)
for i in range(Sall.num):
    print(i ," lateNodeList", lateNodeList[i])
    print(i ," lateTimeList", lateTimeList[i])
    print(i ," extraEList", extraEList[i]/3.6e6)
    print("------------------------------------------")