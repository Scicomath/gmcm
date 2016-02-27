import matplotlib.pyplot as plt
import numpy as np
from eregFun import *
eregVec = np.zeros(2051)
for i in range(2051):
    eregVec[i] = eregFun(Sall.brakingSec, Sall.brakingSecEreg, Sall.tractionSec, i)
plt.plot(eregVec/3.6e6)
plt.show()
