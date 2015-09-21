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
deltaE = 0.1 * 1000 * 3600; % deltaE Ϊ 0.1 ǧ��ʱ
[S,V,T,F,calS,calDist,Acce,interSta,totalT,totalE]=optimalStationAlgo( As,At,dwellTime,Time,speedLimit,gradient,...
    curvature,brakingCurveS,brakingCurveV,curveTerminal,stationP,deltaE);
toc
figure
plot(S,V*3.6)
set(gca,'XDir','reverse')
title('�ٶ�·������')

figure
plot(T,V*3.6)
title('ʱ�����ٶȵĹ�ϵ')

figure
plot(T,Acce)
title('ʱ������ٶȵĹ�ϵ')

figure
plot(T,calDist)
title('ʱ����������Ĺ�ϵ')

figure
plot(T,calS)
title('ʱ������㹫���Ĺ�ϵ')

figure
plot(T,F)
title('ʱ�������ǣ�����Ĺ�ϵ')

