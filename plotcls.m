%!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!%
%                                                                 %
% Creator: Jia Li, September 2004                                 %
% For research purpose only.                                      %
%                                                                 %
%!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!%

%%------------------------------------------------------%%
%%- This is a subroutine to plot clustering results     %%
%%- Data points in different clusters are plotted with  %%
%%- different symbols and colors.                       %%
%%- X is the original data with each row correpsonding  %%
%%- to a sample.  cord denotes which two dimensions     %%
%%- need to be plotted versus each other.  ind records  %%
%%- the cluster identities of all the samples           %%
%%------------------------------------------------------%%

function plotcls(X, numcmp, cord, ind);

[numdata,dim]=size(X);
str=['o','s','^','v','<', '*', '>', 'p','d','h','+','x'];
strcolor=['r','b','g','m','c','k','y','r','b','g','m','c','k','y'];

for i=1:numcmp
k=1;
if (i>1) 
clear a;
end;
for j=1:numdata
if (ind(j)==i)
     a(k,:)=X(j,cord);
     k=k+1;
end;
end; % for j=1:numdata

symbol=strcat(strcolor(i),str(i));
plot(a(:,1), a(:,2), symbol);
hold on;
end; %% i=1:numcmp

hold off;
grid;
