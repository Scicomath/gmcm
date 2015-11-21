function [ enery,time,lateTime ]=normalDelayFun(j,interSta,speedLimit,gradient,curvature,brakingCurveS,brakingCurveV,curveTerminal,stationP)


delayTime = 10;
[ ~,~,~,~,~,~,~,delaytotalT,delaytotalE,~,lateTime ] =...
    delayFun( j,delayTime,interSta,speedLimit,gradient,curvature,...
    brakingCurveS,brakingCurveV,curveTerminal,stationP );
enery =  delaytotalE;
time = delaytotalT;

