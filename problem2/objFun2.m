function [ objValue ] = objFun2( H,brakingTimeSection,brakingSectionEnergy,tractionSection )
%objFun �ڶ��ʵڶ�С��Ŀ�꺯��

cumH = cumsum(H);
% �ϲ�ǣ������
for i = 1:length(H)
    tractionSection = mergeTractionSection(tractionSection,tractionSection+cumH(i));
end

objValue = saveEnergyFun(brakingTimeSection,brakingSectionEnergy,tractionSection);
% �����Լ����
for i = 1:length(H)
    objValue = objValue + saveEnergyFun(brakingTimeSection+cumH(i),brakingSectionEnergy,tractionSection);
end
objValue = -objValue;

disp(objValue)
end


