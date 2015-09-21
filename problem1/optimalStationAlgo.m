function  [S,V,T,F,calS,calDist,Acce,interstation,totalT,sectionT,totalE]=optimalStationAlgo( As,At,dwellTime,targetT,speedLimit,gradient,...
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

A = As:At;
N = length(A) - 1;


sectionS = cell(0);
sectionV = cell(0);
sectionT = cell(0);
sectionF = cell(0);

sectionEndS = [];
sectionEndV = [];

sectionSpeedLimit = [];
sectionE = [];
sectionUsedT = [];

interstation.SectionNum = zeros(N,1);

for i = 1:N
    [ ~,~,~,~,...
        ~,~,~,tempSection ] = ...
        primarySolutionFun( stationP(A(i)),stationP(A(i+1)),speedLimit,gradient,...
        curvature, brakingCurveS,brakingCurveV,curveTerminal );
    interstation.SectionNum(i) = length(tempSection.S);
    sectionS = [sectionS;tempSection.S];
    sectionV = [sectionV;tempSection.V];
    sectionT = [sectionT;tempSection.T];
    sectionF = [sectionF;tempSection.F];
    sectionEndS = [sectionEndS;tempSection.EndS];
    sectionEndV = [sectionEndV;tempSection.EndV];
    sectionUsedT = [sectionUsedT;tempSection.usedT];
    sectionSpeedLimit = [sectionSpeedLimit;tempSection.SpeedLimit/3.6]; % 将km/h转换为m/s
    sectionE = [sectionE;tempSection.E];
end
sectionNum = length(sectionS);
totalT = sum(sectionUsedT);
%deltaE = 0.1 * 1000 * 3600; % deltaE 为 0.1 千瓦时
firstFlag = 1;
saveTimePerE = zeros(sectionNum,1);
while totalT>targetT

    %addEnergySection = 0;
    if firstFlag == 1
        for i = 1:sectionNum
            [ ~,~,~,~,tempSectionTotalT,tempSectionLeftE ] = optimalSectionAlgo( sectionEndS(i,1),...
                sectionEndS(i,2),sectionEndV(i,1),sectionEndV(i,2),sectionE(i)+deltaE,sectionSpeedLimit(i),gradient,curvature );
            saveTimePerE(i) = (sectionUsedT(i) - tempSectionTotalT) / (deltaE - tempSectionLeftE);
        end
    else
        [ ~,~,~,~,tempSectionTotalT,tempSectionLeftE ] = optimalSectionAlgo( sectionEndS(i,1),...
            sectionEndS(i,2),sectionEndV(i,1),sectionEndV(i,2),sectionE(i)+deltaE,sectionSpeedLimit(i),gradient,curvature );
        saveTimePerE(i) = (sectionUsedT(i) - tempSectionTotalT) / (deltaE - tempSectionLeftE);
    end
    firstFlag = 0;
    [~,i]=max(saveTimePerE);
    
    [ sectionS{i},sectionV{i},sectionT{i},sectionF{i},sectionUsedT(i),tempSectionLeftE ] = optimalSectionAlgo( sectionEndS(i,1),...
        sectionEndS(i,2),sectionEndV(i,1),sectionEndV(i,2),sectionE(i)+deltaE,sectionSpeedLimit(i),gradient,curvature );
    sectionE(i) = sectionE(i) + deltaE - tempSectionLeftE;
    
    totalT = sum(sectionUsedT);
    if ~isreal(totalT)
        disp('totalT is complex number')
    end
    disp(totalT)
end

interstation.S = cell(N,1);
currentSection = 0;
for i = 1:N
    tempIndex = (currentSection+1):(currentSection+interstation.SectionNum(i));
    interstation.S{i} = cat(2,sectionS{tempIndex});
    interstation.F{i} = cat(2,sectionF{tempIndex});
    ;... % 有待继续编写
    currentSection = tempIndex(end);
end


S = cat(2,sectionS{:});
F = cat(2,sectionF{:});
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


T = sectionT{1};
for i = 2:sectionNum
    T = [T,sectionT{i} + T(end)];
end

V = cat(2,sectionV{:});
totalE = sum(sectionE);

Acce = [diff(V.^2) ./ (-2*diff(S)),0];


end

