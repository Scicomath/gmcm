import copy

def delayFun(Sall, delayNode, delayTime, first = True):
    lateNode = []
    lateTime = []
    extraE = 0.
    if first:
        Sall2 = copy.deepcopy(Sall)
    else:
        Sall2 = Sall
    originalTime = Sall.interSta[delayNode].totalT
    originalE = Sall.interSta[delayNode].totalE
    originalSecE = copy.deepcopy(Sall.interSta[delayNode].secEnerge)
    targetTime = originalTime - delayTime
    
    for i in range(Sall2.interSta[delayNode].secNum):
        Sall2.interSta[delayNode].secEnerge[i] = 100.*3.6e6
    Sall2.interSta[delayNode].generateSol()
    diffT = Sall2.interSta[delayNode].totalT - targetTime
    if diffT <= 0:
        Sall2.interSta[delayNode].secEnerge = copy.deepcopy(originalSecE)
        Sall2.interSta[delayNode].generateSol()
        while Sall2.interSta[delayNode].totalT > targetTime:
            Sall2.interSta[delayNode].moreE(0.1*3.6e6, verbose=False)
        extraE = Sall2.interSta[delayNode].totalE - originalE
        return Sall2, lateNode, lateTime, extraE
    else:
        lateNode.append(delayNode+1)
        lateTime.append(diffT)
        extraE = Sall2.interSta[delayNode].totalE - originalE
        if delayNode == Sall.num-1:
            return Sall2, lateNode, lateTime, extraE
        first = False
        Sall2, lateNode2, lateTime2, extraE2 = delayFun(Sall2, delayNode+1, diffT, first)
        lateNode += lateNode2
        lateTime += lateTime2
        extraE += extraE2
        return Sall2, lateNode, lateTime, extraE
