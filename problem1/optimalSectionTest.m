% optimalSectionTest为optimalSectionFun函数的测试脚本
clear
readData
s0 = 14885;
s1 = 13595;
v0 = 0;
vt = 0;
E = 10*1000*3600;
speedLimit = 80/3.6;

% s0 = 13474;
% s1 = 12240;
% v0 = 13.8423;
% vt = 0;
% E = 360000;
% speedLimit = 80/3.6;

% s0 = 6045;
% s1 = 4081;
% v0 = 13.005831439635815;
% vt = 0;
% E = 3.784572869394618e+07;
% speedLimit = 22.222222222222221;

[ S,V,T,F,totalT,E,brakingTerminal ] = optimalSectionAlgo( s0,s1,v0,vt,E,speedLimit,gradient,curvature );
disp(totalT)
figure
plot(S,V*3.6)
set(gca,'XDir','reverse')

figure
hold on
for i = 1:size(gradient,1)
    line(gradient(i,[1 3]),-gradient(i,[2 2]))
end

axis([S(end),S(1),-30,30])
set(gca,'XDir','reverse')