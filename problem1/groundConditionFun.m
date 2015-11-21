function [ i,R,addedI ] = groundConditionFun( s,gradient,curvature )
%groundConditionFun ����λ��s�����¶Ⱥ������Լ������¶�
%   ���������
%       s --- ��ǰ�����
%       gradient --- �¶�����
%       curvature --- ��������
%   ���������
%       i --- s�����¶�
%       R --- s��������
%       addedI --- s���������¶�

% �����¶�
index = find(gradient(:,3) > s,1);
i = -gradient(index,2); % �¶ȷ��ţ���Ϊ�Ƿ�����ʻ

% ��������
index = find(curvature(:,3) > s,1);
R = curvature(index,2);

c = 600; % cΪ�ۺϷ�ӳӰ����������������صľ��鳣�����ҹ������ͨһ��ȡ600

if R ==0
    addedI = i;
else
    addedI = i + c / R;
end

end