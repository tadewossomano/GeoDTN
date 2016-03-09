
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% Binary Data Classification using Adaboost
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
disp('freund');

for a=1:9
    
    e=a*0.1;
    B = (1-e)/e;
    A = 0.5*log(B);
    Eo = exp(-A);
    Ex = exp(A);
    
    disp( sprintf('Et = %f , (1-et)/et = %f , 1/2*ln((1-et)/et) = %f , E^-a = %f , E^+a = %f', e,B,A,Eo,Ex));
end

disp('-------------------');

for a=1:9
    
    e=a*0.1;
    B = e/(1-e);
    
    Eo = B^(1-0);
    Ex = B^(1-1);
    
    A = log(1/B);
    
    disp( sprintf('Et = %f , et/(1-et) = %f , O-Weak = %f , X-Weak = %f , Alpha  = %f', e, B, Eo, Ex, A));
end
e=0.55;
    B = e/(1-e);
    
    Eo = B^(1-0);
    Ex = B^(1-1);
    
    A = log(1/B);
    
    disp( sprintf('Et = %f , et/(1-et) = %f , O-Weak = %f , X-Weak = %f , Alpha  = %f', e, B, Eo, Ex, A));
