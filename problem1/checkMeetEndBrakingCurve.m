function y = checkMeetEndBrakingCurve(s,v,endBrakingCurveS,endBrakingCurveV)
%checkMeetEndBrakingCurve ����Ƿ������յ��ƶ����ߣ���������յ��ƶ����ߣ��򷵻�1�����򷵻�0
index = find(endBrakingCurveS>s,1);
brakingV = endBrakingCurveV(index);
if v > brakingV
    y = 1;
else
    y = 0;
end

end