% ��ȡ���ݽű�
% ��վ����� stationP
stationP = [22903,21569,20283,18197,15932,13594,12240,10960,9422,8429,6447,...
    4081,2806,175]; 
% �¶����� gradient
gradient = xlsread('��·����.xlsx',2);
% �������� speedLimit
speedLimit = xlsread('��·����.xlsx',3);
% �������� curvature
curvature = xlsread('��·����.xlsx',4);

tranCurva = curvature;
for i = 1:size(tranCurva,1)
    if curvature(i,2)~=0
        tranCurva(i,2) = 600 / curvature(i,2);
    end
end