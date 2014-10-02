%% Multiview Multiclass Least Square Learning
%  Test on Caltech 101 using Vedaldi's kernels
clear; close all;

%% Load the toolbox and additional libs for the experiment
TOOLBOXPATH = './';   % absolute path where the toolbox is located
addpath([TOOLBOXPATH 'MV_leastsquare/']) % load the toolbox
addpath(genpath([TOOLBOXPATH 'addlibs/'])) % load the add libs


%% Set dataset and kernel set paths
KERNELPATH  = './';


%% Choose which experience to run
PLOT_CONFMAT  = 0; % display confusion matrix at each step
viewlist= [3,6,9,10]; % select the view you want to use (indexes 1...10)
labdata = 5; % training data: max 15 per class
uc      = 1; % unlabeled: must be (15 - labdata)


%% PARAMETERS of the multiview multiclass least square learning
params_mv.gA = 10^(-5);  % RKHS regularization
params_mv.gB = 10^(-6);  % between-view regularization
params_mv.gW = 10^(-6);  % within-view regularization
params_mv.c  = ones(length(viewlist),1)/length(viewlist); % uniform weighting to build the matrix C
params_mv.Laplacian.GraphNormalize = 1; % parameter to compute the laplacian 

% check consistency
if(15-labdata<uc) % This is just for caltech exp where the # of labeled data is max 15 per class
    uc = min([15-labdata,uc]);
    fprintf('Warning: number of unlabeled data is set to %d. \n',uc)
end


%% LOAD kernels, splits and experiment
Load_Kernels;


%% Run evaluation of the algorithm over different splits
for nRun = 1:nRUNS % xvalRuns % xvalRuns loaded from partition mat file
    fprintf('  |- RUN %d -- ',nRun)

    % convert the original data to our standard structures:
    buildTrainingData;
    buildEvaluationData;

    % Training
    [bG_trn, L]  = make_boldG_Laplacian(K_trn,params_mv,l,u,m,'training'); % if you have a laplacian add Lapl to the input
    [At, C]  = MV_MC_leastsquare_training(bG_trn,L,Ytrain,params_mv,P,l,u,m);

    % Testing
    [bG_tst, ~] = make_boldG_Laplacian(K_tst,params_mv,l,u,m,'testing');
    [estimatedLabels, conf, Y_est] = MV_MC_leastsquare_testing(bG_tst,At,C,P,m);    

    % Compute statistics
    [error_t, errorC] = performance_Y(Y_est,YGT);
    
    % Visualize confusion matrix (if needed)
    if PLOT_CONFMAT
        plot_confMat;
    end
    
    % Store results
    results.errors_test(nRun,:) = error_t;

end

% Final statistics averaged over runs
results.errors_test_avg = mean(results.errors_test);
results.errors_test_std = std(results.errors_test);

fprintf('  ==> AVERAGE Accuracy: %3.2f%% (%3.2f%%)\n\n', (1-results.errors_test_avg)*100,results.errors_test_std*100);
