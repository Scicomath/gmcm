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
adjustNum = zeros(12,1);
for i=2:13
    
   [ enery(i-1),time(i-1),lateTime(i-1),adjustNum(i-1) ]=normalDelayFun(i,interSta,speedLimit,gradient,curvature,brakingCurveS,brakingCurveV,curveTerminal,stationP);
end

 
% 输出结果
delayNode = 2:13;
realEnergy = enery/(3600*1000);
extraEnergy = (enery - totalE) / (3600*1000);

fprintf('延误站台\t实际消耗能量\t额外消耗能量\t晚点时间\t调整的站点数\n')
for i = 1:length(delayNode)
    fprintf('%d\t%f\t%f\t%f\t%d\n',delayNode(i),realEnergy(i),extraEnergy(i),lateTime(i),adjustNum(i))
end


figure
plot(S,V*3.6,delayS,delayV*3.6)
set(gca,'XDir','reverse')
title('速度路程曲线')
xlabel('时间（s）')
ylabel('速度（km/h）')
legend('原速度曲线','延迟速度曲线','Location','northwest')
printFigureToPdf('第三问第一小问.pdf', [11.5,11],'centimeters',[0 0  0 0]);

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