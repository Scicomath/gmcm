function [ Bmax ] = maxBrakingFun( v )
%maxBrakingFun ����ƶ�������
%   ���������
%       v --- �ٶ� ��λ��km/h
%   ���������
%       Bmax --- ����ƶ��� ��λ��N

if v <= 77
    Bmax = 166;
else
    Bmax = 0.1343 * v^2 - 25.07 * v + 1300;
end

Bmax = Bmax * 1000; % ת����λΪN
end

