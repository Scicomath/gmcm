import numpy as np

speedLimit = np.loadtxt("../data/限速数据.csv", delimiter=",")
nodePosition = np.loadtxt("../data/站点公里标.csv", delimiter=",")

def sectionFun(startNode, speedLimit, nodePosition):
    startP = nodePosition[startNode-1, 1]
    endP = nodePosition[startNode, 1]
    for index, ed in enumerate(speedLimit[:,2]):
        if ed >= startP:
            startIndex = index
            break
    for index, ed in enumerate(speedLimit[:,2]):
        if endP <= ed:
            endIndex = index
            break
    section = np.zeros((startIndex - endIndex + 1, 2))
    for index, val in enumerate(range(startIndex, endIndex-1, -1)):
        section[index, 0] = speedLimit[val, 2]
        section[index, 1] = speedLimit[val, 0]
    section[0,0] = startP
    section[-1,-1] = endP
    return section
        

class Interstation:
    startNode = 1;
    endNode = 2;

    def __init__(self, startNode):
        self.startNode = startNode
        self.endNote = startNode + 1;
        
