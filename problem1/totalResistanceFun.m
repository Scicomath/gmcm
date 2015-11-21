function [W] = totalResistanceFun(v, s, gradient, curvature)
%totalResistanceFun 计算位置s处 速度为v时 的坡度和曲率
%   输入参数：
%       v --- 当前速度 单位：km/h
%       s --- 当前公里标
%       gradient --- 坡度数据
%       curvature --- 曲率数据
%   输出参数：
%       W --- 总阻力 单位：N

g = 9.8; % 重力加速度
M = 194295; % 列车重量 单位 kg

% 列车基本阻力参数
A = 2.031;
B = 0.0622;
C = 0.001807;

% 基本阻力
w0 = A + B * v + C * v^2;

% 附加阻力
[ i,R ] = groundConditionFun( s, gradient, curvature);
c = 600; % c为综合反映影响曲线阻力许多因素的经验常数，我国轨道交通一般取600
wi = i;
if R == 0
    wc = 0;
else
    wc = c / R;
end

W = (w0 + wi + wc) * g * M / 1000;
end


