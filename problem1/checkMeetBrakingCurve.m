function y = checkMeetBrakingCurve(s,v,BrakingCurveS,BrakingCurveV,curveTerminal)
% 如果遇到制动曲线，则返回1，否则返回0
index = find(curveTerminal(:,1)>s,1);
if isempty(index)
    y = 0;
elseif curveTerminal(index,2)<s
    index2 = find(BrakingCurveS>s,1);
    brakingV = BrakingCurveV(index2);
    if v > brakingV
        y = 1;
    else
        y = 0;
    end
else
    y = 0;
end

end
