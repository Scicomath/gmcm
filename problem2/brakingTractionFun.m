function [ brakingTimeSection,brakingSectionEnergy,tractionSection ] = brakingTractionFun( brakingTerminal,S,T,F,brakingCurveS,brakingCurveEreg )
%brakingTractionFun 计算制动与牵引的时间区间

tempIndex = find(diff(S)==0);
if ~isempty(tempIndex)
    S(tempIndex) = [];
    T(tempIndex) = [];
    F(tempIndex) = [];
end

N = size(brakingTerminal,1);
brakingSectionEnergy = zeros(N,1);
brakingTimeSection = zeros(N,2);
for i = 1:N
    brakingSectionEnergy(i) = sum(brakingCurveEreg(brakingCurveS<brakingTerminal(i,1)&brakingCurveS>brakingTerminal(i,2)));
    brakingTimeSection(i,:) = interp1(S,T,brakingTerminal(i,:),'nearest');
end

tractionVec = find(F>0);
tractionSection = vec2section(tractionVec);
[m,n] = size(tractionSection);
for i = 1:m
    for j = 1:n
        tractionSection(i,j) = T(tractionSection(i,j));
    end
end

end

