%!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!%
%                                                                 %
% Creator: Jia Li, September 2004                                 %
% For research purpose only.                                      %
%                                                                 %
%!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!%

%-------------------------------------------------------%
%- This subroutine estimates a gaussian mixture using  -%
%- EM and cluster data (both soft and hard) based on   -%
%- the mixture model.                                  -%
%- The input data X has every sample stored in a row   -%
%-------------------------------------------------------%
%-------------------------------------------------------%
% Output:                                               %
% mu: mean vectors of Gaussian components               %
% sigma: covariance matrices for Gaussian components    %
% a: prior probabilities of Gaussian components         %
% clsres: stores the identity of the most likely        %
%       cluster for each sample (hard classification)   %
% postp: stores the posterior probabilities of each     %
%        cluster for each sample. (soft classification) %
%-------------------------------------------------------%


function [mu, sigma, a, loglike, clsres, postp]=emcls(dim, numdata, numcmp, stopratio, X, muinit, sigmainit,ainit, cmcvflag);

%%% cmcvflag=1, assume common covariance matrix within one cluster

%------------------------------%
% Estimate                     %
%------------------------------%

X=X';
mu=muinit;
sigma=sigmainit;
a=ainit;

minloop=3;
maxloop=500;

oldloglike=-1.0e+30;
loop=1;
while (loop<maxloop)

%%%% Compute the posterior probabilities 
for j=1:numcmp
sigmainv(:,:,j)=inv(sigma(:,:,j));
sigmadetsqrt(j)=sqrt(det(sigma(:,:,j)));
end;

pij=zeros(numdata, numcmp);
loglike=0.0;
for i=1:numdata
tmp=0.0;
for j=1:numcmp
pij(i,j)=a(j)/sigmadetsqrt(j)*exp(-0.5*(X(:,i)-mu(:,j))'*sigmainv(:,:,j)*(X(:,i)-mu(:,j)));
tmp=tmp+pij(i,j);
end %% j=1:numcmp
for j=1:numcmp
pij(i,j)=pij(i,j)/tmp;
end %% j=1:numcmp

loglike=loglike+log(tmp)-dim/2*log(2*pi);
end %% i=1:numdata

if (abs((loglike-oldloglike)/oldloglike) < stopratio & loop>minloop)
break;
end;

if (loglike<oldloglike)
loglike
oldloglike
break;
end;

oldloglike=loglike;

%%%%% Start maximization step 

%%%% Optimize a
pj=sum(pij);
a=pj'/sum(pj);

%%% Optimize mu
mu=X*pij;
for j=1:numcmp
mu(:,j)=mu(:,j)/pj(j);
end;

%%%% Optimize sigma
for j=1:numcmp
Phi=zeros(dim,dim);
for i=1:numdata
Phi=Phi+pij(i,j)*(X(:,i)-mu(:,j))*(X(:,i)-mu(:,j))';
end;
sigma(:,:,j)=Phi/sum(pij(:,j));
end %%% j=1:numcmp


%%% If covariance matrix restricted to be common
if (cmcvflag==1)
Phi=zeros(dim,dim);
tmp=0.0;

for j=1:numcmp
Phi=Phi+sigma(:,:,j)*sum(pij(:,j));
tmp=tmp+sum(pij(:,j));
end %% j

for j=1:numcmp
if (c(j)==jj)
sigma(:,:,j)=Phi/tmp;
end %% if (c(j)==jj)
end %% j

end  %%% if (cmcdflag==1)


%loop 
%loglike

loop=loop+1;

end %%% while (loop<maxloop)

%------------------------------%
% Clustering                   %
%------------------------------%

for j=1:numcmp
sigmainv(:,:,j)=inv(sigma(:,:,j));
sigmadetsqrt(j)=sqrt(det(sigma(:,:,j)));
end;

pij=zeros(numdata, numcmp);
for i=1:numdata
tmp=0.0;
for j=1:numcmp
pij(i,j)=a(j)/sigmadetsqrt(j)*exp(-0.5*(X(:,i)-mu(:,j))'*sigmainv(:,:,j)*(X(:,i)-mu(:,j)));
tmp=tmp+pij(i,j);
end %% j=1:numcmp
for j=1:numcmp
pij(i,j)=pij(i,j)/tmp;
end %% j=1:numcmp
end %% i=1:numdata

postp=pij;
for i=1:numdata
[v,clsres(i)]=max(postp(i,:));
end;
