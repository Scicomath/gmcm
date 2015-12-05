% brakingCurveScript�ű�������������ٶ�����������ƶ���Ϣ������
%   ����������ƶ����ߵĹ�����������ٶ����������߶˵����ݡ�������������

clear
readData

brakingCurveV = [];
brakingCurveS = [];
brakingCurveEreg = [];
curveTerminal = [];
figure
hold on

for i = 2:size(speedLimit,1)
    endSpeed = speedLimit(i - 1,2);
    s0 = speedLimit(i,3);
    s1 = speedLimit(i,1);
    currentLimitSpeed = speedLimit(i,2);
    if currentLimitSpeed > endSpeed
        [ tempV,tempS,tempEreg ] = brakingCurveFun( s0, s1, endSpeed, gradient, curvature );
        brakingLine = plot(tempS,tempV*3.6,'r');
        brakingCurveV = [brakingCurveV,tempV];
        brakingCurveS = [brakingCurveS,tempS];
        brakingCurveEreg = [brakingCurveEreg,tempEreg];
        curveTerminal = [curveTerminal;s0, s1];
    end
end
%plot(S,V*3.6)
%hold on
for i = 1:size(speedLimit,1)
    limitLine = line(speedLimit(i,[1 3]),[speedLimit(i,2),speedLimit(i,2)]);
end

%% ѡȡ��վA6��A7֮�� ��ͼ
% ����y�᷶Χ
ymin = 40;
ymax = 90;
%axis([stationP(7)-500,stationP(6)+500,ymin,ymax])
axis([200,1500,ymin,ymax])
set(gca,'XDir','reverse')
xlabel('����꣨m��')
ylabel('�ٶȣ�km/h��')
legend([limitLine,brakingLine],'�ٶ�����','�ƶ�����')

printFigureToPdf('�ƶ�����ʾ��ͼ.pdf', [11.5,8.5],'centimeters',[0 0  0 0]);
% ��ӳ�վ���
%line([stationP(6),stationP(6)],[ymin,ymax],'LineStyle',':')
%line([stationP(7),stationP(7)],[ymin,ymax],'LineStyle',':')

save('brakingCurve.mat','brakingCurveS','brakingCurveV','curveTerminal','brakingCurveEreg')

