function [ section ] = vec2section( vec )
%vec2section 将向量转化为区间

firstIndex = [1,find(diff(vec)~=1)+1];
endIndex = [find(diff(vec)~=1),length(vec)];
section = [vec(firstIndex);vec(endIndex)]';

end

