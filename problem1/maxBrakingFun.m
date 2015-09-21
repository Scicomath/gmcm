function [ Bmax ] = maxBrakingFun( v )
%maxBrakingFun 最大制动力函数
%   输入参数：
%       v --- 速度 单位：km/h
%   输出参数：
%       Bmax --- 最大制动力 单位：N

if v <= 77
    Bmax = 166;
else
    Bmax = 0.1343 * v^2 - 25.07 * v + 1300;
end

Bmax = Bmax * 1000; % 转换单位为N
end

