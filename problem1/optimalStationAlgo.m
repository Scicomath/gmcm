function  [S,V,T,F,calS,calDist,Acce,interSta,totalT,totalE]=optimalStationAlgo( As,At,dwellTime,targetT,speedLimit,gradient,...
    curvature,brakingCurveS,brakingCurveV,curveTerminal,stationP,deltaE)
%optimalStationAlgo ��վ֮������Ż��㷨
%   ���������
%       As --- ��ʼ��վ��
%       At --- �յ㳵վ��
%   ���������
%       S --- ���������
%       V --- ��Ӧ���ٶ�����
%       E --- ��Ӧ��������������
%       T --- ��Ӧ��ʱ������

A = As:At;              % ��ʼ��վ���յ㳵վ������
N = length(A) - 1;      % վ������ĸ���

% ������Ϣ��ʼ��
section.S = cell(0);    % ����Ĺ��������
section.V = cell(0);    % ������ٶ�����
section.T = cell(0);    % �����ʱ������
section.F = cell(0);    % �����ǣ��������

section.EndS = [];      % ����Ķ˵㹫���
section.EndV = [];      % ����Ķ˵��ٶ�

section.SpeedLimit = [];    % ������ٶ�����
section.E = [];             % �������������
section.UsedT = [];         % ����Ļ���ʱ��

interStaSectionNum = zeros(N,1);   % վ���������������Ŀ

% ��������վ��ĳ�ʼ�⣬������վ���ʼ���������Ϣ���浽section��
for i = 1:N
    [ ~,~,~,~,...
        ~,~,~,tempSection ] = ...
        primarySolutionFun( stationP(A(i)),stationP(A(i+1)),speedLimit,gradient,...
        curvature, brakingCurveS,brakingCurveV,curveTerminal );
    interStaSectionNum(i) = length(tempSection.S); % ����վ�����������Ŀ
    section.S = [section.S;tempSection.S];
    section.V = [section.V;tempSection.V];
    section.T = [section.T;tempSection.T];
    section.F = [section.F;tempSection.F];
    section.EndS = [section.EndS;tempSection.EndS];
    section.EndV = [section.EndV;tempSection.EndV];
    section.UsedT = [section.UsedT;tempSection.usedT];
    section.SpeedLimit = [section.SpeedLimit;tempSection.SpeedLimit/3.6]; % ��km/hת��Ϊm/s
    section.E = [section.E;tempSection.E];
end

% �����е���������Ż�
sectionNum = length(section.S);             % �ܵ�������Ŀ
totalT = sum(section.UsedT);                % ·�����ĵ���ʱ��

firstFlag = 1;                              % �ж��Ƿ��ǵ�һ��ѭ��
saveTimePerE = zeros(sectionNum,1);         % ����ĵ�λ������ʡʱ������
while totalT>targetT
    % ����ǵ�һ��ѭ���������е�������㵥λ������ʡʱ��
    if firstFlag == 1
        for i = 1:sectionNum
            [ ~,~,~,~,tempSectionTotalT,tempSectionLeftE ] = optimalSectionAlgo( section.EndS(i,1),...
                section.EndS(i,2),section.EndV(i,1),section.EndV(i,2),section.E(i)+deltaE,section.SpeedLimit(i),gradient,curvature );
            saveTimePerE(i) = (section.UsedT(i) - tempSectionTotalT) / (deltaE - tempSectionLeftE);
        end
    else % ������ǵ�һ��ѭ������������¹�������ĵ�λ������ʡʱ��
        [ ~,~,~,~,tempSectionTotalT,tempSectionLeftE ] = optimalSectionAlgo( section.EndS(i,1),...
            section.EndS(i,2),section.EndV(i,1),section.EndV(i,2),section.E(i)+deltaE,section.SpeedLimit(i),gradient,curvature );
        saveTimePerE(i) = (section.UsedT(i) - tempSectionTotalT) / (deltaE - tempSectionLeftE);
    end
    firstFlag = 0;                          % ��һ��ѭ����firstFlagΪ0
    [~,i]=max(saveTimePerE);                % ѡȡ��λ������ʡʱ����������
    % ��ѡ�е���������Ż�
    [ section.S{i},section.V{i},section.T{i},section.F{i},section.UsedT(i),tempSectionLeftE ] = optimalSectionAlgo( section.EndS(i,1),...
        section.EndS(i,2),section.EndV(i,1),section.EndV(i,2),section.E(i)+deltaE,section.SpeedLimit(i),gradient,curvature );
    section.E(i) = section.E(i) + deltaE - tempSectionLeftE;
    % ���¼���·����ʱ��
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
%     ;... % �д�������д
%     currentSection = tempIndex(end);
% end
% 
% 
% S = cat(2,sectionS{:});
% F = cat(2,sectionF{:});
% % ���㹫��꣺ �����ľ���
% calS = -(S - S(1));
% % ������룺 ����һվ�ľ���
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
%interSta2all ��վ������ת��Ϊȫ������
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
% ���㹫��꣺ �����ľ���
calS = -(S - S(1));
% ������룺 ����һվ�ľ���
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
%section2interSta ���ܵ�������Ϣת��Ϊվ��֮�����Ϣ

index = [0;cumsum(interStaSectionNum)];
interSta = cell(length(interStaSectionNum),1);
for i = 1:length(interStaSectionNum)
    interSta{i}=mergeSection(section,(index(i)+1):(index(i+1)));
end

end

function mergeSec=mergeSection(section,mergeVec)
% ��ʼ���ϲ�������
mergeSec.S = cell(0);    % ����Ĺ��������
mergeSec.V = cell(0);    % ������ٶ�����
mergeSec.T = cell(0);    % �����ʱ������
mergeSec.F = cell(0);    % �����ǣ��������

mergeSec.EndS = [];      % ����Ķ˵㹫���
mergeSec.EndV = [];      % ����Ķ˵��ٶ�

mergeSec.S = cat(2,section.S{mergeVec});
mergeSec.V = cat(2,section.V{mergeVec});
mergeSec.F = cat(2,section.F{mergeVec});
mergeSec.T = section.T{mergeVec(1)};
for i = 2:length(mergeVec)
    mergeSec.T = [mergeSec.T,section.T{mergeVec(i)} + mergeSec.T(end)];
end
mergeSec.EndS = [section.EndS(mergeVec(1),1),section.EndS(mergeVec(end),2)];
mergeSec.EndV = [section.EndV(mergeVec(1),1),section.EndV(mergeVec(end),2)];
mergeSec.E = sum(section.E(mergeVec)); % �������������
mergeSec.UsedT = sum(section.UsedT(mergeVec)); % ����Ļ���ʱ��


end
