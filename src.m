% 20/11/2012

clear all;close all;

%% --------------------- Exercise 1 ---------------------

T=0.01;
G=(0+0.1):0.1:4;        %avoid G=0

T_suc = 0;
T_tot = 0;

N=20000;

mu=G/T;

thro=zeros(size(G));

for j=1:length(G)
    T_suc=0;
    T_tot=0;
    for k=1:N,
        y = -log(1-rand([1 1]))/mu(j);
        if y > 2*T
            T_suc=T_suc+T;
        end;
        T_tot=T_tot+y;
    end;
    thro(j)=T_suc/T_tot;
end

figure;
plot(G,thro,'b');
hold on;
plot(G,exp(-2*G).*G,'r');

pause; close all;

%% --------------------- Exercise 2 ---------------------

A = [-3 -6; 4 7];

[V,D]=eig(A);
[V_2,D_2]=eig(A,'nobalance');       %V_2 = V sono gli stessi autovettori


%% --------------------- Exercise 3 ---------------------
clear all;

P = [0.2 0.1 0.7;0.1 0.1 0.8;0.3 0.2 0.5];

[Vp,Dp] = eig(P');

indice = find(abs(diag(Dp)-1)==min(min(abs(diag(Dp)-1))));

p = Vp(:,indice)';
p = p/(sum(p));

%p*P

S=[1,2,3];

stato=1;
N_steps=100000;

STATI(1)=1;

for step=2:N_steps;
    y=rand([1 1]);
    if y<P(stato,1)
        stato=1;
    elseif P(stato,1)<=y & y<(P(stato,1)+P(stato,2))
        stato=2;
    else 
        stato=3;
    end
    STATI(step)=stato;
end

isto=hist(STATI,3);
isto=isto/N_steps;

%% --------------------- Exercise 4 ---------------------
clear all;

m=25;
qa=0.01;
qr=0.2;

M=slalohamatrix(m,qa,qr);

[Vp,Dp] = eig(M');

indice = find(abs(diag(Dp)-1)==min(min(abs(diag(Dp)-1))));

p = Vp(:,indice)';
p = p/(sum(p));

N_steps=100000;
STATI=zeros(1,N_steps);
STATI(1)=0;

for i=2:N_steps
    STATI(i)=(sum(rand(1)>cumsum(p)))+1;
end

isto=hist(STATI,m);
isto=isto/N_steps;
bar(isto,'DisplayName','isto');figure(gcf);
hold on;
plot(p,'r');











