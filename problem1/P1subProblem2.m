% 第一问第二小问脚本
clear
readData

load brakingCurve.mat

As = 6;
At = 8;
targetTime = 220;
dwellTime = 40;
tic
deltaE = 0.03 * 1000 * 3600; % deltaE 为 0.1 千瓦时
[S,V,T,F,calS,calDist,Acce,interSta,totalT,totalE]=optimalStationAlgo( As,At,dwellTime,targetTime,speedLimit,gradient,...
    curvature,brakingCurveS,brakingCurveV,curveTerminal,stationP,deltaE);
toc

tempIndex = find(diff(T)==0);
if ~isempty(tempIndex)
    S(tempIndex) = [];
    V(tempIndex) = [];
    T(tempIndex) = [];
    F(tempIndex) = [];
    calS(tempIndex) = [];
    calDist(tempIndex) = [];
    Acce(tempIndex) = [];
end


Time = 0:floor(T(end));
N = length(Time);
resultTable = zeros(N+1,9);

resultTable(1:N,1) = Time;    % 时刻
secondV = interp1(T,V,Time);
resultTable(1:N,2) = secondV * 100; % 实际速度(cm/s)
resultTable(1:N,3) = secondV * 3.6; % 实际速度(km/h)
resultTable(1:N,4) = interp1(T,Acce,Time); % 计算加速度(m/s2)
resultTable(1:N,5) = interp1(T,calDist,Time); % 计算距离(m)
resultTable(1:N,6) = interp1(T,calS,Time); % 计算公里标(m)
secondS = interp1(T,S,Time); % 实际公里标(m)
for i = 1:N-1
    [ ~,~,resultTable(i,7) ] = groundConditionFun( secondS(i),gradient,curvature );
end
secondF = interp1(T,F,Time); % 计算牵引力(N)
resultTable(1:N,8) = secondF;
resultTable(1:N,9) = secondF .* secondV;

temp = (stationP(As) - stationP(At)) -  resultTable(end-1,6);
resultTable(end,:) = [targetTime+sum(dwellTime),0,0,0,resultTable(end-1,5)+temp,resultTable(end-1,6)+temp,resultTable(end,7),0,0];


Timestr = cell(N+1,1);
for i = 1:N+1
    Timestr{i} = second2Time( i - 1 );
end


figure
plot(S,V*3.6)
set(gca,'XDir','reverse')
title('速度路程曲线')
xlabel('公里标（m）')
ylabel('速度（km/h）')
printFigureToPdf('第一问第二小问速度路程曲线.pdf', [11,8],'centimeters',[0 0  0 0]);

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