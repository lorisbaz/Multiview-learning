Multiview-learning
==================
In this package, you find a updated version of the MATLAB code for following paper:

**A unifying framework for vector-valued manifold regularization and multi-view learning**, 
Minh, H. Q., Bazzani, L., and Murino, V., 
*In Proceedings of the 30th International Conference on Machine Learning (ICML-13) (pp. 100-108)*

Please, cite our paper if you use our code:
  ```
  @inproceedings{quang2013unifying,
    title={A unifying framework for vector-valued manifold regularization and multi-view learning},
    author={Minh, Ha Quang and Bazzani, Loris and Murino, Vittorio},
    booktitle={Proceedings of the 30th International Conference on Machine Learning (ICML-13)},
    pages={100--108},
    year={2013}
  }
  ```

##REPLICATE EXPERIMENTS
With the toolbox that can be used in combination with your data and kernels, we provide the demo code 
that replicates the experiment on the Caltech-101 dataset.
It is very simple:

1. download the kernels and metadata provided here (the 15-sample files): 
  http://www.robots.ox.ac.uk/~vgg/software/MKL/  
2. put the uncompressed folders in the folder named kernels 
3. open `DEMO_caltech101.m`
4. modify the TOOLBOXPATH and the KERNELPATH (if needed)
5. run the code


##USE THE CODE AS BLACKBOX
You can also use the code using your data with the following steps:

0. Load the toolbox and additional libs for the experiment
  ```
  TOOLBOXPATH = './';   % absolute path where the toolbox is located
  addpath([TOOLBOXPATH 'MV_leastsquare/']) % load the toolbox
  ```

1. Set PARAMETERS
  ```
  params_mv.gA =   % RKHS regularization
  params_mv.gB =   % between-view regularization
  params_mv.gW =   % within-view regularization
  params_mv.c  =   % vector to build the matrix C (length of the list of views)
  params_mv.Laplacian.GraphNormalize = % parameter to compute the laplacian
  ```

2. Load your data and compute the following quantities
	```
  l = % # labeled samples
  u = % # unlabeled samples
  m = % # of views
  P = % # of classes, i.e., length of the output vector
  K_trn  = % training kernel, size = (#views, #samplestrain, #samplestrain) -> labeled first, unlabeled at the end
  K_tst  = % testing kernel, size = (#views, #samplestrain, #samplestest) 
  Ytrain = % vector-value representation of the labels of the training samples (use labels2vec.m) % NOTE: it has to have zeros corresponding to the unlabeled samples
  YGT = % labels of the testing samples
  ```

3. Training
	```
  [bG_trn, L]  = make_boldG_Laplacian(K_trn,params_mv,l,u,m,'training');
  % [bG_trn, L]  = make_boldG_Laplacian(K_trn,params_mv,l,u,m,'training', Lapl); % in the case you have you Laplacian
  [At, C]  = MV_MC_leastsquare_training(bG_trn,L,Ytrain,params_mv,P,l,u,m);
	```

4. Testing
	```
  [bG_tst, ~] = make_boldG_Laplacian(K_tst,params_mv,l,u,m,'testing');
  [estimatedLabels, conf, Y_est] = MV_MC_leastsquare_testing(bG_tst,At,C,P,m);
  ```

5. Compute classification statistics
  ```
  [error_t, errorC] = performance_Y(Y_est,YGT);
  ```
