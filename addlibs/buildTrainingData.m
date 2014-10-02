%% BUILD THE training DATA

% compute the indexes of LABELED data to keep
lab_idx_lab   = zeros(l,1);
lab_idx_unlab = zeros(u,1);
for i = 1:P  % select a subset of unlabeled data based on labels
    lab_idx2 = find(Y(nRun).train(i,:)==1);
    lab_idx3 = lab_idx2(1:length(lab_idx2)/2);    
    lab_idx3l = lab_idx3(1:labdata); % labeled
    lab_idx3u = lab_idx3(labdata+1:labdata+uc); % unlabeled
    
    lab_idx3t = lab_idx2(length(lab_idx2)/2+1:end);    % transformed images
    lab_idx3tl = lab_idx3t(1:labdata); % labeled
    lab_idx3tu = lab_idx3t(labdata+1:labdata+uc); % unlabeled

    lab_idx_lab((i-1)*labdata*2+1:i*labdata*2) = [lab_idx3l,lab_idx3tl];
    
    lab_idx_unlab((i-1)*uc*2+1:i*uc*2) = [lab_idx3u,lab_idx3tu];
end
lab_idx = [lab_idx_lab; lab_idx_unlab];

K_trn = zeros(m,length(lab_idx),length(lab_idx));
for mi = 1:m
    K_trn(mi,:,:) = Kernels_trn{nRun,viewlist(mi)}.matrix(lab_idx,lab_idx);
end

Ytrain = Y(nRun).train(:,lab_idx);
Ytrain(:,l+1:end) = 0; % remove labels from unlabeled data
