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
    params = {
        'axes.labelsize': 10,
        'font.size': 10,
        'legend.fontsize': 10,
        'xtick.labelsize': 10,
        'ytick.labelsize': 10,
        'text.usetex': False,
        'figure.figsize': [3.8, 3.8],
    }
    rcParams.update(params)
    for i in range(Sall.secNum):
        h1, = plot(Sall.S[i], Sall.V[i]*3.6, color="black", linewidth=1) #, label=u'速度曲线'
        h2, = plot(Sall.S[i], [Sall.secLimit[i]*3.6]*len(Sall.S[i]), color="black", linewidth=1, linestyle="--")
    
    ylim(0.0,100.0)
    xlim(12100, 13600)
    gca().invert_xaxis()
    xlabel('公里标(m)')
    ylabel('速度(m/s)')
    h1._label = "速度曲线"
    h2._label = "速度限制"
    legend(loc='upper right')
    savefig("S6.pdf", dpi=600)
    show()

def plotAllV(Sall, name, figsize):
    params = {
        'figure.figsize': figsize,
    }
    rcParams.update(params)
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
    savefig(name+".pdf", dpi=600)
    show()
    
plotV(S6)
plotAllV(S67, "S67", [3.8, 3.8])
plotAllV(Sall, "Sall", [5, 4])

