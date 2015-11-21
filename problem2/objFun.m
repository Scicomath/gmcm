function [ objVelue ] = objFun( H,brakingTimeSection,brakingSectionEnergy,tractionSection )
%objFun 第二问第一小问目标函数
%   此处显示详细说明
cumH = cumsum(H);
% 合并牵引区间
for i = 1:length(H)
    tractionSection = mergeTractionSection(tractionSection,tractionSection+cumH(i));
end

objVelue = saveEnergyFun(brakingTimeSection,brakingSectionEnergy,tractionSection);
% 计算节约能量
for i = 1:length(H)
    objVelue = objVelue + saveEnergyFun(brakingTimeSection+cumH(i),brakingSectionEnergy,tractionSection);
end
objVelue = -objVelue;
disp(objVelue)
end


