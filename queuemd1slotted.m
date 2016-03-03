R=10e6;                      % channel rate
L=512;                       % UDP payload length
TARR=500e-6;                 % average interarrival time
TTOT=10000;                   % total simulation time
IFG=9.6e-6;                  % interframe gap
mu = 1/TARR;                 % average arrival number over time unit

Lip = L + 28;                % UDP data + 8(UDP header) + 20(IP header)
Leth = Lip + 26;             % IP length + 14(eth) + 4(fcs) + 8(trailer)
TTR = 8 * Leth / R + IFG;    % transmission time

Q = 20;                      % maximum number of packets in queue

queue = 0;                   % packets in queue (state)
now = 0;                     % current time during sim
slotend = 0;                 % end of current slot

testpoisson = zeros([20 1]); % vector for testing poisson
testcoda = zeros([Q+1 1]);   % vector for storing queue state

queuetot = 0;                % cumulative queue length
queuenum = 0;                % number of queue snapshots collected

while ( 1 ),
    if now > TTOT,           % check if simulation finished
        break;
    end;

    slotend = slotend + TTR; % end of current slot

    N = 0;                   % count how many arrivals in this slot
    while ( 1 ),
        if now > slotend,    % check if done
            break;
        end;

        N = N + 1;           % still in the current slot, count
                             % this arrival

        % extract new arrival
        delta = -log( 1 - rand() ) / mu;
        now = now + delta;
    end;

    queue = queue + N;       % refresh queue state
    if queue > Q, 
        queue = Q;
    end;

    % refresh statistics
    queuetot = queuetot + queue;
    queuenum = queuenum + 1;

    testcoda(queue + 1) = testcoda(queue + 1) + 1;

    % drop one packet if available
    if queue > 0,
        queue = queue - 1;
    end;
    
end;

testcoda = testcoda / sum(testcoda);
testpoisson = testpoisson / sum(testpoisson);
queuetot / queuenum

% now compute the same result with the analytical model
muTTR = mu * TTR;
expmuTTR = exp(-muTTR);
M = 0:Q;
pM = (muTTR).^M.*expmuTTR./factorial(M);

% allocate and fill the matrix
A = zeros([Q+1 Q+1]);
for l = M,
  riga = l + 1;
  if riga == 1,
    A(riga,:) = pM;
  else,
    A(riga,(riga-1:Q+1)) = pM(1:(Q-riga+3));
  end;
end;

% correct the last column
A(:,Q+1) = (1-sum(A(:,1:Q)'));

% now determine which eigen vector has eigen value 1
[V, D] = eig(A');
[v, p] = min(abs(diag(D) - 1));

% compute steady state distribution
ps = abs(V(:,p) / sum(V(:,p)))';