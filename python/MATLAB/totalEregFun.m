function [totalEregE]=totalEregFun(stopTime, diffT, times, tractionSec, brakingSec, brakingSecEreg, tractionIndex, brakingIndex)
cumStopTime = [0,cumsum(stopTime)];
tractionSec = tractionSec + repmat(cumStopTime(tractionIndex+1)',1,2);
brakingSec = brakingSec + repmat(cumStopTime(brakingIndex+1)',1,2);
totalEregE = 0.;
prev = 0.;
for m = 1:length(diffT)
    %eregE = eregE + times(i)*eregFun(diffT(i), tractionSec, brakingSec, brakingSecEreg);
    brakingSec = brakingSec + (diffT(m)-prev);
    prev = diffT(m);
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
    totalEregE = totalEregE + times(m) * eregE;
end
totalEregE = -totalEregE / 3.6e6;
% disp(eregE)
end

function eregE = eregFun(diffT, tractionSec, brakingSec, brakingSecEreg)
brakingSec = brakingSec + diffT;
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
