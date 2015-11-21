function A2=mergeTractionSection(sec1,sec2)
% 合并牵引区间函数

A = [sec1;sec2];
n = size(A,1);
[t,p] = sort(A(:));
z = cumsum(accumarray((1:2*n)',2*(p<=n)-1));
z1 = [0;z(1:end-1)];
A2 = [t(z1==0 & z>0),t(z1>0 & z==0)];


end
