#!/usr/bin/python2
# -*- coding: utf-8 -*-
from defClass import *

# 第一问, 第一小问
S6 = Interstation(6)
targetT = 110.
deltaE = 0.1 * 3.6e6;
S6.initSolution()  # 求初始解
while S6.totalT > targetT:
    S6.moreE(deltaE)




