function [W] = totalResistanceFun(v, s, gradient, curvature)
%totalResistanceFun ����λ��s�� �ٶ�Ϊvʱ ���¶Ⱥ�����
%   ���������
%       v --- ��ǰ�ٶ� ��λ��km/h
%       s --- ��ǰ�����
%       gradient --- �¶�����
%       curvature --- ��������
%   ���������
%       W --- ������ ��λ��N

g = 9.8; % �������ٶ�
M = 194295; % �г����� ��λ kg

% �г�������������
A = 2.031;
B = 0.0622;
C = 0.001807;

% ��������
w0 = A + B * v + C * v^2;

% ��������
[ i,R ] = groundConditionFun( s, gradient, curvature);
c = 600; % cΪ�ۺϷ�ӳӰ����������������صľ��鳣�����ҹ������ͨһ��ȡ600
wi = i;
if R == 0
    wc = 0;
else
    wc = c / R;
end

W = (w0 + wi + wc) * g * M / 1000;
end


