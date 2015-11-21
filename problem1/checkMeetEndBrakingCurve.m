function y = checkMeetEndBrakingCurve(s,v,endBrakingCurveS,endBrakingCurveV)
%checkMeetEndBrakingCurve 检测是否遇到终点制动曲线，如果遇到终点制动曲线，则返回1，否则返回0
index = find(endBrakingCurveS>s,1);
brakingV = endBrakingCurveV(index);
if v > brakingV
    y = 1;
else
    y = 0;
end

end