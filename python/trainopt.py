# -*- coding: utf-8 -*-
import numpy as np
import copy
import matplotlib.pyplot as plt

speedLimit = np.loadtxt("../data/限速数据.csv", delimiter=",")
nodePosition = np.loadtxt("../data/站点公里标.csv", delimiter=",")
gradient = np.loadtxt("../data/坡度数据.csv", delimiter=",")
curvature = np.loadtxt("../data/曲率数据.csv", delimiter=",")


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
        secLimit[index] = speedLimit[val, 1] / 3.6 # 转换为m/s
    section[0,0] = startP
    section[-1,-1] = endP
    return section, secLimit
        

class Interstation:
    '''
    站间行驶方案 class
    '''
    def __init__(self, startNode):
        '''
        构造函数
        '''
        self.startNode = startNode    # 起始节点
        self.endNote = startNode + 1; # 终止节点
        # 列车参数
        self.M = 194295 # 列车质量 kg
        # 列车基本阻力参数
        self.constA = 2.031
        self.constB = 0.0622
        self.constC = 0.001807
        self.constc = 600 # c为综合反映影响曲线阻力许多因素的经验常数，我国轨道交通一般取600
        self.section, self.secLimit = sectionFun(startNode) # 区间端点 和 区间限制
        self.secNum = len(self.section) # 区间个数
        self.S = [None]*self.secNum     # 初始化位置向量
        self.T = [None]*self.secNum     # 初始化时间向量
        self.F = [None]*self.secNum     # 初始化牵引力向量
        self.B = [None]*self.secNum     # 初始化制动力向量
        self.V = [None]*self.secNum     # 初始化速度向量
        self.A = [None]*self.secNum
        self.usedE = [None]*self.secNum # 初始化使用能量向量
        for i in range(self.secNum):
            secLen = self.section[i,0] - self.section[i,1]
            self.S[i] = np.linspace(self.section[i,0], self.section[i,1], secLen*10+1)
            self.T[i] = np.zeros(len(self.S[i]))
            self.F[i] = np.zeros(len(self.S[i]))
            self.B[i] = np.zeros(len(self.S[i]))
            self.V[i] = np.zeros(len(self.S[i]))
            self.A[i] = np.zeros(len(self.S[i]))
            self.usedE[i] = np.zeros(len(self.S[i]))
        
        # 区间限速制动曲线
        self.brakingSec = []
        self.brakingSecEreg = []
        self.brakingV = [None]*self.secNum
        self.brakingEreg = [None]*self.secNum
        self.brakingB = [None]*self.secNum
        self.brakingA = [None]*self.secNum
        for i in range(1,self.secNum):
            if self.secLimit[i] < self.secLimit[i-1]:
                self.brakingV[i-1], self.brakingEreg[i-1], self.brakingB[i-1], self.brakingA[i-1] \
                    = self.brakingCurveFun(i-1)
        self.endBrakingFun()
        # 当前的状态
        self.now = [0,0] # 状态变量, 第一个元素为区间索引, 第二个元素为区间内索引
        self.secEnerge = np.zeros(self.secNum)
        self.secLeftE = np.zeros(self.secNum)
        self.extraE = np.zeros(self.secNum)
        self.totalE = 0.0
        self.totalT = 0.0


    def maxTractionForce(self,v):
        '''
        最大牵引力 方法
        v: 速度 单位 m/s
        返回: 最大牵引力 单位 N
        '''
        v = v * 3.6
        if v <= 51.5:
            T = 203.
        else:
            T = -0.002032 * v**3 + 0.4928 * v**2 - 42.13 * v + 1343.
        T *= 1000. # 转换为N
        return T

    def maxBrakingForce(self,v):
        '''
        最大制动力 方法
        v: 速度 单位 m/s
        返回: 最大制动力 单位 N
        '''
        v = v * 3.6
        if v <= 77.0:
            B = 166.
        else:
            B = 0.1343 * v**2 - 25.07 * v + 1300.
        B *= 1000.
        return B

    @staticmethod
    def groundConditionFun(s):
        '''
        计算位置s处的坡度和曲率以及折算坡度
        '''
        # 计算坡度
        index = (gradient[:,2] > s).argmax()
        i = -gradient[index,1] # 坡度反号, 因为是反向行驶
        # 计算曲率
        index = (curvature[:,2] > s).argmax()
        R = curvature[index,1]

        return i, R
    
    def totalResistanceFun(self, v, s):
        '''
        计算位置s处 速度为v时的总阻力
        '''
        v = v * 3.6
        g = 9.8
        # 基本阻力
        w0 = self.constA + self.constB * v + self.constC * (v**2)
        # 附加阻力
        i, R = self.groundConditionFun(s)
        wi = i
        if R == 0:
            wc = 0
        else:
            wc = self.constc / R
        W = (w0 + wi + wc) * g * self.M / 1000.
        #print(W, w0, wi, wc)
        return W

    def brakingCurveFun(self, index):
        '''
        计算区间制动曲线
        '''
        S = self.S[index][::-1]
        Ereg = np.zeros(len(S))
        A = np.zeros(len(S))
        B = np.zeros(len(S))
        V = np.zeros(len(S))
        T = np.zeros(len(S))
        V[0] = self.secLimit[index+1] # 最终速度
        for i in range(1,len(S)):
            Bmax = self.maxBrakingForce(V[i-1])
            W = self.totalResistanceFun(V[i-1], S[i-1])
            capacityMaxA = (Bmax + W) / self.M
            if capacityMaxA > 1.:
                a = 1.
                B[i] = a * self.M - W
            else:
                a = capacityMaxA
                B[i] = Bmax
            A[i] = -a
            V[i] = np.sqrt(V[i-1]**2 + 2 * a * (S[i]-S[i-1]))
            Emech = 0.5*self.M*(V[i]**2 - V[i-1]**2)
            Ef = W * (S[i] - S[i-1])
            Ereg[i] = Ereg[i-1] + (Emech - Ef) * 0.95
        return V[::-1], Ereg[::-1], B[::-1], A[::-1] 

    def endBrakingFun(self):
        '''
        计算终点制动曲线
        '''
        self.endBrakingV = [None]*self.secNum
        self.endBrakingEreg = [None]*self.secNum
        self.endBrakingB = [None]*self.secNum
        self.endBrakingA = [None]*self.secNum
        for i in range(self.secNum):
            self.endBrakingV[i] = np.zeros(len(self.S[i]))
            self.endBrakingEreg[i] = np.zeros(len(self.S[i]))
            self.endBrakingB[i] = np.zeros(len(self.S[i]))
            self.endBrakingA[i] = np.zeros(len(self.S[i]))

        for i in range(self.secNum-1, -1, -1):
            if i == self.secNum-1:
                self.endBrakingV[i][-1] = 0.
                self.endBrakingEreg[i][-1] = 0.
            else:
                self.endBrakingV[i][-1] = self.endBrakingV[i+1][0]
                self.endBrakingEreg[i][-1] = self.endBrakingEreg[i+1][0]
                self.endBrakingA[i][-1] = self.endBrakingA[i+1][0]
                self.endBrakingB[i][-1] = self.endBrakingB[i+1][0]
            for j in range(len(self.endBrakingV[i])-2, -1, -1):
                Bmax = self.maxBrakingForce(self.endBrakingV[i][j+1])
                W = self.totalResistanceFun(self.endBrakingV[i][j+1], self.S[i][j+1])
                capacityMaxA = (Bmax + W) / self.M
                if capacityMaxA > 1:
                    a = 1.
                    self.endBrakingB[i][j] = a * self.M - W
                else:
                    a = capacityMaxA
                    self.endBrakingB[i][j] = Bmax
                self.endBrakingA[i][j] = -a
                self.endBrakingV[i][j] = np.sqrt(self.endBrakingV[i][j+1]**2 + 2*a*(self.S[i][j]-self.S[i][j+1]))
                Emech = 0.5*self.M*(self.endBrakingV[i][j]**2 - self.endBrakingV[i][j+1]**2)
                Ef = W * (self.S[i][j] - self.S[i][j+1])
                self.endBrakingEreg[i][j] = self.endBrakingEreg[i][j+1] + (Emech - Ef) * 0.95
        

    def initSolution(self, cruisLen = 0):
        self.now = [0, 0]
        sec = self.now[0]
        index = self.now[1]
        initTargetSpeed = 50. / 3.6 # 初始加速到50 km/h
        self.extraE = np.zeros(self.secNum)        
        while self.V[sec][index] < initTargetSpeed:
            self.fullAcce()
            sec = self.now[0]
            index = self.now[1]

        for i in range(cruisLen):
            self.cruising(initTargetSpeed)

        state = None
        while True:
            # 检查是否到达终点, 若到达, 则退出
            if self.now == [self.secNum-1, len(self.S[-1])-1]:
                break
            if state == 'stop':
                cruisLen += 1000
                self.initSolution(cruisLen)
                return None
            # 若尚未到达, 则继续惰行
            state = self.coasting()
            sec = self.now[0]
            index = self.now[1]

        self.totalE = 0.
        for i in range(self.secNum):
            self.secEnerge[i] = np.sum(self.usedE[i])
            self.secLeftE[i] = self.secEnerge[i]
            self.totalE += self.secEnerge[i] + self.extraE[i]
        self.totalT = self.T[-1][-1]

    def moreE(self, deltaE, index = None, verbose = True):
        if index == None:
            diffT = np.zeros(self.secNum)
            diffE = np.zeros(self.secNum)
            for i in range(self.secNum):
                temp = copy.deepcopy(self)
                temp.secEnerge[i] += deltaE
                temp.generateSol(i) # 根据重新分配的能量求解
                diffT[i] = self.totalT - temp.totalT
                diffE[i] = temp.totalE - self.totalE
            index = np.argmin(diffE/diffT)
        #print("index = ", index)
        self.secEnerge[index] += deltaE
        self.generateSol(index)
        if verbose:
            print("Interstation: ","totalT =",self.totalT,", totalE =",self.totalE/3.6e6)
        return index
    
    def next(self):
        sec = self.now[0]
        index = self.now[1]
        if index == len(self.S[sec])-1:
            if sec == self.secNum -1:
                return None
            else:
                sec += 1
                index = 1
                self.V[sec][0] = self.V[sec-1][-1]
                self.A[sec][0] = self.A[sec-1][-1]
                self.B[sec][0] = self.B[sec-1][-1]
                self.F[sec][0] = self.F[sec-1][-1]
                self.T[sec][0] = self.T[sec-1][-1]
                nextState = (sec, index)
                return nextState
        else:
            index += 1
            nextState = (sec, index)
            return nextState

    def fullAcce(self):
        '''
        最大加速
        '''
        sec = self.now[0]
        index = self.now[1]
        nextState = self.next()
        if nextState != None:
            nextSec = nextState[0]
            nextIndex = nextState[1]
            Fmax = self.maxTractionForce(self.V[sec][index])
            W = self.totalResistanceFun(self.V[sec][index], self.S[sec][index])
            capacityMaxA = (Fmax - W) / self.M
            if capacityMaxA > 1.:
                a = 1.
                self.F[sec][index] = a * self.M + W
            else:
                a = capacityMaxA
                self.F[sec][index] = Fmax
            self.A[sec][index] = a
            diffS = self.S[sec][index] - self.S[nextSec][nextIndex]
            self.usedE[nextSec][nextIndex] = self.F[sec][index] * diffS
            self.secLeftE[nextSec] -= self.usedE[nextSec][nextIndex]
            self.V[nextSec][nextIndex] = np.sqrt(self.V[sec][index]**2 + 2 * a * diffS)
            aveV = (self.V[sec][index] + self.V[nextSec][nextIndex]) / 2
            self.T[nextSec][nextIndex] = self.T[sec][index] + diffS / aveV
            if self.V[nextSec][nextIndex] > self.endBrakingV[nextSec][nextIndex]:
                self.fullbreaking('endBraking')
            elif self.brakingV[nextSec] != None and (self.V[nextSec][nextIndex] > self.brakingV[nextSec][nextIndex]):
                self.fullbreaking('secBraking')
            elif self.V[nextSec][nextIndex] >= self.secLimit[nextSec]:
                return 'cruising'
            else:
                self.now = list(nextState)

    def coasting(self):
        sec = self.now[0]
        index = self.now[1]
        nextState = self.next()
        
        if nextState != None:
            nextSec = nextState[0]
            nextIndex = nextState[1]
            diffS = self.S[sec][index] - self.S[nextSec][nextIndex]
            W = self.totalResistanceFun(self.V[sec][index], self.S[sec][index])
            a = -W / self.M
            if a < -0.08:
                a = -0.08
                F = a * self.M + W
                self.F[sec][index] = F
                self.extraE[nextSec] += F * diffS
                #self.usedE[nextSec][nextIndex] = F * diffS
                #self.secLeftE[nextSec] -= self.usedE[nextSec][nextIndex]
            self.A[sec][index] = a
            V2 = self.V[sec][index]**2 + 2 * a * diffS
            if V2 < 0:
                print(self.startNode, sec, index, 'stop')
                return 'stop'
            self.V[nextSec][nextIndex] = np.sqrt(V2)
            aveV = (self.V[sec][index] + self.V[nextSec][nextIndex]) / 2
            self.T[nextSec][nextIndex] = self.T[sec][index] + diffS / aveV
            if self.V[nextSec][nextIndex] > self.endBrakingV[nextSec][nextIndex]:
                self.fullbreaking('endBraking')
            else:
                if self.brakingV[nextSec] != None:
                    if self.V[nextSec][nextIndex] > self.brakingV[nextSec][nextIndex]:
                        self.fullbreaking('secBraking')
                    else:
                        self.now = list(nextState)
                else:
                    self.now = list(nextState)

    def cruising(self, cruisV = None):
        sec = self.now[0]
        index = self.now[1]
        nextState = self.next()
        if nextState != None:
            nextSec = nextState[0]
            nextIndex = nextState[1]
            W = self.totalResistanceFun(self.V[sec][index], self.S[sec][index])
            diffS = self.S[sec][index] - self.S[nextSec][nextIndex]
            if cruisV == None:
                cruisV = self.secLimit[nextSec]
            a = (cruisV**2 - self.V[sec][index]**2) / (2. * diffS)
            self.A[sec][index] = a
            F = self.M * a + W
            if F > 0:
                self.F[sec][index] = F
                self.usedE[nextSec][nextIndex] = self.F[sec][index] * diffS
                self.secLeftE[nextSec] -= self.usedE[nextSec][nextIndex]
            else:
                self.B[sec][index] = -F
            self.V[nextSec][nextIndex] = cruisV
            aveV = (self.V[sec][index] + self.V[nextSec][nextIndex]) / 2.
            self.T[nextSec][nextIndex] = self.T[sec][index] + diffS / aveV
            if self.V[nextSec][nextIndex] > self.endBrakingV[nextSec][nextIndex]:
                self.fullbreaking('endBraking')
            elif self.brakingV[nextSec] != None and (self.V[nextSec][nextIndex] > self.brakingV[nextSec][nextIndex]):
                self.fullbreaking('secBraking')
            else:
                self.now = list(nextState)
                
    def fullbreaking(self, type):
        nextState = self.next()
        sec = nextState[0]
        index = nextState[1]
        if type == 'endBraking':
            for i in range(sec, self.secNum):
                if i == sec:
                    for j in range(index, len(self.S[i])):
                        self.V[i][j] = self.endBrakingV[i][j]
                        self.B[i][j] = self.endBrakingB[i][j]
                        self.A[i][j] = self.endBrakingA[i][j]
                        self.F[i][j] = 0.
                        aveV = (self.V[i][j] + self.V[i][j-1]) / 2.
                        diffS = self.S[i][j-1] - self.S[i][j]
                        self.T[i][j] = self.T[i][j-1] + diffS / aveV
                else:
                    self.V[i][0] = self.V[i-1][-1]
                    self.A[i][0] = self.A[i-1][-1]
                    self.B[i][0] = self.B[i-1][-1]
                    self.F[i][0] = self.F[i-1][-1]
                    self.T[i][0] = self.T[i-1][-1]
                    for j in range(1, len(self.S[i])):
                        self.V[i][j] = self.endBrakingV[i][j]
                        self.B[i][j] = self.endBrakingB[i][j]
                        self.A[i][j] = self.endBrakingA[i][j]
                        self.F[i][j] = 0.
                        aveV = (self.V[i][j] + self.V[i][j-1]) / 2.
                        diffS = self.S[i][j-1] - self.S[i][j]
                        self.T[i][j] = self.T[i][j-1] + diffS / aveV
            self.now = [self.secNum-1, len(self.S[-1])-1]
            self.brakingSec.append([self.T[sec][index], self.T[self.now[0]][self.now[1]] ])
            self.brakingSecEreg.append(self.endBrakingEreg[sec][index])
        if type == 'secBraking':
            for i in range(index, len(self.S[sec])):
                self.V[sec][i] = self.brakingV[sec][i]
                self.B[sec][i] = self.brakingB[sec][i]
                self.A[sec][i] = self.brakingA[sec][i]
                self.F[sec][i] = 0.
                aveV = (self.V[sec][i] + self.V[sec][i-1]) / 2.
                diffS = self.S[sec][i-1] - self.S[sec][i]
                self.T[sec][i] = self.T[sec][i-1] + diffS / aveV
            self.now = [self.secNum-1, len(self.S[-1])-1]
            self.brakingSec.append([self.T[sec][index], self.T[self.now[0]][self.now[1]]])
            self.brakingSecEreg.append(self.brakingEreg[sec][index])            

    def ended(self):
        if self.now == [self.secNum-1, len(self.S[-1])-1]:
            return True
        else:
            return False

    def secEnded(self):
        if self.now[1] == len(self.S[self.now[0]])-1:
            return True
        else:
            return False
    def getTractionInfo(self):
        tractionSec = []
        for i in range(self.secNum):
            F1 = self.F[i][0]
            if F1 > 0:
                tractionSec.append([self.T[i][0], None])
            for j in range(len(self.S[i])-1):
                F1 = self.F[i][j]
                F2 = self.F[i][j+1]
                if F1 == 0 and F2 > 0:
                    tractionSec.append([self.T[i][j+1], None])
                elif F1 > 0 and F2 == 0:
                    tractionSec[-1][1] = self.T[i][j]
                else:
                    pass
                if tractionSec[-1][1] == None:
                    tractionSec[-1][1] = self.T[i][-1]
        self.tractionSec = [tractionSec[0]]
        for i in range(1, len(tractionSec)):
            if tractionSec[i][0] == self.tractionSec[-1][-1]:
                self.tractionSec[-1][-1] = tractionSec[i][1]
            else:
                self.tractionSec.append(tractionSec[i])
                
    def generateSol(self, startSec = 0):
        self.brakingSec = []
        self.brakingSecEreg = []
        self.now = [startSec, 0]
        # self.extraE = np.zeros(self.secNum)
        state = None
        #for i in range(self.secNum):
        #    self.secLeftE[i] = self.secEnerge[i]
        for i in range(startSec, self.secNum):
            self.extraE[i] = 0.
            self.secLeftE[i] = self.secEnerge[i]
            self.now[1] = 0
            while self.secLeftE[i] > 10. and (not self.secEnded()):
                state = self.fullAcce()
                if state == 'cruising':
                    break
            if state == 'cruising':
                while self.secLeftE[i] > 10. and (not self.secEnded()):
                    self.cruising()
            while not self.secEnded():
                self.coasting()
            if self.next() != None:
                self.now = list(self.next())
            
            if i != self.secNum - 1:
                self.secEnerge[i+1] += self.secLeftE[i]
            self.secEnerge[i] -= self.secLeftE[i]
            self.secLeftE[i] = 0.
        # 修正加速度和力的区间端点偏差
        for i in range(self.secNum-1):
            self.A[i][-1] = self.A[i+1][0]
            self.F[i][-1] = self.F[i+1][0]
            self.B[i][-1] = self.B[i+1][0]
        self.totalT = self.T[-1][-1]
        self.totalE = np.sum(self.secEnerge) + np.sum(self.extraE)
        self.getTractionInfo()

    def plotV(self):
        for i in range(self.secNum):
            plt.plot(self.S[i], self.V[i]*3.6)
        plt.gca().invert_xaxis()
        plt.show()
class Station:
    def __init__(self, startNode, endNode):
        self.startNode = startNode
        self.endNode = endNode
        self.num = endNode - startNode
        self.interSta = [None]*self.num
        for i in range(self.num):
            self.interSta[i] = Interstation(startNode + i)
        
    def initSolution(self):
        self.totalE = 0.
        self.totalT = 0.
        for i in range(self.num):
            self.interSta[i].initSolution()
            self.totalT += self.interSta[i].totalT
            self.totalE += self.interSta[i].totalE
            print(i, "init over")
        print("init over")

    def moreE(self, deltaE):
        diffE = np.zeros(self.num)
        diffT = np.zeros(self.num)
        tempIndex = [None]*self.num
        for i in range(self.num):
            temp = copy.deepcopy(self.interSta[i])
            tempIndex[i] = temp.moreE(deltaE, verbose = False)
            diffE[i] = temp.totalE - self.interSta[i].totalE
            diffT[i] = self.interSta[i].totalT - temp.totalT
            # print("Index ", i, "diffE =", diffE[i], "diffT =", diffT[i])
        index = np.argmin(diffE / diffT)
        self.interSta[index].moreE(deltaE, tempIndex[index], verbose = False)
        self.totalT = 0.
        self.totalE = 0.
        for i in range(self.num):
            self.totalT += self.interSta[i].totalT
            self.totalE += self.interSta[i].totalE
        print("Station: ","totalT =",self.totalT,", totalE =",self.totalE/3.6e6)

    def adjustTime(self, brakingSec, addT):
        newBrakingSec = copy.deepcopy(brakingSec)
        for i in range(len(brakingSec)):
            for j in range(len(brakingSec[i])):
                newBrakingSec[i][j] = brakingSec[i][j] + addT
        return newBrakingSec
        
    def getBrakingInfo(self):
        self.brakingSec = []
        self.brakingSecEreg = []
        for i in range(self.num):
            addT = 0.
            for j in range(i):
                addT += self.interSta[j].totalT + 35.
            self.brakingSec += self.adjustTime(self.interSta[i].brakingSec, addT)
            self.brakingSecEreg += self.interSta[i].brakingSecEreg

    def getTractionInfo(self):
        self.tractionSec = []
        for i in range(self.num):
            addT = 0.
            for j in range(i):
                addT += self.interSta[j].totalT + 35.
            self.tractionSec += self.adjustTime(self.interSta[i].tractionSec, addT)
