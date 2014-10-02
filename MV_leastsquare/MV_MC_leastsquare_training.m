function [At,C] = MV_MC_leastsquare_training(bG_trn,L,Ytrain,params_mv,P,l,u,m)
% [At,C] = MV_MC_leastsquare_training(bG_trn,L,Ytrain,params_mv,P,l,u,m)
%  Multiview multiclass learning method that is based on least square loss
%  function.
%
% Input:
% - bG_trn: \mathbf{G} matrix (see paper, Eq. 40-42) 
% - L: multiview Laplacian \mathbf{L} (see paper, Eq. 34-38)  
% - Ytrain: Vector representation of the labels (zeros for unlabeled data)
% - params_mv: parameters of the multiview learning method
% - P: # of classes
% - l: # labeled samples
% - u: # unlabeled samples
% - m: # of views
%
% Output:
% - At: solution of the learning problem (see paper, eq. 43-44)
% - C: Combination operator
%

% Loris Bazzani, Minh Ha Quang


fprintf('Training ')
tic;

Ck  = single(eye(P));
C = kron(single(params_mv.c'), Ck); % Minh

%% Mm square matrix of size (m,m)
Mm = single(m*eye(m) - ones(m));

%% J: diagonal matrix with l entries at 1 and u entries at 0 (ordered in
% accordance to Y)
J = diag(abs(single(Ytrain(1,:))));

%% eq 22
% tic, fprintf('Computing B matrix... '),
B = (kron(J, single(params_mv.c*params_mv.c')) + l*params_mv.gB*(kron(eye(u+l,'single'),Mm))+l*params_mv.gW*L)*bG_trn ...
    + l*params_mv.gA*eye((u+l)*m,'single'); % Minh


Yct = reshape(C'*single(Ytrain), P, (u+l)*m);
Yc = Yct';

% tic, fprintf('Solving for A... '),
A = B \ Yc;
At = A';
% toc,

tm = toc;
fprintf('time %3.2f s ',tm);