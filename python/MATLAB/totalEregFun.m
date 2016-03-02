function [totalEregE]=totalEregFun(stopTime, H, tractionSec, brakingSec, brakingSecEreg, tractionIndex, brakingIndex)
cumStopTime = [0,cumsum(stopTime)];
tractionSec = tractionSec + repmat(cumStopTime(tractionIndex+1)',1,2);
brakingSec = brakingSec + repmat(cumStopTime(brakingIndex+1)',1,2);

cumH = [0,cumsum(H)];
% 合并牵引区间
lenCumH = length(cumH);
lenTra = size(tractionSec, 1);
tractionSec = repmat(tractionSec, lenCumH, 1);
tempMat = repmat(cumH, lenTra, 2);
tempMat = reshape(tempMat, lenCumH*lenTra, 2);
tractionSec = tractionSec + tempMat;
tractionSec = mergeTractionSection(tractionSec);

totalEregE = 0.;
for i = 1:length(cumH)
    totalEregE = totalEregE + eregFun(tractionSec, brakingSec+cumH(i), brakingSecEreg);
end
totalEregE = -totalEregE / 3.6e6;

end

function eregE = eregFun(tractionSec, brakingSec, brakingSecEreg)
diffB = brakingSec(:,2) - brakingSec(:,1);
eregE = 0.;
for i = 1:size(brakingSec,1)
    over = false;
    for j = 1:size(tractionSec, 1)
        lower = max(brakingSec(i,1),tractionSec(j,1));
        upper = min(brakingSec(i,2),tractionSec(j,2));
        if lower < upper
            over = true;
            eregE = eregE + brakingSecEreg(i) * (upper - lower) / diffB(i);
        else
            if over
                break
            end
        end
    end
end
end
