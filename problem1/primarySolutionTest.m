% primarySolutionFun≤‚ ‘Ω≈±æ
clear
readData
load brakingCurve.mat

[ S,V,E,T,totalE,totalT,section ] = primarySolutionFun( stationP(6),stationP(7),speedLimit,gradient,...
    curvature, brakingCurveS,brakingCurveV,curveTerminal );
% [ S,V,E,T,F,totalE,totalT,section ] = primarySolutionFun( 15932,13594,speedLimit,gradient,...
%     curvature, brakingCurveS,brakingCurveV,curveTerminal );
% [ S,V,E,T,F,totalE,totalT,section ] = primarySolutionFun( stationP(7),stationP(8),speedLimit,gradient,...
%     curvature, brakingCurveS,brakingCurveV,curveTerminal );
figure
plot(S,V*3.6)
hold on
for i = 1:size(speedLimit,1)
    line(speedLimit(i,[1 3]),speedLimit(i,[2 2]))
end
axis([S(end),S(1),0,90])
set(gca,'XDir','reverse')

figure
hold on
for i = 1:size(gradient,1)
    line(gradient(i,[1 3]),-gradient(i,[2 2]))
end

axis([S(end),S(1),-30,30])
set(gca,'XDir','reverse')

figure
hold on
for i = 1:size(curvature,1)
    line(tranCurva(i,[1 3]),tranCurva(i,[2 2]))
end

axis([S(end),S(1),-30,30])
set(gca,'XDir','reverse')