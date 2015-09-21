function [ Fmax ] = maxTractionFun( v )
%maxTractionFun ���ǣ��������
%   ���������
%       v --- �ٶ� ��λ��km/h
%   ���������
%       Fmax --- ���ǣ���� ��λ��N

if v <= 51.5
    Fmax = 203;
else
    Fmax = -0.002032 * v^3 + 0.4928 * v^2 - 42.13 * v + 1343;
end

Fmax = Fmax * 1000; % ת����λΪN
end

