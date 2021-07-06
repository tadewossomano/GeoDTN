% Definitions
DT = 2e-3; % duration of timeslot
R = 1e6; % link rate
PEB = 10e-6; % bit error probability
H = 28; % header length in byte
TTOT = 6000; % total simulation time
Nmax = floor( R*DT/8 - H ); % maximum bytes in the payload
% state variables
now = 0; % current time
suc = 0; % number of total success
att = 0; % number of timeslots (transmission attempts)
Txtotsucc = 0; % time spent for successful transmissions
Txtot = 0; % time spent for transmissions
% main loop
while 1,
 N = ceil(Nmax * rand(1,1)); % number of bytes in the payload
 POK = (1 - PEB)^(8 * (N + H)); 
 if rand(1,1) < POK
 suc = suc + 1; % this event has POK probability
 Txtotsucc = Txtotsucc + 8*(N+H)/R; % then refresh time spent for correct tx
 end;
 Txtot = Txtot + 8*(N+H)/R; % refresh the total transmission time (attempted)
 att = att + 1; % refresh number of attempts
 now = now + DT; % refresh current time
 if now > TTOT
 break; % ok we are done
 end
end
