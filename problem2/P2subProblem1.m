% 第二问第二小问脚本

% 计算制动与牵引数据
[ brakingTimeSection,brakingSectionEnergy,tractionSection ] = brakingTractionFun( brakingTerminal,S,T,F,brakingCurveS,brakingCurveEreg );
H = 2*60 + (11-2)*60*rand(1,99);
tic
[ objVelue ] = objFun( H,brakingTimeSection,brakingSectionEnergy,tractionSection );
toc

gaObjFun = @(x)objFun( x,brakingTimeSection,brakingSectionEnergy,tractionSection );
Aeq = ones(1,99);
beq = 63900;
LB = 2*60*ones(1,99);
UB = 11*60*ones(1,99);
PopInitRange = [2*60;11*60];
PopulationSize = 20;
nvars = 99;


[x,fval,exitflag,output,population,score] = subProblem1GA(gaObjFun,nvars,Aeq,beq,LB,UB,PopInitRange,PopulationSize);