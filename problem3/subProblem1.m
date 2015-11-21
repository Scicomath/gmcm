clear
addpath ../problem1
addpath ../problem2
readData

load brakingCurve.mat
load problem2stage1.mat
j = 8;

delayTime = 10;
[ delayS,delayV,delayT,delayF,delaycalS,delaycalDist,delayAcce,delaytotalT,delaytotalE,brakingTerminal,lateTime ] =...
    delayFun( j,delayTime,interSta,speedLimit,gradient,curvature,...
    brakingCurveS,brakingCurveV,curveTerminal,stationP );

disp(lateTime)


enery = zeros(12,1);
time = zeros(12,1);
lateTime = zeros(12,1);

for i=2:13
    
   [ enery(i-1),time(i-1),lateTime(i-1) ]=normalDelayFun(i,interSta,speedLimit,gradient,curvature,brakingCurveS,brakingCurveV,curveTerminal,stationP);
end

 

figure
plot(S,V*3.6,delayS,delayV*3.6)
set(gca,'XDir','reverse')
title('速度路程曲线')

figure
plot(T,V*3.6,delayT,delayV*3.6)
title('时间与速度的关系')

figure
plot(T,Acce,delayT,delayAcce)
title('时间与加速度的关系')

figure
plot(T,calDist,delayT,delaycalDist)
title('时间与计算距离的关系')

figure
plot(T,calS,delayT,delaycalS)
title('时间与计算公里标的关系')

figure
plot(T,F,delayT,delayF)
title('时间与计算牵引力的关系')