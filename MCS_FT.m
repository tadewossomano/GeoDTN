% LAB 2

% fourier(f, x, y);

function [X] = MCS_FT (x,t,f)

A = zeros(length(f),length(t));
for h=1:length(f)
    for k=1:length(t)
        A(h,k)=exp(-1i*2*pi*f(h)*t(k));
    end
end

X = zeros(1,length(f));
X = A * x';

return;

