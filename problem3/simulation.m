function [ result ] = simulation( n,interSta,speedLimit,gradient,curvature,brakingCurveS,brakingCurveV,curveTerminal,stationP )
%simulation 仿真函数
%   此处显示详细说明
delayTime = zeros(n,1);
lateTime = zeros(n,1);
delaytotalE = zeros(n,1);
delayType = randsrc(n,1,[0,1,2;0.7,0.2,0.1]);
fileID = fopen('simResult2.txt','a');

for i = 1:length(delayType)
    if delayType(i)==0
        delayTime(i) = 0;
    elseif delayType(i)==1
        delayTime(i) = rand(1)*10;
    else
        delayTime(i) = 10 + rand(1)*(60-10);
    end
end
delaySta = randi([2,12],n,1);
for i = 1:n
    if delayTime(i) == 0
        lateTime(i) = 0;
        delaytotalE(i) = 0;
    else
        [ ~,~,~,~,~,~,~,~,delaytotalE(i),~,lateTime(i) ] =...
            delayFun( delaySta(i),delayTime(i),interSta,speedLimit,gradient,curvature,...
            brakingCurveS,brakingCurveV,curveTerminal,stationP );
    end
    fprintf(fileID,'%d\t%d\t%f\t%f\t%f\n',delaySta(i),delayType(i),delayTime(i),lateTime(i),delaytotalE(i))
end

result = [delaySta,delayType,delayTime,lateTime,delaytotalE];

end

