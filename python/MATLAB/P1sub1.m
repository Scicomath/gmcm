gaObjFun = @(stopTime)totalEregFun(stopTime, [63900/99,63900/99*2, 63900/99*3],...
    [99, 98, 97], tractionSec, brakingSec, brakingSecEreg, tractionIndex, brakingIndex);
Aeq = ones(1,12);
beq = 420;
LB = 30*ones(1,12);
UB = 45*ones(1,12);
PopInitRange = [30;45];
PopulationSize = 200;
nvars = 12;


[x,fval,exitflag,output,population,score] = subProblem1GA(gaObjFun,nvars,Aeq,beq,LB,UB,PopInitRange,PopulationSize);