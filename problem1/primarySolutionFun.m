function [ S,V,E,T,F,totalE,totalT,section ] =...
    primarySolutionFun( s0,s1,speedLimit,gradient,...
    curvature, brakingCurveS,brakingCurveV,curveTerminal )
%primarySolutionFun ��������վ��֮��ĳ�ʼ��
%   ���������
%       s0 --- ��ʼ�����
%       s1 --- �յ㹫���
%       speedLimit --- �ٶ����ƾ���
%       gradient --- ������¶�
%       curvature --- ���������
%       brakingCurveS --- �����ƶ����߹��ﱨ����
%       brakingCurveV --- �����ƶ������ٶ�����
%       curveTerminal --- �����ƶ����߶˵�����
%
%   ���������
%       S --- ���������
%       V --- ��Ӧ���ٶ�����
%       E --- ��Ӧ��������������
%       T --- ��Ӧ��ʱ������
%       F --- ��Ӧ��ǣ��������
%       totalE --- ���ĵ�������
%       totalT --- ���ĵ���ʱ��
%       section.EndS --- ����ĳ�ʼ����ֹ�����
%       section.EndV --- ����ĳ�ʼ����ֹ�ٶ�
%       section.SpeedLimit --- ������ٶ�����
%       section.E --- �������ĵ�����
%       section.usedT --- �������ĵ�ʱ��
%       section.S --- ����Ĺ��������
%       section.V --- ������ٶ�����
%       section.T --- �����ʱ������
%       section.braking --- ������ƶ�����

index1 = find(speedLimit(:,3)>=s0,1);
index2 = find(speedLimit(:,3)>s1,1);
section.EndS = [];
section.SpeedLimit = [];

brakingTerminal = [];
if index1 == index2
    section.EndS = [s0,s1];
    section.SpeedLimit = speedLimit(index1,2);
else
    for i = index1:-1:index2
        if i == index1
            section.EndS = [section.EndS;s0,speedLimit(i,1)];
            section.SpeedLimit = [section.SpeedLimit;speedLimit(i,2)];
        elseif i == index2
            section.EndS = [section.EndS;speedLimit(i,3),s1];
            section.SpeedLimit = [section.SpeedLimit;speedLimit(i,2)];
        else
            section.EndS = [section.EndS;speedLimit(i,[3 1])];
            section.SpeedLimit = [section.SpeedLimit;speedLimit(i,2)];
        end
    end
end
if (section.EndS(1,1) - section.EndS(1,2)) <= 3
    section.EndS(2,1) = section.EndS(1,1);
    section.EndS(1,:) = [];
    section.SpeedLimit(1) = [];
end
if (section.EndS(end,1) - section.EndS(end,2)) <= 3
    section.EndS(end-1,2) = section.EndS(end,2);
    section.EndS(end,:) = [];
    section.SpeedLimit(end) = [];
end


sectionNum = size(section.EndS,1);
section.EndV = zeros(sectionNum,2);
section.E = zeros(sectionNum,1);
section.usedT = zeros(sectionNum,1);

section.S = cell(sectionNum,1);
section.V = cell(sectionNum,1);
section.T = cell(sectionNum,1);
section.F = cell(sectionNum,1);

M = 194295; % �г����� kg
highSpeed = 50/3.6; % ������ٵ�������ٶ�
L = 10000;
S = linspace(s0,s1,L);
Ssize = size(S);
V = zeros(Ssize);
E = zeros(Ssize);
F = zeros(Ssize);

% �յ��ƶ�����
[ endBrakingCurveV,endBrakingCurveS ] = brakingCurveFun( s0, s1, 0, gradient, curvature );


E(1) = 0; % ����������ʼ��
V(1) = 0; % ��ʼ�ٶ�Ϊ0

% ǣ���׶�
i = 2;
while (i<length(V) && V(i-1) < highSpeed)
    [ Fmax ] = maxTractionFun( V(i - 1) );
    [W] = totalResistanceFun(V(i - 1), S(i-1), gradient, curvature);
    capacityMaxA = (Fmax - W) / M; % �ܹ��ﵽ�������ٶ�
    if capacityMaxA > 1
        a = 1; % ʵ�ʼ��ٶ�, ��Ϊ��Ŀ���������ٶȲ��ܳ���1
        totalF = M * a; % ����
        F(i - 1) = totalF + W; % ʵ��ǣ����
    else
        a = capacityMaxA;
        F(i - 1) = Fmax;
    end

    V(i) = sqrt((V(i-1))^2 + 2 * a * (S(i-1) - S(i)));

    if checkMeetEndBrakingCurve(S(i),V(i),endBrakingCurveS,endBrakingCurveV)
        V(i-1:end) = interp1(endBrakingCurveS,endBrakingCurveV,S(i-1:end),'pchip');
        brakingTerminal = [brakingTerminal;S(i-1),S(end)]; % ��¼�ƶ�����
        E(i:end) = E(i-1);
        i = length(V);
    elseif checkMeetBrakingCurve(S(i),V(i),brakingCurveS,brakingCurveV,curveTerminal)
        index = find(curveTerminal(:,1)>S(i),1);
        tempEnd = curveTerminal(index,2);
        index2 = find(S<tempEnd,1);
        V(i-1:index2) = interp1(brakingCurveS,brakingCurveV,S(i-1:index2),'pchip');
        brakingTerminal = [brakingTerminal;S(i-1),S(index2)]; % ��¼�ƶ�����
        E(i:index2) = E(i-1);
        i = index2 + 1;
        break
    else
        E(i) = E(i-1) + F(i - 1) * (S(i-1) - S(i));
        i = i + 1;
    end
end

% �������ƶ��׶�
while (i<=length(V))
    [W] = totalResistanceFun(V(i - 1), S(i-1), gradient, curvature);
    a = -W / M; % ���м��ٶ�
    if a < -0.04
        a = - 0.04;
        realF = M * a;
        F(i - 1) = realF + W;
    end
    V(i) = sqrt((V(i-1))^2 + 2 * a * (S(i-1) - S(i)));
    E(i) = E(i-1) + F(i - 1) * (S(i-1) - S(i));
    if checkMeetEndBrakingCurve(S(i),V(i),endBrakingCurveS,endBrakingCurveV)
        V(i-1:end) = interp1(endBrakingCurveS,endBrakingCurveV,S(i-1:end),'pchip');
        brakingTerminal = [brakingTerminal;S(i-1),S(end)]; % ��¼�ƶ�����
        E(i:end) = E(i-1);
        i = length(V)+1;
    elseif checkMeetBrakingCurve(S(i),V(i),brakingCurveS,brakingCurveV,curveTerminal)
        index = find(curveTerminal(:,1)>S(i),1);
        tempEnd = curveTerminal(index,2);
        index2 = find(S<tempEnd,1);
        V(i-1:index2) = interp1(brakingCurveS,brakingCurveV,S(i-1:index2),'pchip');
        brakingTerminal = [brakingTerminal;S(i-1),S(index2)]; % ��¼�ƶ�����
        E(i:index2) = E(i-1);
        i = index2 + 1;
    else
        i = i + 1;
    end
end

diffS = abs(diff(S));
meanV = mean([V(1:end-1);V(2:end)]);
T = cumsum([0,diffS ./ meanV]);
totalT = T(end);
totalE = E(end);

% �����������������ʱ��
for i = 1:sectionNum
    tempE = interp1(S,E,section.EndS(i,:),'pchip');
    %tempT = interp1(S,T,section.EndS(i,:),'pchip');
    tempV = interp1(S,V,section.EndS(i,:),'pchip');
    section.E(i) = diff(tempE);
    %section.usedT(i) = diff(tempT);
    section.EndV(i,:) = tempV;
end

for i = 1:sectionNum
    if i == sectionNum
        tempIndex = S<=section.EndS(i,1)&S>=section.EndS(i,2);
    else
        tempIndex = S<=section.EndS(i,1)&S>section.EndS(i,2);
    end
    section.S{i} = S(tempIndex);
    tempT = T(tempIndex);
    section.T{i} = tempT - tempT(1);
    section.usedT(i) = section.T{i}(end);
    section.V{i} = V(tempIndex);
    section.F{i} = F(tempIndex);
end

% ��������ƶ�����
section.braking = cell(sectionNum,1);
for i = 1:sectionNum
    section.braking{i} = sectionBrakingFun(brakingTerminal,section.EndS(i,:));
end


end

function sectionBraking=sectionBrakingFun(brakingTerminal,sectionEndS)

index1 = find(brakingTerminal(:,2)<sectionEndS(1),1);
index2 = find(brakingTerminal(:,2)<sectionEndS(2),1);

if isempty(index1)
    if isempyt(index2)
        sectionBraking = brakingTerminal;
    else
        sectionBraking = brakingTerminal(1:index2,:);
        sectionBraking(end,2) = sectionEndS(2);
    end
else
    if isempty(index2)
        sectionBraking = brakingTerminal(index1:end,:);
        sectionBraking(1,1) = sectionEndS(1);
    elseif index1 == index2 && sectionEndS(2)>brakingTerminal(index1,1)
        sectionBraking = [];
    else
        sectionBraking = brakingTerminal(index1:index2,:);
        sectionBraking(1,1) = sectionEndS(1);
        sectionBraking(end,2) = sectionEndS(2);
    end
end

end