clear
main

brakingCurveV = [];
brakingCurveS = [];
curveTerminal = [];
figure
hold on

for i = 2:size(speedLimit,1)
    endSpeed = speedLimit(i - 1,2);
    s0 = speedLimit(i,3);
    s1 = speedLimit(i,1);
    currentLimitSpeed = speedLimit(i,2);
    if currentLimitSpeed > endSpeed
        [ tempV,tempS ] = brakingCurveFun( s0, s1, endSpeed, gradient, curvature );
        plot(tempS,tempV*3.6)
        brakingCurveV = [brakingCurveV,tempV];
        brakingCurveS = [brakingCurveS,tempS];
        curveTerminal = [curveTerminal;s0, s1];
    end
end
%plot(S,V*3.6)
%hold on
for i = 1:size(speedLimit,1)
    line(speedLimit(i,[1 3]),[speedLimit(i,2),speedLimit(i,2)])
end

%% 选取车站A6到A7之间 画图
% 设置y轴范围
ymin = 40;
ymax = 90;
%axis([stationP(7)-500,stationP(6)+500,ymin,ymax])
axis([200,1500,0,ymax])
set(gca,'XDir','reverse')
% 添加车站标号
%line([stationP(6),stationP(6)],[ymin,ymax],'LineStyle',':')
%line([stationP(7),stationP(7)],[ymin,ymax],'LineStyle',':')

save('brakingCurve.mat','brakingCurveS','brakingCurveV','curveTerminal')

