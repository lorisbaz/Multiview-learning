function [error,errorC] = performance_Y(guess,y)
% [error,errorC] = performance_Y(guess,y)
%    This function computes the (averaged) classification error given the
%    estimates of the samples and the ground truth.
%
% Input:
% guess: estimated labels
% y: ground truth labels
%
% Output:
% error: averaged classification error
% errorC: classification error for each class
%

% Loris Bazzani, Minh Ha Quang

% overall accuracy
error=1-sum(guess==y)/length(y);
    
% single-class accuracies
errorC = zeros(max(y),1);
for i = 1:max(y)   
   errorC(i)=1-sum(guess(y==i)==i)/sum(y==i); 
end
    
fprintf(' -- Accuracy: %3.2f%% \n', (1-error)*100);
