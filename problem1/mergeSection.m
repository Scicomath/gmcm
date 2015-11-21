function mergeSec=mergeSection(section,mergeVec)
% ��ʼ���ϲ�������
mergeSec.S = cell(0);    % ����Ĺ��������
mergeSec.V = cell(0);    % ������ٶ�����
mergeSec.T = cell(0);    % �����ʱ������
mergeSec.F = cell(0);    % �����ǣ��������

mergeSec.EndS = [];      % ����Ķ˵㹫���
mergeSec.EndV = [];      % ����Ķ˵��ٶ�

mergeSec.S = cat(2,section.S{mergeVec});
mergeSec.V = cat(2,section.V{mergeVec});
mergeSec.F = cat(2,section.F{mergeVec});
mergeSec.T = section.T{mergeVec(1)};
for i = 2:length(mergeVec)
    mergeSec.T = [mergeSec.T,section.T{mergeVec(i)} + mergeSec.T(end)];
end
mergeSec.EndS = [section.EndS(mergeVec(1),1),section.EndS(mergeVec(end),2)];
mergeSec.EndV = [section.EndV(mergeVec(1),1),section.EndV(mergeVec(end),2)];
mergeSec.E = sum(section.E(mergeVec)); % �������������
mergeSec.UsedT = sum(section.UsedT(mergeVec)); % ����Ļ���ʱ��

mergeSec.braking = cat(1,section.braking{mergeVec});


end
