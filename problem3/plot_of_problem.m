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
legend('�����ٶ�','�ٶ�������')
xlabel('�����(m)')
ylabel('�ٶ�(km/h)')
title('�ٶȾ�������')
set(gca,'XDir','reverse')
 
  figure
plot(T,V*3.6,'m','LineWidth',2)
xlabel('ʱ��(s)')
ylabel('�ٶ�(km/h)')
title('�ٶ�ʱ������')


figure
plot(T,Acce)
title('ʱ������ٶȵĹ�ϵ')

figure
plot(T,calDist,'c','LineWidth',2)
xlabel('ʱ��(s)')
ylabel('����(m)')
title('ʱ���������')

figure
plot(T,calS)
title('ʱ������㹫���Ĺ�ϵ')

figure
plot(T,F)
title('ʱ�������ǣ�����Ĺ�ϵ')
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
legend('�����ٶ�','�ٶ�������')
xlabel('�����(m)')
ylabel('�ٶ�(km/h)')
title('�ٶȾ�������')
set(gca,'XDir','reverse')

  figure
plot(T,V*3.6,'m','LineWidth',2)
xlabel('ʱ��(s)')
ylabel('�ٶ�(km/h)')
title('�ٶ�ʱ������')

figure
plot(T,Acce)
title('ʱ������ٶȵĹ�ϵ')

figure
plot(T,calDist,'c','LineWidth',2)
xlabel('ʱ��(s)')
ylabel('����(m)')
title('ʱ���������')

figure
plot(T,calS)
title('ʱ������㹫���Ĺ�ϵ')

figure
plot(T,F)
title('ʱ�������ǣ�����Ĺ�ϵ')