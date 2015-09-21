function  [S,V,T,F,calS,calDist,Acce,interSta,totalT,totalE]=optimalStationAlgo( As,At,dwellTime,targetT,speedLimit,gradient,...
    curvature,brakingCurveS,brakingCurveV,curveTerminal,stationP,deltaE)
%optimalStationAlgo 车站之间控制优化算法
%   输入参数：
%       As --- 起始车站号
%       At --- 终点车站号
%   输出参数：
%       S --- 公里标向量
%       V --- 对应的速度向量
%       E --- 对应的消耗能量向量
%       T --- 对应的时间向量

A = As:At;              % 起始车站到终点车站的向量
N = length(A) - 1;      % 站间区间的个数

% 区间信息初始化
section.S = cell(0);    % 区间的公里标向量
section.V = cell(0);    % 区间的速度向量
section.T = cell(0);    % 区间的时间向量
section.F = cell(0);    % 区间的牵引力向量

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
    [ section.S{i},section.V{i},section.T{i},section.F{i},section.UsedT(i),tempSectionLeftE ] = optimalSectionAlgo( section.EndS(i,1),...
        section.EndS(i,2),section.EndV(i,1),section.EndV(i,2),section.E(i)+deltaE,section.SpeedLimit(i),gradient,curvature );
    section.E(i) = section.E(i) + deltaE - tempSectionLeftE;
    % 重新计算路程总时间
    totalT = sum(section.UsedT);

end

interSta =section2interSta(section,interStaSectionNum);

[S,V,T,F,calS,calDist,Acce,totalT,totalE] = interSta2all(interSta,dwellTime,A,stationP);
% 
% interstation.S = cell(N,1);
% currentSection = 0;
% for i = 1:N
%     tempIndex = (currentSection+1):(currentSection+interstation.SectionNum(i));
%     interstation.S{i} = cat(2,sectionS{tempIndex});
%     interstation.F{i} = cat(2,sectionF{tempIndex});
%     interstation.calS{i} = -(interstation.S{i} - interstation.S{i}(1));
%     
%     ;... % 有待继续编写
%     currentSection = tempIndex(end);
% end
% 
% 
% S = cat(2,sectionS{:});
% F = cat(2,sectionF{:});
% % 计算公里标： 到起点的距离
% calS = -(S - S(1));
% % 计算距离： 到上一站的距离
% calDist = [];
% for i = 1:N
%     if i==N
%         tempS = S(S<=stationP(A(i))&S>=stationP(A(i+1)));
%     else
%         tempS = S(S<=stationP(A(i))&S>stationP(A(i+1)));
%     end
%     calDist = [calDist,-(tempS - tempS(1))];
% end
% 
% 
% T = section.T{1};
% for i = 2:sectionNum
%     T = [T,section.T{i} + T(end)];
% end
% 
% V = cat(2,section.V{:});
% totalE = sum(sectionE);
% 
% Acce = [diff(V.^2) ./ (-2*diff(S)),0];


end

function [S,V,T,F,calS,calDist,Acce,totalT,totalE] = interSta2all(interSta,dwellTime,A,stationP)
%interSta2all 将站间数据转化为全程数据
N = length(interSta);
if N == 1
    S = interSta{1}.S;
    V = interSta{1}.V;
    T = interSta{1}.T;
    F = interSta{1}.F;
    totalE = interSta{1}.E;
    Acce = [diff(interSta{1}.V.^2) ./ (-2*diff(interSta{1}.S)),0];
else
    S = [];
    V = [];
    T = [];
    F = [];
    Acce = [];
    totalE = 0;
    for i = 1:N-1
        S = [S,interSta{i}.S];
        Acce = [Acce,[diff(interSta{i}.V.^2) ./ (-2*diff(interSta{i}.S)),0]];
        S = [S,stationP(A(i+1)),stationP(A(i+1))];
        Acce = [Acce,0,0];
        V = [V,interSta{i}.V];
        V = [V,0,0];
        F = [F,interSta{i}.F];
        F = [F,0,0];
        totalE = totalE + interSta{i}.E;
    end
    S = [S,interSta{end}.S];
    Acce = [Acce,[diff(interSta{end}.V.^2) ./ (-2*diff(interSta{end}.S)),0]];
    V = [V,interSta{end}.V];
    F = [F,interSta{end}.F];
    totalE = totalE + interSta{end}.E;
    
    T = [T,interSta{1}.T];
    T = [T,T(end)+0.01,T(end)+dwellTime(1)];
    for i = 2:N-1
        T = [T,interSta{i}.T + T(end)+0.01];
        T = [T,T(end)+0.01,T(end)+dwellTime(i)];
    end
    T = [T,interSta{end}.T + T(end)+0.01];
    
end

totalT = T(end);
% 计算公里标： 到起点的距离
calS = -(S - S(1));
% 计算距离： 到上一站的距离
calDist = [];
for i = 1:N
    if i==N
        tempS = S(S<=stationP(A(i))&S>=stationP(A(i+1)));
    else
        tempS = S(S<=stationP(A(i))&S>stationP(A(i+1)));
    end
    calDist = [calDist,-(tempS - tempS(1))];
end
% 
% 
% Acce = [diff(V.^2) ./ (-2*diff(S)),0];
% 
% 
% index = find(isnan(Acce));
% Acce(index) = 0;
%calS(index) = 0;

end


function interSta =section2interSta(section,interStaSectionNum)
%section2interSta 将总的区间信息转化为站点之间的信息

index = [0;cumsum(interStaSectionNum)];
interSta = cell(length(interStaSectionNum),1);
for i = 1:length(interStaSectionNum)
    interSta{i}=mergeSection(section,(index(i)+1):(index(i+1)));
end

end

function mergeSec=mergeSection(section,mergeVec)
% 初始化合并的区间
mergeSec.S = cell(0);    % 区间的公里标向量
mergeSec.V = cell(0);    % 区间的速度向量
mergeSec.T = cell(0);    % 区间的时间向量
mergeSec.F = cell(0);    % 区间的牵引力向量

mergeSec.EndS = [];      % 区间的端点公里标
mergeSec.EndV = [];      % 区间的端点速度

mergeSec.S = cat(2,section.S{mergeVec});
mergeSec.V = cat(2,section.V{mergeVec});
mergeSec.F = cat(2,section.F{mergeVec});
mergeSec.T = section.T{mergeVec(1)};
for i = 2:length(mergeVec)
    mergeSec.T = [mergeSec.T,section.T{mergeVec(i)} + mergeSec.T(end)];
end
mergeSec.EndS = [section.EndS(mergeVec(1),1),section.EndS(mergeVec(end),2)];
mergeSec.EndV = [section.EndV(mergeVec(1),1),section.EndV(mergeVec(end),2)];
mergeSec.E = sum(section.E(mergeVec)); % 区间的能量消耗
mergeSec.UsedT = sum(section.UsedT(mergeVec)); % 区间的花费时间


end
