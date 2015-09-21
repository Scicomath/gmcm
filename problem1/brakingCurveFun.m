function [ V,S ] = brakingCurveFun( s0, s1, endSpeed, gradient, curvature )
%brakingCurveFun ����ƶ����ߺ���
%   ���������
%       s0 --- �������
%       s1 --- �����յ�
%       endSpeed --- �����ٶ� ��λ��km/h
%   ���������
%       
M = 194295; % �г����� kg
L = 10000;
S = linspace(s1,s0,L);
V = zeros(size(S));
V(1) =  endSpeed / 3.6; % �����ٶ�
for i = 2:length(V)
    [ Bmax ] = maxBrakingFun( V(i - 1) );
    [W] = totalResistanceFun(V(i - 1), S(i-1), gradient, curvature);
    capacityMaxA = (Bmax + W) / M; % �ܹ��ﵽ�������ٶ�
    if capacityMaxA > 1
        a = 1;
    else
        a = capacityMaxA;
    end
    V(i) = sqrt((V(i-1))^2 + 2 * a * (S(i) - S(i - 1)));
end


end
