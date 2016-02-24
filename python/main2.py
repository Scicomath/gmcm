#!/usr/bin/python2
# -*- coding: utf-8 -*-
from defClass import *

# 第二问, 第一小问
Sall = Station(1, 14)
Sall.initSolution()
targetT = 2086. - 12*38. # 1630
deltaE = 0.1 * 3.6e6
while Sall.totalT > targetT:
    Sall.moreE(deltaE)


