% 第二问第二小问脚本

% 计算制动与牵引数据
[ brakingTimeSection,brakingSectionEnergy,tractionSection ] = brakingTractionFun( brakingTerminal,S,T,F,brakingCurveS,brakingCurveEreg );
H = 2*60 + (11-2)*60*rand(1,240-1);
tic
[ objValue ] = objFun2( H,brakingTimeSection,brakingSectionEnergy,tractionSection );
toc

bestObjValue = 0;
for j = 1:1000
    H = zeros(1,240-1);
    s = 1.5;
    H(1) = 5*60 + rand(1) * (s*60);
    cumH = H(1);
    for i = 2:(240-1-10)
        if (cumH>7200 && cumH<12600) || (cumH>43200 && cumH<50400)
            H(i) = 2*60 + rand(1) * (0.5*60);
            cumH = cumH + H(i);
        else
            H(i) = 5*60 + rand(1) * (s*60);
            cumH = cumH + H(i);
        end
    end
    targetT = 63900;
    temp = (targetT  - sum(H))/10;

    H(240-10:end) = temp;
    
    [ objValue ] = objFun2( H,brakingTimeSection,brakingSectionEnergy,tractionSection );
    if temp > 300 && objValue < bestObjValue
        bestH = H;
        bestObjValue = objValue;
    end
end


bar(bestH)
xlabel('发车间隔')
ylabel('时间（s）')
title('第二问第二小问发车间隔')
printFigureToPdf('第二问第二小问发车间隔.pdf', [11.5,11],'centimeters',[0 0  0 0]);
