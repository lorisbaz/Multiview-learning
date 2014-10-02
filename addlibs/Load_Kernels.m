paper = 'caltech101'; 

fprintf('* Loading Kernel Matrices...')
tic;

switch paper
    
    case 'caltech101'
       splitlist = dir([KERNELPATH 'kernels/cal101-ker*']);
       nRUNS = length(splitlist); % number of splits

       metalist = dir([KERNELPATH 'kernels/cal101-meta/*.mat']);
       P = 102;
       
       Y = struct([]);
       
       for s = 1:nRUNS
           % load the pre-computed kernels (Vedaldi's MKL paper)
           kernlist = dir([KERNELPATH 'kernels/' splitlist(s).name '/*.mat']);
           nKern = length(kernlist)/2;
           parfor k = 1:nKern  % training
               kernpath = [KERNELPATH 'kernels/' splitlist(s).name '/' kernlist(k).name];
               Kernels_trn{s,k} = load(kernpath);
               Kernels_trn{s,k}.path = kernpath;
           end
           parfor k = 1:nKern  % testing
               kernpath = [KERNELPATH 'kernels/' splitlist(s).name '/' kernlist(nKern + k).name];
               Kernels_tst{s,k} =  load(kernpath);
               Kernels_tst{s,k}.path = kernpath;
           end
           
           % load metadata
           metadt(s) = load([KERNELPATH 'kernels/cal101-meta/' metalist(s).name]);
           
           % Make the Y labels
           Y(s).train = labels2vec(metadt(s).trainImageClasses,P);
           Y(s).test  = labels2vec(metadt(s).testImageClasses,P);
           
%            Y(s).train = -ones(P,length(metadt(s).trainImageClasses));
%            Y(s).test  = -ones(P,length(metadt(s).testImageClasses));
%            for i = 1:P
%                Y(s).train(i,metadt(s).trainImageClasses==i)   = 1;
%                Y(s).test(i,metadt(s).testImageClasses==i)     = 1;
%            end
       end
       
       nSamples = length(metadt(1).trainImageClasses);
       nSperClass = nSamples/P;
       l = labdata*P*2; % twice because of the trasformed data
       u = uc*P*2;
       t = length(metadt(1).testImageClasses);
       m = length(viewlist); % 4 views = 4 features

       % extract the classes name (optional for visualization)
       c = 1;
       className = cell(P,1);
       for i = 1:length(metadt(1).trainImageNames)/2
           idxcut = strfind(metadt(1).trainImageNames(i),'image');
           idxcut = idxcut{1} - 2; % avoid the "_" char
           if i == 1
               className{c} = metadt(1).trainImageNames{i}(1:idxcut);
               aa = strfind(className{c},'_');
               className{c}(aa) = ' ';
               c = c + 1;
           else
               TMP = metadt(1).trainImageNames{i}(1:idxcut);
               aa = strfind(TMP,'_');
               TMP(aa) = ' ';
               if ~strcmp(TMP,className{c-1})
                   className{c} = TMP;
                   c = c + 1;
               end
           end
           
       end
       

    otherwise
        error(['Unrecognized experiment [number/feature/type] ' datasetN]);
end


tm = toc;
fprintf(' Done, time %3.2f s\n',tm)
