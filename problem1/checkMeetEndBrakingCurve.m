function y = checkMeetEndBrakingCurve(s,v,endBrakingCurveS,endBrakingCurveV)
% 如果遇到制动曲线，则返回1，否则返回0
index = find(endBrakingCurveS>s,1);
brakingV = endBrakingCurveV(index);
if v > brakingV
    y = 1;
else
    y = 0;
end

end