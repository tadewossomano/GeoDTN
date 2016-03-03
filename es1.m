% this program in Matlab simulates the behavior of a network Aloha in the presence of a number
% endless knots. Simulate a network before and after a slotted network with slotted
% same transmission parameters

% General parameters
T = 1;                % duration of the slot
N = 10000;            %number of slots to simulate
G = linspace(0.01,8); % vector containing the values ??of G attempted traffic that will be tested during the program
Ps= zeros(size(G));   % vector that will contain 'at the end of the values ??of throughput for the network slotted
Pu= zeros(size(G));   % vector that will contain 'at the end of the values ??of throughput for the network slotted
mu = G/T;             %average number of arrivals
% execution of the main loop to try all G: slotted case
for n=1:length(G), 
    T_tot = 0;        % total time simulated
    T_ut = 0;         % time (busy with trx successful) simulated
    
    % execution of the cycle of N transmissions
    for m=1:N,
        Y = (log(1-rand([1 1])))/((-1)*mu(n));  % extraction of v.a. with exponential distribution
        if Y > T,                               % if the arrival time slot following happens then the trx successful
            T_ut = T_ut + T;                    % then updates the time  
        end;
        T_tot = T_tot + Y;                      % updates, however, the total elapsed time
    end;
    Ps(n) = T_ut/T_tot;                         % stores the throughput obtained
end;

% execution of the main loop to try all G: If you do not slotted
for n=1:length(G),
    T_tot = 0;        % total time simulated
    T_ut = 0;         % time (busy with trx successful) simulated
    
    % execution of the cycle of N transmissions
    for m=1:N,
        Y = (log(1-rand([1 1])))/((-1)*mu(n));  % extraction of v.a. with exponential distribution
        if Y > 2*T,                             % if the time of arrival 'as to make the current transmission undisturbed for at least 2 * T then the trx successful
               T_ut = T_ut + T;                 % then updates the time
        end;
        T_tot = T_tot + Y;                      % updates, however, the total elapsed time
    end;
    Pu(n) = T_ut/T_tot;                         % stores the throughput obtained
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

% theoretical curve slotted-aloha
ls2 = plot(G, G.*exp(-G));
set(ls2,'Color',[0 0 1]);
set(ls2,'LineWidth',3);

% experimental curve is not slotted-aloha
lu = plot(G, Pu);
set(lu,'Color',[0 1 0]);
set(lu,'LineWidth',2);
set(lu,'Marker','x');

% theoretical curve is not slotted-aloha
lu2 = plot(G, G.*exp(-2*G));
set(lu2,'Color',[0 1 0]);
set(lu2,'LineWidth',3);

xl=xlabel('offered traffic G');
yl=ylabel('Throughput');
set(xl,'FontSize',28);
set(yl,'FontSize',28);
set(H,'FontSize',18);

t1=text(2.5,0.31,'Slotted-Aloha');  
set(t1,'FontSize', 24);
set(t1,'Color',[0 0 1]);    

t2=text(1,0.16,'Aloha');  
set(t2,'FontSize', 24);
set(t2,'Color',[0 1 0]);    


grid on


