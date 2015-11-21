function  [S,V,T,F,calS,calDist,Acce,interSta,totalT,totalE,brakingTerminal,...
    successFlag]=optimalStationAlgo( As,At,dwellTime,targetT,speedLimit,gradient,...
    curvature,brakingCurveS,brakingCurveV,curveTerminal,stationP,deltaE)
%optimalStationAlgo 车站之间控制优化算法
%   输入参数：
%       As --- 起始车站号
%       At --- 终点车站号
%       dwellTime --- 站点的停留时间
%       targetT --- 全程的目标时间
%       speedLimit --- 速度限制数据
%       gradient --- 坡度数据
%       curvature --- 曲率数据
%       brakingCurveS --- 区间制动曲线的公里标向量
%       brakingCurveV --- 区间制动曲线的速度向量
%       curveTerminal --- 区间制动曲线的端点数据
%       stationP --- 各站点的公里标数据
%       deltaE --- 每次分配的能量
%   输出参数：
%       S --- 公里标向量
%       V --- 对应的速度向量
%       T --- 对应的时间向量
%       F --- 对应的牵引力向量
%       calS --- 对应的计算公里标向量
%       calDist --- 对应的计算距离向量
%       Acce --- 对应的加速度向量
%       interSta --- 站间数据
%       totalT --- 全程消耗的总时间
%       totalE --- 全程消耗的总能量
%       brakingTerminal --- 全程的制动区间端点数据

A = As:At;              % 起始车站到终点车站的向量
N = length(A) - 1;      % 站间区间的个数

% 区间数据初始化
section.S = cell(0);    % 区间的公里标向量
section.V = cell(0);    % 区间的速度向量
section.T = cell(0);    % 区间的时间向量
section.F = cell(0);    % 区间的牵引力向量

section.braking = cell(0); % 区间制动区间

section.EndS = [];      % 区间的端点公里标
section.EndV = [];      % 区间的端点速度

section.SpeedLimit = [];    % 区间的速度限制
section.E = [];             % 区间的能量消耗
section.UsedT = [];         % 区间的花费时间

interStaSectionNum = zeros(N,1);   % 站间区间的子区间数目

% 计算两个站间的初始解，将所有站间初始解的区间信息保存到section中
for i = 1:N
    [ ~,~,~,~,...
        ~,~,~,tempSection ] = ...
        primarySolutionFun( stationP(A(i)),stationP(A(i+1)),speedLimit,gradient,...
        curvature, brakingCurveS,brakingCurveV,curveTerminal );
    interStaSectionNum(i) = length(tempSection.S); % 保存站间的子区间数目
    section.S = [section.S;tempSection.S];
    section.V = [section.V;tempSection.V];
    section.T = [section.T;tempSection.T];
    section.F = [section.F;tempSection.F];
    section.braking = [section.braking;tempSection.braking];
    section.EndS = [section.EndS;tempSection.EndS];
    section.EndV = [section.EndV;tempSection.EndV];
    section.UsedT = [section.UsedT;tempSection.usedT];
    section.SpeedLimit = [section.SpeedLimit;tempSection.SpeedLimit/3.6]; % 将km/h转换为m/s
    section.E = [section.E;tempSection.E];
end

% 对所有的区间进行优化
sectionNum = length(section.S);             % 总的区间数目
totalT = sum(section.UsedT);                % 路程消耗的总时间

firstFlag = 1;                              % 判断是否是第一次循环
saveTimePerE = zeros(sectionNum,1);         % 区间的单位能量节省时间向量
previousT = 0;
successFlag = 1;
while totalT>targetT
    % 如果是第一次循环，对所有的区间计算单位能量节省时间
    if firstFlag == 1
        for i = 1:sectionNum
            [ ~,~,~,~,tempSectionTotalT,tempSectionLeftE ] = optimalSectionAlgo( section.EndS(i,1),...
                section.EndS(i,2),section.EndV(i,1),section.EndV(i,2),section.E(i)+deltaE,section.SpeedLimit(i),gradient,curvature );
            saveTimePerE(i) = (section.UsedT(i) - tempSectionTotalT) / (deltaE - tempSectionLeftE);
        end
    else % 如果不是第一次循环，仅计算更新过的区间的单位能量节省时间
        [ ~,~,~,~,tempSectionTotalT,tempSectionLeftE ] = optimalSectionAlgo( section.EndS(i,1),...
            section.EndS(i,2),section.EndV(i,1),section.EndV(i,2),section.E(i)+deltaE,section.SpeedLimit(i),gradient,curvature );
        saveTimePerE(i) = (section.UsedT(i) - tempSectionTotalT) / (deltaE - tempSectionLeftE);
    end
    firstFlag = 0;                          % 第一次循环后，firstFlag为0
    [~,i]=max(saveTimePerE);                % 选取单位能量节省时间最多的区间
    % 对选中的区间进行优化
    [ section.S{i},section.V{i},section.T{i},section.F{i},section.UsedT(i),tempSectionLeftE,section.braking{i} ] = optimalSectionAlgo( section.EndS(i,1),...
        section.EndS(i,2),section.EndV(i,1),section.EndV(i,2),section.E(i)+deltaE,section.SpeedLimit(i),gradient,curvature );
    section.E(i) = section.E(i) + deltaE - tempSectionLeftE;
    % 重新计算路程总时间
    totalT = sum(section.UsedT);
    if abs(totalT-previousT)<0.001
        successFlag = 0;
        break
    end
    previousT = totalT;
    disp(totalT)
end

interSta =section2interSta(section,interStaSectionNum);

[S,V,T,F,calS,calDist,Acce,totalT,totalE,brakingTerminal] = interSta2all(interSta,dwellTime,A,stationP);


end
