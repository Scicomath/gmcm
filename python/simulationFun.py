# -*- coding: utf-8 -*-
"""
Created on Sun Feb 28 18:39:09 2016

@author: aixin
"""
from random import random, randint

def simulation(verbose=True):
    rand = random()
    if rand < 0.7:
        delayType = 0
        delayTime = 0
        delayNode = None
        extraE = 0
        lateNode = None
        lateTime = None
        return delayType, delayTime, delayNode, extraE, lateNode, lateTime
    elif rand < 0.9:
        delayType = 1
        delayTime = 10. * random()
    else:
        delayType = 2
        delayTime = 10 + 110. * random()
    delayNode = randint(0,12)
    Sall2, lateNode, lateTime, extraE = delayFun(Sall, delayNode, delayTime)
    if verbose:
        print("delayType: ", delayType)
        print("delayTime: ", delayTime)
        print("delayNode: ", delayNode)
        print("extraE: ", extraE)
        print("lateNode: ", lateNode)
        print("lateTime: ", lateTime)
    return  delayType, delayTime, delayNode, extraE, lateNode, lateTime