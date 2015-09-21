function [ Fmax ] = maxTractionFun( v )
%maxTractionFun 最大牵引力函数
%   输入参数：
%       v --- 速度 单位：km/h
%   输出参数：
%       Fmax --- 最大牵引力 单位：N

if v <= 51.5
    Fmax = 203;
else
    Fmax = -0.002032 * v^3 + 0.4928 * v^2 - 42.13 * v + 1343;
end

Fmax = Fmax * 1000; % 转换单位为N
end

