function interSta =section2interSta(section,interStaSectionNum)
%section2interSta ���ܵ�������Ϣת��Ϊվ��֮�����Ϣ

index = [0;cumsum(interStaSectionNum)];
interSta = cell(length(interStaSectionNum),1);
for i = 1:length(interStaSectionNum)
    interSta{i}=mergeSection(section,(index(i)+1):(index(i+1)));
end

end