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

 
% ������
delayNode = 2:13;
realEnergy = enery/(3600*1000);
extraEnergy = (enery - totalE) / (3600*1000);

fprintf('����վ̨\tʵ����������\t������������\t���ʱ��\t������վ����\n')
for i = 1:length(delayNode)
    fprintf('%d\t%f\t%f\t%f\t%d\n',delayNode(i),realEnergy(i),extraEnergy(i),lateTime(i),adjustNum(i))
end


figure
plot(S,V*3.6,delayS,delayV*3.6)
set(gca,'XDir','reverse')
title('�ٶ�·������')
xlabel('ʱ�䣨s��')
ylabel('�ٶȣ�km/h��')
legend('ԭ�ٶ�����','�ӳ��ٶ�����','Location','northwest')
printFigureToPdf('�����ʵ�һС��.pdf', [11.5,11],'centimeters',[0 0  0 0]);

figure
plot(T,V*3.6,delayT,delayV*3.6)
title('ʱ�����ٶȵĹ�ϵ')

figure
plot(T,Acce,delayT,delayAcce)
title('ʱ������ٶȵĹ�ϵ')

figure
plot(T,calDist,delayT,delaycalDist)
title('ʱ����������Ĺ�ϵ')

figure
plot(T,calS,delayT,delaycalS)
title('ʱ������㹫���Ĺ�ϵ')

figure
plot(T,F,delayT,delayF)
title('ʱ�������ǣ�����Ĺ�ϵ')