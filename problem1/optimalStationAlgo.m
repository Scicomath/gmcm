function  [S,V,T,F,calS,calDist,Acce,interSta,totalT,totalE,brakingTerminal,...
    successFlag]=optimalStationAlgo( As,At,dwellTime,targetT,speedLimit,gradient,...
    curvature,brakingCurveS,brakingCurveV,curveTerminal,stationP,deltaE)
%optimalStationAlgo ��վ֮������Ż��㷨
%   ���������
%       As --- ��ʼ��վ��
%       At --- �յ㳵վ��
%       dwellTime --- վ���ͣ��ʱ��
%       targetT --- ȫ�̵�Ŀ��ʱ��
%       speedLimit --- �ٶ���������
%       gradient --- �¶�����
%       curvature --- ��������
%       brakingCurveS --- �����ƶ����ߵĹ��������
%       brakingCurveV --- �����ƶ����ߵ��ٶ�����
%       curveTerminal --- �����ƶ����ߵĶ˵�����
%       stationP --- ��վ��Ĺ��������
%       deltaE --- ÿ�η��������
%   ���������
%       S --- ���������
%       V --- ��Ӧ���ٶ�����
%       T --- ��Ӧ��ʱ������
%       F --- ��Ӧ��ǣ��������
%       calS --- ��Ӧ�ļ��㹫�������
%       calDist --- ��Ӧ�ļ����������
%       Acce --- ��Ӧ�ļ��ٶ�����
%       interSta --- վ������
%       totalT --- ȫ�����ĵ���ʱ��
%       totalE --- ȫ�����ĵ�������
%       brakingTerminal --- ȫ�̵��ƶ�����˵�����

A = As:At;              % ��ʼ��վ���յ㳵վ������
N = length(A) - 1;      % վ������ĸ���

% �������ݳ�ʼ��
section.S = cell(0);    % ����Ĺ��������
section.V = cell(0);    % ������ٶ�����
section.T = cell(0);    % �����ʱ������
section.F = cell(0);    % �����ǣ��������

section.braking = cell(0); % �����ƶ�����

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
    section.braking = [section.braking;tempSection.braking];
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
previousT = 0;
successFlag = 1;
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
    [ section.S{i},section.V{i},section.T{i},section.F{i},section.UsedT(i),tempSectionLeftE,section.braking{i} ] = optimalSectionAlgo( section.EndS(i,1),...
        section.EndS(i,2),section.EndV(i,1),section.EndV(i,2),section.E(i)+deltaE,section.SpeedLimit(i),gradient,curvature );
    section.E(i) = section.E(i) + deltaE - tempSectionLeftE;
    % ���¼���·����ʱ��
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
