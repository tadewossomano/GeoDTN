%%Exercise 5: Simulation slotted aloha protocol (second method)
% written by Tadewos Somano in the academic year 2013/2014

m=25;		% number of stations
N=2000000;	% number of steps
Ntot=2000;      % displays something every 1000 steps

% coefficients for the simulation (new arrivals and retransmissions)
qa=0.01;
qr=0.2;

% vectors to store and trx successful attempts as a function of the state
P=zeros(1,m+1);
G=zeros(1,m+1);

% been backlogged stations
bklgd=zeros(1,m);

%stores the number of backlogged stat for each step
B=zeros(N,1);

% simulation cycle
for i=1:1:N

    % number of backlogged nodes at the beginning of this cycle
    nold=sum(bklgd);

    % extraction transmissions / retransmissions
    trasmetto=zeros(1,m);
    for j=1:1:m
        r=rand;
        if((bklgd(1,j)==0 && r<qa) || (bklgd(1,j)==1 && r<qr))
            trasmetto(1,j)=1;
        end;
    end;

    % attempts to update trx
    Glast=sum(trasmetto);

    % Update trx successful
    if(Glast==1)
        Plast=1;
        bklgd=bklgd.*(1-trasmetto);
    else
        Plast=0;
        bklgd=bklgd|trasmetto;
    end;

    % storage was
    P(1,nold+1)=P(1,nold+1)+Plast;
    G(1,nold+1)=G(1,nold+1)+Glast;

    % stores how many stations were backlogged at the beginning of this cycle
    B(i,1)=nold;

    % Check if you must see
    if(mod(i, Ntot) == 0),
      i;
    end;
end;

% and calculates how many times you 'found in every state
for stato=1:m+1,
  pkbl(stato)=sum(B==(stato-1));
end;

% calculates normalized vectors P and G
Gn=G./pkbl;
Pn=P./pkbl;

% calculates the theoretical curve
for n=0:m,
  Ps(n+1)=(m-n)*(1-qa)^(m-n-1)*qa*(1-qr)^n+(1-qa)^(m-n)*n*(1-qr)^(n-1)*qr;
  Gs(n+1)=(m-n)*qa+n*qr;
end;

% plotta curve
figure(1); clf;
H=axes;
hold on;

% curva teorica
ls = plot(Gs, Ps);
set(ls, 'Color', [0 0 1]);
set(ls, 'LineWidth', 2);

% curva sperimentale
ln = plot(Gn, Pn);
set(ln, 'Color', [0 1 0]);
set(ln, 'LineWidth', 2);
set(ln, 'LineStyle', '.');
set(ln, 'Marker', 'x');
set(ln, 'MarkerSize', 12);
grid on
ll=legend('Curva teorica', 'Curva sperimentale');
set(ll, 'FontSize', 18);
xl=xlabel('G');  
set(xl, 'FontSize', 14);
yl=ylabel('Throughput');
set(yl, 'FontSize', 14);
set(H, 'FontSize', 12)
