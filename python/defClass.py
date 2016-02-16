# -*- coding: utf-8 -*-
import numpy as np
import copy

speedLimit = np.loadtxt("../data/限速数据.csv", delimiter=",")
nodePosition = np.loadtxt("../data/站点公里标.csv", delimiter=",")

def sectionFun(startNode):
    '''
    计算区间的端点和区间的限速
    '''
    startP = nodePosition[startNode-1, 1]
    endP = nodePosition[startNode, 1]
    for index, ed in enumerate(speedLimit[:,2]):
        if ed >= startP:
            startIndex = index
            break
    for index, ed in enumerate(speedLimit[:,2]):
        if endP < ed:
            endIndex = index
            break
    section = np.zeros((startIndex - endIndex + 1, 2))
    secLimit = np.zeros(startIndex - endIndex + 1)
    for index, val in enumerate(range(startIndex, endIndex-1, -1)):
        section[index, 0] = speedLimit[val, 2]
        section[index, 1] = speedLimit[val, 0]
        secLimit[index] = speedLimit[val, 1]
    section[0,0] = startP
    section[-1,-1] = endP
    return section, secLimit
        

class Interstation:
    '''
    站间行驶方案 class
    '''
    startNode = 1;
    endNode = 2;

    def __init__(self, startNode,targetT, startV = 0., endV = 0.):
        '''
        构造函数
        '''
        self.startNode = startNode    # 起始节点
        self.endNote = startNode + 1; # 终止节点
        self.targetT = targetT        # 目标行驶时间
        self.section, self.secLimit = sectionFun(startNode) # 区间端点 和 区间限制
        self.secNum = len(self.section) # 区间个数
        self.S = [None]*self.secNum     # 初始化位置向量
        self.T = [None]*self.secNum     # 初始化时间向量
        self.F = [None]*self.secNum     # 初始化牵引力向量
        self.B = [None]*self.secNum     # 初始化制动力向量
        self.V = [None]*self.secNum     # 初始化速度向量
        self.usedE = [None]*self.secNum # 初始化使用能量向量
        for i in range(self.secNum):
            secLen = self.section[i,0] - self.section[i,1]
            self.S[i] = np.linspace(self.section[i,0], self.section[i,1], secLen*10+1)
            self.T[i] = np.zeros(len(self.S[i]))
            self.F[i] = np.zeros(len(self.S[i]))
            self.B[i] = np.zeros(len(self.S[i]))
            self.V[i] = np.zeros(len(self.S[i]))
        self.V[0][0] = startV
        self.V[-1][-1] = endV
        # 当前的状态
        self.nowS = self.S[0,0]
        self.nowT = 0.
        self.nowF = 0.
        self.nowB = 0.
        self.nowV = 0.
        self.nowSec = 0
        self.nowIndex = 0
        self.secEnerge = np.zeros(self.secNum)
        self.secLeftE = np.zeros(self.secNum)
        self.totalE = 0.0
        self.totalT = 0.0

    def maxTractionForce(self,v):
        '''
        最大牵引力 方法
        v: 速度 单位 m/s
        返回: 最大牵引力 单位 kN
        '''
        v = v * 3.6
        if v <= 51.5:
            return 203.
        else:
            return -0.002032 * v^3 + 0.4928 * v^2 - 42.13 * v + 1343.

    def maxBreakingForce(self,v):
        '''
        最大制动力 方法
        v: 速度 单位 m/s
        返回: 最大制动力 单位 kN
        '''
        v = v * 3.6
        if v <= 77.0:
            return 166.
        else:
            return 0.1343 * v^2 - 25.07 * v + 1300.

    def breakCurve(s, endV):
        '''
        计算制动曲线方法
        '''
        pass

    def initSolution(self):
        initTargetSpeed = 50. / 3.6 # 初始加速到50 km/h
        while self.nowV < initTargetSpeed:
            self.fullAcce()
        
        while True:
            # 检查是否到达终点, 若到达, 则退出
            if self.nowSec == self.secNum-1 and self.nowIndex == len(self.S[-1]) -1:
                break
            # 若尚未到达, 则继续惰行
            self.coasting()

    def moreE(self, deltaE):
        tempT = np.zeros(self.secNum)
        for i in range(self.secNum):
            temp = copy.deepcopy(self)
            temp.secEnerge[i] += deltaE
            temp.generateSol(i) # 根据重新分配的能量求解
            tempT[i] = temp.totalT
        index = np.argmin(tempT)
        self.secEnerge[index] += deltaE
        self.generateSol(index)

    def fullAcce(self):
        '''
        最大加速
        '''
        
    def coasting(self):
        pass
    def cruising(self):
        pass
    def fullbreaking(self):
        pass
    def generateSol(self, startSec = 0):
        self.nowSec = startSec
        self.nowIndex = 0
        self.updateState()
        for i in range(startSec, self.secNum):
            while self.secLeftE[i] > 0:
                status = self.fullAcce()
                if status:
                    break
            if status == 'cruise':
                while self.secLeftE[i] > 0:
                    status = self.cruising()
                    if status:
                        break
            while True:
                if self.nowIndex == len(self.S[i]) -1:
                    break
                self.coasing()
            self.secEnerge[i] -= self.secLeftE[i]
            self.secLeftE[i] = 0.
            if i != self.secNum:
                self.secEnerge[i+1] += self.secLeftE[i]
            
        
            
        
            


        
