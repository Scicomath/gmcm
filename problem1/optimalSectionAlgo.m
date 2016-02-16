function [ S,V,T,F,totalT,E,brakingTerminal ] = optimalSectionAlgo( s0,s1,v0,vt,E,speedLimit,gradient,curvature )
%optimalSectionAlgo 区间最优控制算法
%   输入参数：
%       s0 --- 初始公里标
%       s1 --- 终止公里标
%       v0 --- 初始速度 单位：m/s
%       vt --- 终止速度 单位：m/s
%       E --- 消耗能量
%       speedLimit --- 速度限制矩阵
%       gradient --- 轨道的坡度
%       curvature --- 轨道的曲率
%   输出参数：
%       S --- 公里标向量
%       V --- 对应的速度向量
%       T --- 对应的时间向量
%       F --- 对应的牵引力向量
%       totalT --- 消耗的总时间
%       E --- 剩余的能量
%       brakingTerminal --- 制动曲线端点数据

M = 194295; % 列车质量 kg
L = 10000;
S = linspace(s0,s1,L);
V = zeros(size(S));
F = zeros(size(S));
brakingTerminal = [];
% 终点制动曲线
[ endBrakingCurveV,endBrakingCurveS ] = brakingCurveFun( s0, s1, vt*3.6, gradient, curvature );

% 设置初始速度
V(1) = v0; 

% 牵引阶段
i = 2;
while (i < length(V) && V(i - 1) < speedLimit && E > 0)
    [ Fmax ] = maxTractionFun( V(i - 1)*3.6 );
    [W] = totalResistanceFun(V(i - 1)*3.6, S(i-1), gradient, curvature);
    capacityMaxA = (Fmax - W) / M; % 能够达到的最大加速度
    if capacityMaxA > 1
        a = 1; % 实际加速度, 因为题目限制最大加速度不能超过1
        totalF = M * a; % 合力
        F(i - 1) = totalF + W; % 实际牵引力
    else
        a = capacityMaxA;
        F(i - 1) = Fmax;
    end
    V(i) = sqrt((V(i-1))^2 + 2 * a * (S(i-1) - S(i)));
    if checkMeetEndBrakingCurve(S(i),V(i),endBrakingCurveS,endBrakingCurveV)
        V(i-1:end) = interp1(endBrakingCurveS,endBrakingCurveV,S(i-1:end),'pchip');
        brakingTerminal = [brakingTerminal;S(i-1),S(end)];
        i = length(V);
    else
        E = E - F(i - 1) * (S(i-1) - S(i));
        i = i + 1;
    end
end

% 巡航阶段
while (i < length(V) && E > 0)
    V(i) = V(i - 1);
    if checkMeetEndBrakingCurve(S(i),V(i),endBrakingCurveS,endBrakingCurveV)
        V(i-1:end) = interp1(endBrakingCurveS,endBrakingCurveV,S(i-1:end),'pchip');
        brakingTerminal = [brakingTerminal;S(i-1),S(end)];
        i = length(V);
    else
        [W] = totalResistanceFun(V(i - 1)*3.6, S(i-1), gradient, curvature);
        E = E - W * (S(i-1) - S(i));
        i = i + 1;
    end
end

% 惰行阶段
while (i <= length(V))
    [W] = totalResistanceFun(V(i - 1)*3.6, S(i-1), gradient, curvature);
    a = -W / M; % 惰行加速度
    if a < -0.04
        a = -0.04;
        realF = M * a;
        F(i - 1) = realF + W;
    end
    V(i) = sqrt((V(i-1))^2 + 2 * a * (S(i-1) - S(i)));
    E = E - F(i - 1) * (S(i-1) - S(i));
    if checkMeetEndBrakingCurve(S(i),V(i),endBrakingCurveS,endBrakingCurveV)
        V(i-1:end) = interp1(endBrakingCurveS,endBrakingCurveV,S(i-1:end),'pchip');
        brakingTerminal = [brakingTerminal;S(i-1),S(end)];
        i = length(V)+1;
    else
        i = i + 1;
    end
end

diffS = abs(diff(S));
meanV = mean([V(1:end-1);V(2:end)]);
T = cumsum([0,diffS ./ meanV]);
totalT = T(end);

end

