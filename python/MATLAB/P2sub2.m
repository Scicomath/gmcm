%[x,fval] = fmincon(@fun, [328.7421,149.8474],[],[],[],[],[300;120],[600;150]);
trainNum = [22    36    94    46    41];
gap = [328.7421,149.8474,328.7421,149.8474,328.7421];
H = [];
for i = 1:length(gap)
    H = [H,ones(1,trainNum(i))*gap(i)];
end
% totalGap = [];
% for i = 1:length(trainNum)
%     totalGap = [totalGap, ones(1,trainNum(i))*gap(i)];
% end
% goTime = [0,cumsum(totalGap)];
% 
% diffT = [];
% allTrain = 240;
% for i = 1:allTrain
%     for j = i+1:allTrain
%         temp = goTime(j)-goTime(i);
%         if temp<2050
%             diffT = [diffT;temp];
%         end
%     end
% end
% 
% diffT = uint32(diffT');
% table = tabulate(diffT);
% table = table(table(:,2)~=0,1:2);
% table = sortrows(table, -2);

gaObjFun = @(stopTime)totalEregFun(stopTime, H, tractionSec, brakingSec, brakingSecEreg, tractionIndex, brakingIndex);
Aeq = ones(1,12);
beq = 420;
LB = 30*ones(1,12);
UB = 45*ones(1,12);
PopInitRange = [30;45];
PopulationSize = 200;
nvars = 12;


[x,fval,exitflag,output,population,score] = subProblem1GA(gaObjFun,nvars,Aeq,beq,LB,UB,PopInitRange,PopulationSize);