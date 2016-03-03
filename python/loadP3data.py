# -*- coding: utf-8 -*-
"""
Created on Sun Feb 28 23:17:14 2016

@author: aixin
"""
import numpy as np
import pickle
f = open("P3data.pckl","rb")
delayTypeList,delayTimeList, delayNodeList, extraEList, lateNodeList,lateTimeList = pickle.load(f)
f.close()

num = len(delayTypeList)
normDelayTime = 0.
normLateTime = 0.
normLateNum = 0
normExtraE = 0.
severeDelayTime = 0.
severeLateTime = 0.
severeLateNum = 0
severeExtraE = 0.
for i in range(num):
    if delayTypeList[i] == 1:
        normDelayTime += delayTimeList[i]
        normExtraE += extraEList[i]
        if lateTimeList[i]:
            normLateTime += np.sum(lateTimeList[i])
            normLateNum += len(lateNodeList[i])
    elif delayTypeList[i] == 2:
        severeDelayTime += delayTimeList[i]
        severeExtraE += extraEList[i]
        if lateTimeList[i]:
            severeLateTime += np.sum(lateTimeList[i])
            severeLateNum += len(lateNodeList[i])
    else:
        pass

normExtraE = normExtraE / 3.6e6
severeExtraE = severeExtraE / 3.6e6
normNum = delayTypeList.count(1)
severeNum = delayTypeList.count(2)
print("普通延误: ", "平均延误时间 ", normDelayTime/normNum, "平均总晚点时间", normLateTime/normNum, "平均晚点站数", normLateNum/normNum, "平均额外消耗能量", normExtraE/normNum)
print("严重延误: ", "平均延误时间 ", severeDelayTime/severeNum, "平均总晚点时间", severeLateTime/severeNum, "平均晚点站数", severeLateNum/severeNum, "平均额外消耗能量", severeExtraE/severeNum)
