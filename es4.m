m=20; % numero di stazioni

qa=0.01;
qr=0.2;
passi=100000;

% calcola matrice di transizione di stato
P=slalohamatrix(m,qa,qr);

% simula
tempo=passi/1000; conta=0; contb=0;
n=0;
seq=zeros([1 passi]);

for passo=1:passi,
  level=cumsum(P(n+1,:));
  n=sum(rand>level);
  seq(passo)=n;
  conta=conta+1;   if(conta==tempo) conta=0; contb=contb+1
  end;
end;

% calcola la statistica
for k=1:m+1,
  pk(k)=sum(seq==(k-1))/passi;
end;

% calcola il vettore analiticamente
[V, D] = eig(P');

% cerca l'autovettore per autovalore 1
[v, p] = min(abs(diag(D) - 1));

% calcola vettore stati staz
ps = abs(V(:,p) / sum(V(:,p)))';

% riporta in un grafico le due curve
figure(1); clf;
H=axes;
hold on;

% curva sperimentale
lk = plot(0:m, pk);
ls = plot(0:m, ps);
set(lk, 'Color', [ 0 0 1 ]);
set(lk, 'LineWidth', 2);
set(ls, 'Color', [ 0 1 0 ]);
set(ls, 'LineStyle', '--');
grid on
ll=legend('Prob Staz Sim', 'Prob Staz Teo');
set(ll, 'FontSize', 18);
xl=xlabel('Staz Backlogged');
yl=ylabel('Prob');
set(xl, 'FontSize', 14);
set(yl, 'FontSize', 14);
set(H, 'FontSize', 12);

