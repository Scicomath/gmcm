% 读取数据脚本
% 车站公里标 stationP
stationP = [22903,21569,20283,18197,15932,13594,12240,10960,9422,8429,6447,...
    4081,2806,175]; 
% 坡度数据 gradient
gradient = xlsread('线路参数.xlsx',2);
% 限速数据 speedLimit
speedLimit = xlsread('线路参数.xlsx',3);
% 曲率数据 curvature
curvature = xlsread('线路参数.xlsx',4);

tranCurva = curvature;
for i = 1:size(tranCurva,1)
    if curvature(i,2)~=0
        tranCurva(i,2) = 600 / curvature(i,2);
    end
end