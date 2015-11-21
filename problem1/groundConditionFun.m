function [ i,R,addedI ] = groundConditionFun( s,gradient,curvature )
%groundConditionFun 计算位置s处的坡度和曲率以及折算坡度
%   输入参数：
%       s --- 当前公里标
%       gradient --- 坡度数据
%       curvature --- 曲率数据
%   输出参数：
%       i --- s处的坡度
%       R --- s处的曲率
%       addedI --- s处的折算坡度

% 计算坡度
index = find(gradient(:,3) > s,1);
i = -gradient(index,2); % 坡度反号，因为是反向行驶

% 计算曲率
index = find(curvature(:,3) > s,1);
R = curvature(index,2);

c = 600; % c为综合反映影响曲线阻力许多因素的经验常数，我国轨道交通一般取600

if R ==0
    addedI = i;
else
    addedI = i + c / R;
end

end