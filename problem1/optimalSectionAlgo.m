function [ S,V,T,F,totalT,E,brakingTerminal ] = optimalSectionAlgo( s0,s1,v0,vt,E,speedLimit,gradient,curvature )
%optimalSectionAlgo �������ſ����㷨
%   ���������
%       s0 --- ��ʼ�����
%       s1 --- ��ֹ�����
%       v0 --- ��ʼ�ٶ� ��λ��m/s
%       vt --- ��ֹ�ٶ� ��λ��m/s
%       E --- ��������
%       speedLimit --- �ٶ����ƾ���
%       gradient --- ������¶�
%       curvature --- ���������
%   ���������
%       S --- ���������
%       V --- ��Ӧ���ٶ�����
%       T --- ��Ӧ��ʱ������
%       F --- ��Ӧ��ǣ��������
%       totalT --- ���ĵ���ʱ��
%       E --- ʣ�������
%       brakingTerminal --- �ƶ����߶˵�����

M = 194295; % �г����� kg
L = 10000;
S = linspace(s0,s1,L);
V = zeros(size(S));
F = zeros(size(S));
brakingTerminal = [];
% �յ��ƶ�����
[ endBrakingCurveV,endBrakingCurveS ] = brakingCurveFun( s0, s1, vt*3.6, gradient, curvature );

% ���ó�ʼ�ٶ�
V(1) = v0; 

% ǣ���׶�
i = 2;
while (i < length(V) && V(i - 1) < speedLimit && E > 0)
    [ Fmax ] = maxTractionFun( V(i - 1)*3.6 );
    [W] = totalResistanceFun(V(i - 1)*3.6, S(i-1), gradient, curvature);
    capacityMaxA = (Fmax - W) / M; % �ܹ��ﵽ�������ٶ�
    if capacityMaxA > 1
        a = 1; % ʵ�ʼ��ٶ�, ��Ϊ��Ŀ���������ٶȲ��ܳ���1
        totalF = M * a; % ����
        F(i - 1) = totalF + W; % ʵ��ǣ����
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

% Ѳ���׶�
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

% ���н׶�
while (i <= length(V))
    [W] = totalResistanceFun(V(i - 1)*3.6, S(i-1), gradient, curvature);
    a = -W / M; % ���м��ٶ�
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

