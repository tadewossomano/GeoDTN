 %mu=0.25;
mu=4;
T=2;

N=250000;

t=0;
arrivi = 0;
dm=zeros([1 20]);

for k=1:N,
	y = log(1-rand([1 1]))/-mu;
	t = t + y;
	if t > T,
		% clip
		if arrivi > length(dm) - 1,
			arrivi = length(dm) - 1;
		end;
		dm(arrivi + 1) = dm(arrivi + 1) + 1;
		t = 0;
		arrivi = 0;
    else
		arrivi = arrivi + 1;
	end;
end;

figure(1); clf; hold on;
G=mu*T;
arrivi = (0:(length(dm)-1));
dmt = exp(-G) * G.^(arrivi) ./ factorial(arrivi);
dm = dm / sum(dm);
l1 = plot(arrivi, dmt);
l2 = plot(arrivi, dm, 'r--');
grid on;
set(l1, 'LineWidth', 2);
set(l2, 'LineWidth', 2);
xl = xlabel('Number of arrivals');
set(xl, 'FontSize', 14);
yl = ylabel('Probability');
set(yl, 'FontSize', 14);
lg = legend('Theory', 'Simulation');
set(lg, 'FontSize', 16);
