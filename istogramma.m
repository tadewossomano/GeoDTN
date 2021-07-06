function Y = istogramma(X,intervalli)
% Istogramma

%--------------------- HIST ---------------------
F_X = zeros(1,intervalli);
campioni=0;
for i=1:size(X)
    campioni=campioni+1;
    for j=1:intervalli
        if (((j-1)/intervalli)<=X(i)) && (X(i)<((j)/intervalli))
            F_X(j) = F_X(j)+1;
        end
    end
end
fattore=F_X(1)/4;
for k=1:intervalli
    F_X(k)=F_X(k)/fattore;      %(campioni/intervalli);
end

Y=F_X;