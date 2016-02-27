function [x,fval,exitflag,output,population,score] = subProblem1GA(gaObjFun,nvars,Aeq,beq,lb,ub,PopInitRange_Data,PopulationSize_Data)
%% This is an auto generated MATLAB file from Optimization Tool.

%% Start with the default options
options = gaoptimset;
%% Modify options setting
options = gaoptimset(options,'PopInitRange', PopInitRange_Data);
options = gaoptimset(options,'PopulationSize', PopulationSize_Data);
options = gaoptimset(options,'Generations', 600);
options = gaoptimset(options,'Display', 'off');
options = gaoptimset(options,'PlotFcns', {  @gaplotbestf @gaplotbestindiv });
[x,fval,exitflag,output,population,score] = ...
ga(gaObjFun,nvars,[],[],Aeq,beq,lb,ub,[],[],options);
end