function [ S,V,T,F,calS,calDist,Acce,totalT,totalE,brakingTerminal,lateTime ] =...
    delayFun( delaySta,delayTime,interSta,speedLimit,gradient,curvature,...
    brakingCurveS,brakingCurveV,curveTerminal,stationP )
%delayFun 延迟调整函数

A = 1:14;
dwellTime = ones(1,12)*75/2;
deltaE = 0.001 * 1000 * 3600; % deltaE 为 0.1 千瓦时

lateTime = 0;
mayDelay = delaySta:(14-1);
delayTimeVec = zeros(size(mayDelay));
for i = 1:length(mayDelay)
    aveDelay = delayTime / i;
    delayTimeVec(1:i) = aveDelay;
    successFlag = ones(1,length(delayTimeVec));
    tempInterSta = cell(1,length(delayTimeVec));
    for k = 1:length(delayTimeVec)
        if delayTimeVec(k)~=0
            targetT = interSta{mayDelay(k)}.UsedT - delayTimeVec(k);
            [~,~,~,~,~,~,~,tempInterSta{k},~,~,~,successFlag(k)]=optimalStationAlgo( mayDelay(k),mayDelay(k)+1,dwellTime,targetT,speedLimit,gradient,...
                curvature,brakingCurveS,brakingCurveV,curveTerminal,stationP,deltaE);
        end
    end
    if all(successFlag)
        for j = 1:i
            interSta{mayDelay(j)} = tempInterSta{j}{1};
            dwellTime(mayDelay(j)-1) = dwellTime(mayDelay(j)-1) + delayTimeVec(j);
            lateTime = delayTime - delayTime/i;
        end
        break
    end
    
end
% 
% targetT = interSta{delaySta}.UsedT - delayTime;
% [~,~,~,~,~,~,~,tempInterSta]=optimalStationAlgo( delaySta,delaySta+1,dwellTime,targetT,speedLimit,gradient,...
%     curvature,brakingCurveS,brakingCurveV,curveTerminal,stationP,deltaE);
% interSta{delaySta} = tempInterSta{1};

[S,V,T,F,calS,calDist,Acce,totalT,totalE,brakingTerminal] = interSta2all(interSta,dwellTime,A,stationP);


end

