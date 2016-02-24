#!/usr/bin/python2
# -*- coding: utf-8 -*-
from defClass import *
import unittest
x = Interstation(5)


class trainTestCase(unittest.TestCase):
    def testMaxTractionForce(self):
        # 测试maxTractionForce()方法
        self.failUnless(203.*1000 == x.maxTractionForce(12.), 'maxTractionForce() test failed')
        v = 21. * 3.6
        Fmax = -0.002032 * v**3 + 0.4928 * v**2 - 42.13*v + 1343.
        self.failUnless(x.maxTractionForce(21.) == Fmax*1000., 'maxTractionForce() test failed')
        self.failUnless(x.maxTractionForce(51.5/3.6) == 203.*1000, 'maxTractionForce() test failed')

    def testMaxBrakingForce(self):
        # 测试maxBrakingForce()方法
        self.failUnless(166.*1000 == x.maxBrakingForce(12.), 'maxBrakingForce() test failed')
        v = 22. * 3.6
        Fmax = 0.1343 * v**2 - 25.07 * v + 1300
        self.failUnless(x.maxBrakingForce(22.) == Fmax*1000., 'maxBrakingForce() test failed')
        self.failUnless(x.maxBrakingForce(77./3.6) == 166.*1000, 'maxBrakingForce() test failed')

    def testGroundConditionFun(self):
        # 测试groundConditionFun()函数
        s = 1522.
        gra = -3.158
        cur = 0.
        self.failUnless((gra,cur) == x.groundConditionFun(s), 'groundConditionFun() test failed')
        s = 23136.
        gra = -2.
        cur = 345.
        self.failUnless((gra,cur) == x.groundConditionFun(s), 'groundConditionFun() test failed')

    def testTotalResistanceFun(self):
        v = 64.
        s = 23136.
        A = 2.031
        B = 0.0622
        C = 0.001807
        w0 = A + B*v + C*v**2
        wi = -2.
        wc = 600./345.
        W = (w0 + wi + wc) * 9.8 * x.M / 1000.

        self.failUnless(W == x.totalResistanceFun(v/3.6, s), 'totalResistanceFun() test failed')
unittest.main()
