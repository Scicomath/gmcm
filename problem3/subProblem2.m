clear
addpath ../problem1
addpath ../problem2
readData

load brakingCurve.mat
load problem2stage1.mat
n = 100;
[ result ] = simulation( n,interSta,speedLimit,gradient,curvature,...
    brakingCurveS,brakingCurveV,curveTerminal,stationP );

extraEnergy = (result(:,5) - totalE)./(3600*1000);
extraEnergy(extraEnergy<0) = 0 ;
result(:,5) = extraEnergy;

% ������
fprintf('�ӳ�վ��&\t�ӳ�����&\t�ӳ�ʱ��&\t���ʱ��&\t�������� \\\\ \n')
for i = 1:size(result,1)
    fprintf('%d&\t%d&\t%.2f&\t%.2f&\t%.2f\\\\\n',result(i,1),result(i,2),result(i,3),result(i,4),result(i,5))
end