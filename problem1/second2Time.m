function [ timestr ] = second2Time( s )
%second2Time ����ת��Ϊ�ض���ʽ
%   ���������
%       s --- ��
%   ���������
%       timestr --- �ַ�����ʽ��ʱ��

h = floor(s / 3600);
s = s - h * 3600;

m = floor(s / 60);
s = s - m * 60;

timestr = sprintf('%-2.2i:%-2.2i:%-2.2i',h,m,s);

end

