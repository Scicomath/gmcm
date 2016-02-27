function [y] = fun(x)
% x(1) 非高峰期 发车间隔
n = zeros(1,5);
totalT = 0.;
n(1) = ceil(7200/x(1));
totalT = totalT + n(1)*x(1);
n(2) = ceil((12600 - totalT)/x(2));
totalT = totalT + n(2)*x(2);
n(3) = ceil((43200 - totalT)/x(1));
totalT = totalT + n(3)*x(1);
n(4) = ceil((50400 - totalT)/x(2));
totalT = totalT + n(4)*x(2);
n(5) = 239-sum(n(1:4));
totalT = totalT + n(5)*x(1);
target = 63900;
y = abs(totalT - target);
disp(n)
end