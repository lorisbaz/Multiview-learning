function [estimatedLabels,confidence,labels] = MV_MC_leastsquare_testing(bG_test,At,C,P,m)
% [estimatedLabels,confidence,labels] = MV_MC_leastsquare_testing(bG_test,At,C,P,m)
%  Given a solution of the multi-view least square problems, this function
%  estimate the labels of new testing examples.
%
% Input:
% - bG_test: \mathbf{G} matrix (see paper, paragraph "Evaluation on a Testing Sample") 
% - At: solution of the learning problem (see paper, eq. 43-44)
% - C: Combination operator
% - P: # of classes
% - m: # of views
%
% Output:
% - estimatedLabels: estimated vector values
% - confidence: confidence of classification
% - labels: estimated labels (max of estimatedLabels)
%

% Loris Bazzani, Minh Ha Quang


fprintf('-- Testing ')
tic
   
t = size(bG_test,1)/m;

estimatedLabels = zeros(P,t,'single');
batch_size = 100;

% Evaluation Testing
jj = 1;
for i=1:batch_size:t % For one test sample
    
    idsF = [(i-1)*m+1:min((i+batch_size-1)*m,t*m)];
    
    bG_test_tmp = bG_test(idsF,:);
    
    testKernelTimesA = At*bG_test_tmp'; % of size P*m
    for j = 1:m:length(idsF)
        testKernelTimesA_now = testKernelTimesA(:,j:j+m-1);
        testKernelTimesA_now = testKernelTimesA_now(:);
        estimatedLabels(:, jj) = C*testKernelTimesA_now;
        jj = jj+1;
    end
end

[confidence,labels] = max(estimatedLabels); % assign labels from vector

tm = toc;
fprintf('time %3.2f s',tm);


