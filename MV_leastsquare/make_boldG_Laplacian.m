function [bG,L] = make_boldG_Laplacian(Kernel,params_mv,l,u,m,phase,Lapl)
% [bG,L] = make_boldG_Laplacian(Kernel,params_mv,l,u,m,phase,Lapl)
%   Given the Kernel matrix, this function creates the matrices useful for the
%   training and the testing, that are, \mathbf{G} and \mathbf{L}.
%
% Input:
% - Kernel: precoputed kernel matrix
% - params_mv: parameters of the multiview learning method
% - l: # labeled samples
% - u: # unlabeled samples
% - m: # of views
% - phase: 'training' or 'testing', building is slightly different (see the code)
% - Lapl (optional): the Laplacian can be built from the data directly.
%        Here we use the kernel, but we suggest to use the feature vectors.
%
% Output:
% - bG: \mathbf{G} matrix (see paper, Eq. 40-42) 
% - L: multiview Laplacian \mathbf{L} (see paper, Eq. 34-38)  
%

% Loris Bazzani, Minh Ha Quang


if strcmp(phase,'training') % training
    
    bG  = single(zeros(m*(l+u),m*(l+u)));    
    
else % testing
    t = size(Kernel,3);
    
    bG  = single(zeros(m*t,m*(l+u)));
end
L   = single(zeros(m*(l+u),m*(l+u)));


% build bG and L
for mi = 1:m
    idx_trn = mi:m:m*(l+u);
    
    if strcmp(phase,'training') % training
        
        bG(idx_trn,idx_trn) = single(Kernel(mi,:,:));
        
        if nargin<=7
            L(idx_trn,idx_trn)  = single(MYlaplacian(params_mv.Laplacian, squeeze(Kernel(mi,:,:))));
        else         % if you have your own laplacian
            L(idx_trn,idx_trn)  = single(Lapl(mi,:,:));
        end
        
    else % testing
        
        idx_tst = mi:m:m*t;
        
        bG(idx_tst,idx_trn) = single(squeeze(Kernel(mi,:,:)))';
    end
end
