%Traffic Modeling and Streaming.
%Ewalo Tadewos Somano
%Test 1: required time 30 minutes.
%Using MATLAB command rand simulate and compute 10000 values of the r.v. with alphabet {4,9} and
%probabilities P[A=4]=0.3 and P[A=9]=0.7. Store such values into vector V.
 M = 10;   %number of experiment 
 N = 100;  %Number of trials per experiment =>10X100 matrix =>100 column
p = 0.3;  %Probability of A=4 =>0.7=1-p Probability A=9
B = rand(M,N) < p ; % Produce random binomial distribution based on above
indices=find(B,1000);
averageNumberofOnes=length(indices);
%%
%{
    u = rand;
if (u < 2/10),
outcome = 1;
elseif (u < 6/10),
outcome = 5;
else
outcome = 4;
end
%}
N=1000;
p = [1/5, 2/5, 2/5,];
P = cumsum(p);
u = rand;
%outcome = min(find(u<P));
outcome=mysim(p,N);
if(u<1/5)
    outcome=1;
elseif(u<2/5)
    outcome=5;
else
    outcome=8;
end
%%
n=100000;
 x=2*rand(n,1);
 y=x.^2 + x;
                                 %%estimate = mean(y);
%%
x = (0:10000);
y=unidcdf(x,6);
stairs(x,y);
%%
N=10000;
m=4;%mean
s=1 ;%standard deviation
D=m+s.*randn(1,N);
x=[0:0.001:10];
y=hist(D,x);
bar(x,y,1.4);
xlabel('Value','fontsize',18);
ylabel('Occurrence','fontsize',18);