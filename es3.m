%% 
%Quick exercise
A=[-3 -6 ;4 7];
[V,D] = eig(A);

keyboard



%%
% markov matrix
P = [0.2 0.1 0.7; 0.1 0.1 0.8; 0.3 0.2 0.5];

% find steady state probabilities
% it's a eigen vector problem
[V, D] = eig(P');

% now determine which eigen vector has eigen value 1
[v, p] = min(abs(diag(D) - 1));

% compute steady state distribution
ps = abs(V(:,p) / sum(V(:,p)))';

% now simulate state variation for 100000 steps
% start in state 1
steps = 100000;
states = zeros([1 steps]);
state = 1;

for step = 1:steps,
  prob = P(state,:);
  state = sum(rand([1 1]) > cumsum(prob)) + 1;
  states(step) = state;
end;

% compute state distribution
ps_estimated = zeros([1 size(P,1)]);

for state = 1:size(P,1),
  ps_estimated(state) = sum(states == state)/steps;
end;
