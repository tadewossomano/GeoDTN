% LAB 4

function [S] = MCS_FT2 (s, u, v, x, y)

S1 = MCS_FT (s,x,u);

B = zeros(length(y),length(v));

for n=1:length(y)
    for k=1:length(v)
        B(n,k)=exp(-1i*2*pi*y(n)*v(k));
    end
end

S = S1 * B;

return;

