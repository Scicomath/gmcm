function [ objVelue ] = objFun( H,brakingTimeSection,brakingSectionEnergy,tractionSection )
%objFun �ڶ��ʵ�һС��Ŀ�꺯��
%   �˴���ʾ��ϸ˵��
cumH = cumsum(H);
% �ϲ�ǣ������
for i = 1:length(H)
    tractionSection = mergeTractionSection(tractionSection,tractionSection+cumH(i));
end

objVelue = saveEnergyFun(brakingTimeSection,brakingSectionEnergy,tractionSection);
% �����Լ����
for i = 1:length(H)
    objVelue = objVelue + saveEnergyFun(brakingTimeSection+cumH(i),brakingSectionEnergy,tractionSection);
end
objVelue = -objVelue;
disp(objVelue)
end


