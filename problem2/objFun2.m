function [ objValue ] = objFun2( H,brakingTimeSection,brakingSectionEnergy,tractionSection )
%objFun 第二问第二小问目标函数

cumH = cumsum(H);
% 合并牵引区间
for i = 1:length(H)
    tractionSection = mergeTractionSection(tractionSection,tractionSection+cumH(i));
end

objValue = saveEnergyFun(brakingTimeSection,brakingSectionEnergy,tractionSection);
% 计算节约能量
for i = 1:length(H)
    objValue = objValue + saveEnergyFun(brakingTimeSection+cumH(i),brakingSectionEnergy,tractionSection);
end
objValue = -objValue;

disp(objValue)
end


