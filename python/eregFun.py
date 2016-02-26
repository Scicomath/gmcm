# -*- coding: utf-8 -*-
import numpy as np
import copy
def eregFun(brakingSec, brakingSecEreg, tractionSec, diffT):
    newBrakingSec = np.add(brakingSec, diffT)
    eregE = 0.
    for braking, ereg in zip(newBrakingSec, brakingSecEreg):
        for traction in tractionSec:
            lower = np.max([braking[0], traction[0]])
            upper = np.min([braking[1], traction[1]])
            if lower < upper:
                eregE += ereg * (upper - lower) / (braking[1] - braking[0])
    return eregE
