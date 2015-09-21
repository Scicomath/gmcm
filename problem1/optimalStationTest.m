clear
readData

load brakingCurve.mat
% As = 6;
% At = 8;
% Time = 220;
% dwellTime = 40;
As = 6;
At = 7;
Time = 110;
dwellTime = [];
% As = 1;
% At = 14;
% Time = 2086 - 75/2*12; % 1636
tic
deltaE = 0.1 * 1000 * 3600; % deltaE 为 0.1 千瓦时
[S,V,T,F,calS,calDist,Acce,interSta,totalT,totalE]=optimalStationAlgo( As,At,dwellTime,Time,speedLimit,gradient,...
    curvature,brakingCurveS,brakingCurveV,curveTerminal,stationP,deltaE);
toc
figure
plot(S,V*3.6)
set(gca,'XDir','reverse')
title('速度路程曲线')

figure
plot(T,V*3.6)
title('时间与速度的关系')

figure
plot(T,Acce)
title('时间与加速度的关系')

figure
plot(T,calDist)
title('时间与计算距离的关系')

figure
plot(T,calS)
title('时间与计算公里标的关系')

figure
plot(T,F)
title('时间与计算牵引力的关系')

