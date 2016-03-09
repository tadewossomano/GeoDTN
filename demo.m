%!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!%
%                                                                 %
% Creator: Jia Li, September 2004                                 %
% For research purpose only.                                      %
%                                                                 %
%-----------------------------------------------------------------%
%                                                                 %
% Function: This is a demo program that shows how to cluster      %
% data using several wellknow algorithms: kmeans, mixture model   %
% based clustering using CEM and EM estimation methods.           %
%                                                                 %
%!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!%

%%--------------------------------------------------%%
%% This is a demo program for clustering data       %%
%% using different clustering methods               %%
%%--------------------------------------------------%%

%% Generate random data

rand('state', 0);

dim=2;
numdata=600;
X=randn(numdata,dim);

for i=numdata/2:numdata
X(i,:)=X(i,:)+[3,3];
end;

%%% plot the data for viewing 
plot(X(:,1),X(:,2),'*');

numcmp=7;  %% number of clusters

%%----- Cluster by Kmeans -----

thred=1.0e-4;
%% indkm stores the clustering result
[cdbk,distlist, indkm]=km(X,numcmp,thred);


%%----- Cluster by CEM and EM -------

%% initialization

stopratio=1.0e-4;
[muinit, sigmainit, ainit]=initem(dim, numdata, numcmp, stopratio, X);

%----- CEM -----
stopratio=1.0e-5;
%% indcem stores the clustering result
%% postp_cem stores the posterior probilities of each cluster

[mu1,sigma1,a1,indcem, postp_cem]=cemcls(X,numdata,numcmp,dim,muinit,sigmainit,ainit,stopratio);


%----- EM ------
stopratio=1.0e-5;
%% indem stores the clustering result
%% postp_em stores the posterior probilities of each cluster
[mu2, sigma2, a2, loglike, indem, postp_em]=emcls(dim, numdata, numcmp, stopratio, X, muinit, sigmainit, ainit, 0);

cord=[1,2];
figure(1);
plotcls(X,numcmp, cord, indkm);
title('Clustering based on Kmeans');

figure(2);
plotcls(X,numcmp, cord, indcem);
title('Clustering based on CEM');

figure(3);
plotcls(X,numcmp, cord, indem);
title('Clustering based on EM');
