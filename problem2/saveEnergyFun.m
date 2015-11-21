function E=saveEnergyFun(brakingTimeSection,brakingSectionEnergy,tractionSection)
%saveEnergyFun 计算利用的再生能量函数
E = 0;
for i = 1:size(brakingTimeSection,1)
    for j = 1:size(tractionSection,1)
        if ~(min(tractionSection(j,:))>max(brakingTimeSection(i,:)) ||...
                max(tractionSection(j,:))<min(brakingTimeSection(i,:)))
            temp = sort([brakingTimeSection(i,:),tractionSection(j,:)]);
            E = E + (temp(3) - temp(2))/(brakingTimeSection(i,2) - brakingTimeSection(i,1)) * brakingSectionEnergy(i);
        end
    end
end

end