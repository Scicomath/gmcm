# -*- coding: utf-8 -*-
"""
Created on Sat Feb 27 13:37:11 2016

@author: aixin
"""
def addTFun(sec, addT):
    return [[x+addT for x in row] for row in sec]
tractionSec = []
brakingSec = []
tractionIndex = []
brakingIndex = []
brakingSecEreg = Sall.brakingSecEreg[:]
addT = 0.
for i in range(Sall.num):
    tractionSec += addTFun(Sall.interSta[i].tractionSec,addT)
    brakingSec += addTFun(Sall.interSta[i].brakingSec, addT)
    tractionIndex += [i]*len(Sall.interSta[i].tractionSec)
    brakingIndex += [i]*len(Sall.interSta[i].brakingSec)
    addT += Sall.interSta[i].totalT



def objectFun(stopTime, diffT):
    cumStopTime = np.append(0,np.cumsum(stopTime))
    newTraction = np.array(tractionSec)
    newBraking = np.array(brakingSec)
    for i in range(len(newTraction)):
        newTraction[i] += cumStopTime[tractionIndex[i]]

    for i in range(len(newBraking)):
        newBraking[i] += cumStopTime[brakingIndex[i]]
    eregE = eregFun(newBraking, brakingSecEreg, newTraction, diffT)
    return eregE