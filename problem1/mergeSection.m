function mergeSec=mergeSection(section,mergeVec)
% 初始化合并的区间
mergeSec.S = cell(0);    % 区间的公里标向量
mergeSec.V = cell(0);    % 区间的速度向量
mergeSec.T = cell(0);    % 区间的时间向量
mergeSec.F = cell(0);    % 区间的牵引力向量

mergeSec.EndS = [];      % 区间的端点公里标
mergeSec.EndV = [];      % 区间的端点速度

mergeSec.S = cat(2,section.S{mergeVec});
mergeSec.V = cat(2,section.V{mergeVec});
mergeSec.F = cat(2,section.F{mergeVec});
mergeSec.T = section.T{mergeVec(1)};
for i = 2:length(mergeVec)
    mergeSec.T = [mergeSec.T,section.T{mergeVec(i)} + mergeSec.T(end)];
end
mergeSec.EndS = [section.EndS(mergeVec(1),1),section.EndS(mergeVec(end),2)];
mergeSec.EndV = [section.EndV(mergeVec(1),1),section.EndV(mergeVec(end),2)];
mergeSec.E = sum(section.E(mergeVec)); % 区间的能量消耗
mergeSec.UsedT = sum(section.UsedT(mergeVec)); % 区间的花费时间

mergeSec.braking = cat(1,section.braking{mergeVec});


end
