function [ section ] = vec2section( vec )
%vec2section ������ת��Ϊ����

firstIndex = [1,find(diff(vec)~=1)+1];
endIndex = [find(diff(vec)~=1),length(vec)];
section = [vec(firstIndex);vec(endIndex)]';

end

