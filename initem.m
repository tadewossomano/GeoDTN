%!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!%
%                                                                 %
% Creator: Jia Li, September 2004                                 %
% For research purpose only.                                      %
%                                                                 %
%!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!%

%%-----------------------------------------------------------%%
%% Subroutine to initianize parameters for the EM algorithm --%
%% The input data X contains one sample on each row         --%
%%-----------------------------------------------------------%%

function [muinit, sigmainit, ainit]=initem(dim, numdata, numcmp, stopratio, X);
[cdbk1, dist1, cd1]=km(X, numcmp, stopratio);

ndatpercls=zeros(numcmp,1);
for i=1:numdata
ndatpercls(cd1(i))=ndatpercls(cd1(i))+1;
end;
ainit=ndatpercls/numdata;

muinit=zeros(dim, numcmp);
for i=1:numdata
muinit(:, cd1(i))=muinit(:,cd1(i))+X(i,:)';
end;

for j=1:numcmp
muinit(:,j)=muinit(:,j)/ndatpercls(j);
end;

sigmainit=zeros(dim,dim,numcmp);
for i=1:numdata
sigmainit(:,:,cd1(i))=sigmainit(:,:,cd1(i))+(X(i,:)'-muinit(:,cd1(i)))*(X(i,:)'-muinit(:,cd1(i)))';
end;

for j=1:numcmp
sigmainit(:,:,j)=sigmainit(:,:,j)/ndatpercls(j);
end;
