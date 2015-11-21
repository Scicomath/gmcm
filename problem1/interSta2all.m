function [S,V,T,F,calS,calDist,Acce,totalT,totalE,brakingTerminal] = interSta2all(interSta,dwellTime,A,stationP)
%interSta2all 将站间数据转化为全程数据
N = length(interSta);
if N == 1
    S = interSta{1}.S;
    V = interSta{1}.V;
    T = interSta{1}.T;
    F = interSta{1}.F;
    totalE = interSta{1}.E;
    Acce = [diff(interSta{1}.V.^2) ./ (-2*diff(interSta{1}.S)),0];
    brakingTerminal = interSta{1}.braking;
else
    S = [];
    V = [];
    T = [];
    F = [];
    Acce = [];
    brakingTerminal = [];
    totalE = 0;
    for i = 1:N-1
        S = [S,interSta{i}.S];
        Acce = [Acce,[diff(interSta{i}.V.^2) ./ (-2*diff(interSta{i}.S)),0]];
        S = [S,stationP(A(i+1)),stationP(A(i+1))];
        Acce = [Acce,0,0];
        V = [V,interSta{i}.V];
        V = [V,0,0];
        F = [F,interSta{i}.F];
        F = [F,0,0];
        totalE = totalE + interSta{i}.E;
        brakingTerminal = [brakingTerminal;interSta{i}.braking];
    end
    S = [S,interSta{end}.S];
    Acce = [Acce,[diff(interSta{end}.V.^2) ./ (-2*diff(interSta{end}.S)),0]];
    V = [V,interSta{end}.V];
    F = [F,interSta{end}.F];
    totalE = totalE + interSta{end}.E;
    brakingTerminal = [brakingTerminal;interSta{end}.braking];
    
    T = [T,interSta{1}.T];
    T = [T,T(end)+0.01,T(end)+dwellTime(1)];
    for i = 2:N-1
        T = [T,interSta{i}.T + T(end)+0.01];
        T = [T,T(end)+0.01,T(end)+dwellTime(i)];
    end
    T = [T,interSta{end}.T + T(end)+0.01];
    
end

totalT = T(end);
% 计算公里标： 到起点的距离
calS = -(S - S(1));
% 计算距离： 到上一站的距离
calDist = [];
for i = 1:N
    if i==N
        tempS = S(S<=stationP(A(i))&S>=stationP(A(i+1)));
    else
        tempS = S(S<=stationP(A(i))&S>stationP(A(i+1)));
    end
    calDist = [calDist,-(tempS - tempS(1))];
end


end