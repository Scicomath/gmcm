% ��һ�ʵڶ�С�ʽű�
clear
readData

load brakingCurve.mat

As = 6;
At = 8;
targetTime = 220;
dwellTime = 40;
tic
deltaE = 0.03 * 1000 * 3600; % deltaE Ϊ 0.1 ǧ��ʱ
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

resultTable(1:N,1) = Time;    % ʱ��
secondV = interp1(T,V,Time);
resultTable(1:N,2) = secondV * 100; % ʵ���ٶ�(cm/s)
resultTable(1:N,3) = secondV * 3.6; % ʵ���ٶ�(km/h)
resultTable(1:N,4) = interp1(T,Acce,Time); % ������ٶ�(m/s2)
resultTable(1:N,5) = interp1(T,calDist,Time); % �������(m)
resultTable(1:N,6) = interp1(T,calS,Time); % ���㹫���(m)
secondS = interp1(T,S,Time); % ʵ�ʹ����(m)
for i = 1:N-1
    [ ~,~,resultTable(i,7) ] = groundConditionFun( secondS(i),gradient,curvature );
end
secondF = interp1(T,F,Time); % ����ǣ����(N)
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
title('�ٶ�·������')
xlabel('����꣨m��')
ylabel('�ٶȣ�km/h��')
printFigureToPdf('��һ�ʵڶ�С���ٶ�·������.pdf', [11,8],'centimeters',[0 0  0 0]);

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