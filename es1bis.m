TTOT=6000;            % totale simulation  time 
T = 1;                % duration of the slot
G = linspace(0.01,8); % vector containing the values ??of G attempted traffic that will be tested during the program
Ps= zeros(size(G));   % vector that will contain 'at the end of the values ??of throughput for the network slotted


p = 1;
for mu = G/T,

  now = 0;
  now_slot = 0;
  arr_slot = 0;
  suc_slot = 0;

  while 1,
    Y = (log(1-rand([1 1])))/((-1)*mu);  %extraction of v.a. with exponential distribution

    now_slot = now_slot + Y;
    now = now + Y;

    % we are at the end of the simulation?
    if now > TTOT,
      break;
    end;
  
    % we are in the next slot?
    if now_slot > T,
      if arr_slot == 1,
        suc_slot = suc_slot + 1;
      end;

      now_slot = mod(now, T);
      arr_slot = 0;
    end;

    arr_slot = arr_slot + 1;
  end;

  Ps(p) = suc_slot*T/TTOT;
  p = p + 1;
end;

% shows a graph of the measurements obtained
figure(1); clf;
H=axes;
hold on;

% experimental curve slotted-aloha
ls = plot(G, Ps);
set(ls,'Color',[0 0 1]);
set(ls,'LineWidth',2);
set(ls,'Marker','x');

% shows the theoretical curve for unlimited nodes
ls2 = plot(G, G.*exp(-G));
set(ls2,'Color',[0 0 1]);
set(ls2,'LineWidth',3);

grid on
ll=legend('Simulazione', 'Teoria');
set(ll, 'FontSize', 18);

xl=xlabel('Traf Tentato G');
yl=ylabel('Throughput Ps');

set(xl, 'FontSize', 14);
set(yl, 'FontSize', 14);
set(H, 'FontSize', 12);

