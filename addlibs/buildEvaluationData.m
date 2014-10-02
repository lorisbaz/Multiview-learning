%% BUILD THE DATA testing
K_tst = zeros(m,length(lab_idx),t);
for mi = 1:m
    K_tst(mi,:,:) = Kernels_tst{nRun,viewlist(mi)}.matrix(lab_idx,:);
end

Ytest = Y(nRun).test;
[~,YGT] = max(Ytest);
