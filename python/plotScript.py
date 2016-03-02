from pylab import *
from matplotlib import rcParams
import pickle

rcParams['font.family'] = 'FangSong'

f = open("S6.pckl", "rb")
S6 = pickle.load(f)
f.close()
f = open("S67.pckl", "rb")
S67 = pickle.load(f)
f.close()
f = open("Sall.pckl", "rb")
Sall = pickle.load(f)
f.close()



def plotV(Sall):
    for i in range(Sall.secNum):
        h1, = plot(Sall.S[i], Sall.V[i]*3.6, color="black") #, label=u'速度曲线'
        h2, = plot(Sall.S[i], [Sall.secLimit[i]*3.6]*len(Sall.S[i]), color="black", linestyle="--")# , label=u'速度限制'
    
    ylim(0.0,100.0)
    xlim(12100, 13600)
    gca().invert_xaxis()
    xlabel('公里标(m)')
    ylabel('速度(m/s)')
    h1._label = "速度曲线"
    h2._label = "速度限制"
    legend(loc='upper right') # 'upper right'
    savefig("S6.png", dpi=600)
    show()

def plotAllV(Sall, name):
    for i in range(Sall.num):
        for j in range(Sall.interSta[i].secNum):
            h1, = plot(Sall.interSta[i].S[j], Sall.interSta[i].V[j]*3.6, color="black")
            h2, = plot(Sall.interSta[i].S[j], [Sall.interSta[i].secLimit[j]*3.6]*len(Sall.interSta[i].S[j]), color="black", linestyle="--")
    ylim(0.0,100.0)
    gca().invert_xaxis()
    xlabel('公里标(m)')
    ylabel('速度(m/s)')
    h1._label = "速度曲线"
    h2._label = "速度限制"
    legend()
    savefig(name+".png", dpi=600)
    show()
    
plotV(S6)
plotAllV(S67, "S67")
plotAllV(Sall, "Sall")

