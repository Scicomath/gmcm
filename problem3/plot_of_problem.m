%% 1.subproblem1
clear
load subProblem1Result.mat
 
  figure
plot(S,V*3.6,'b')
hold on
x=[];y=[];
for i = 1:size(speedLimit,1)
    x=[x,[speedLimit(i,[1 3])]];
    y=[y ,speedLimit(i,[2 2])];
%     line(speedLimit(i,[1 3]),speedLimit(i,[2 2]))
end
plot(x,y,'r','LineWidth',2);
axis([S(end),S(1),0,90])
legend('运行速度','速度限制线')
xlabel('公里标(m)')
ylabel('速度(km/h)')
title('速度距离曲线')
set(gca,'XDir','reverse')
 
  figure
plot(T,V*3.6,'m','LineWidth',2)
xlabel('时间(s)')
ylabel('速度(km/h)')
title('速度时间曲线')


figure
plot(T,Acce)
title('时间与加速度的关系')

figure
plot(T,calDist,'c','LineWidth',2)
xlabel('时间(s)')
ylabel('距离(m)')
title('时间距离曲线')

figure
plot(T,calS)
title('时间与计算公里标的关系')

figure
plot(T,F)
title('时间与计算牵引力的关系')
%% 2.subproblem2
clear
load subProblem1Result.mat
  V1 =V;
load subProblem2Result.mat
save V2 =V;
clear
load subProblem2Result.mat
load V1
load V2
figure 
plot(S,V1*3.6,'b')
plot(S,V2*3.6,'m')

plot(S,V*3.6,'b')
hold on
x=[];y=[];
for i = 1:size(speedLimit,1)
    x=[x,[speedLimit(i,[1 3])]];
    y=[y ,speedLimit(i,[2 2])];
%     line(speedLimit(i,[1 3]),speedLimit(i,[2 2]))
end
plot(x,y,'r','LineWidth',2);
axis([S(end),S(1),0,90])
legend('运行速度','速度限制线')
xlabel('公里标(m)')
ylabel('速度(km/h)')
title('速度距离曲线')
set(gca,'XDir','reverse')

  figure
plot(T,V*3.6,'m','LineWidth',2)
xlabel('时间(s)')
ylabel('速度(km/h)')
title('速度时间曲线')

figure
plot(T,Acce)
title('时间与加速度的关系')

figure
plot(T,calDist,'c','LineWidth',2)
xlabel('时间(s)')
ylabel('距离(m)')
title('时间距离曲线')

figure
plot(T,calS)
title('时间与计算公里标的关系')

figure
plot(T,F)
title('时间与计算牵引力的关系')