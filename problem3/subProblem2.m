clear
addpath ../problem1
addpath ../problem2
readData

load brakingCurve.mat
load problem2stage1.mat
n = 100;
[ result ] = simulation( n,interSta,speedLimit,gradient,curvature,...
    brakingCurveS,brakingCurveV,curveTerminal,stationP );
