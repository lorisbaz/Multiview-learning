function [L,options] = MYlaplacian(options,W)  

% LAPLACIAN  Computes the Graph Laplacian of the adjacency graph
%            of a data set X
%      
% [L,options]=laplacian(options,data)
% 
% Inputs: 
% 
% W : kernel
%
% options: a data structure with the following fields 
%			(type  help ml_options)
%
% options.NORMALIZE= 0 | 1 
%          (0 for un-normalized and 1 for normalized graph laplacian) 
%
% Output
%  L : sparse symmetric NxN matrix 
%  options: updated options structure (options)
%
% Notes: Calls adjacency.m to construct the adjacency graph. This is 
%        fully vectorized for fast performance.
%
% Author:
% Vikas Sindhwani (vikass@cs.uchicago.edu)
% 		[modified from Misha Belkin's code]
% Modified by Loris Bazzani


% tic;

D = sum(W(:,:),2);

if options.GraphNormalize==0
    L = spdiags(D,0,speye(size(W,1)))-W;
else % normalized laplacian
%     fprintf(1, 'Normalizing the Graph Laplacian\n');
    D(find(D))=sqrt(1./D(find(D)));
    D=spdiags(D,0,speye(size(W,1)));
    W=D*W*D;
    L=speye(size(W,1))-W;
end

% fprintf(1,['Graph Laplacian computation took ' num2str(toc) '  seconds.\n']);
