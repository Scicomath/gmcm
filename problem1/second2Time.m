function [ timestr ] = second2Time( s )
%second2Time 将秒转化为特定格式
%   输入参数：
%       s --- 秒
%   输出参数：
%       timestr --- 字符串格式的时刻

h = floor(s / 3600);
s = s - h * 3600;

m = floor(s / 60);
s = s - m * 60;

timestr = sprintf('%-2.2i:%-2.2i:%-2.2i',h,m,s);

end

