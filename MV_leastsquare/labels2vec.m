function Yvec = labels2vec(labels,P)


Yvec = -ones(P,length(labels));
for i = 1:P
    Yvec(i,labels==i)   = 1;
end