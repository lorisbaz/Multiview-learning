% --------------------------------------------------------------------
%                                                         Plot results
% --------------------------------------------------------------------
% Compute the confusion matrix
idx = sub2ind([nClasses, nClasses], ...
              YGT, Y_est) ;
confus = zeros(nClasses) ;
confus = vl_binsum(confus, ones(size(idx)), idx) ;

% Plots
figure(1) ; clf;
imagesc(confus) ;
% set(gca,'XTick',1:length(className))
% set(gca,'XTickLabel',className)
% rotateXLabels(gca, 90);
set(gca,'YTick',1:length(className))
set(gca,'YTickLabel',className)
rotateXLabels(gca, 90);
title(sprintf('Confusion matrix (%.2f %% accuracy)', ...
              100 * mean(diag(confus)/(t/nClasses)) )) ;

% plot the error for each class
figure(2); clf
bar(errorC)
set(gca,'XTick',1:length(className))
set(gca,'XTickLabel',className)
rotateXLabels(gca, 90);