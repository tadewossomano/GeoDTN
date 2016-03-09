%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% AMIR 
%Binary Data Classification using Adaboost
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

a = [-50:50 ; ones(1,101)*50 ];
for i=-49:50
    b = [-50:50 ; ones(1,101)*i ];
    a = [a , b];
end


figure(1); 
clf %clear current figure window
axis(plotstyle.range); hold on
axis('square')
title('Left button = class +1, right button = class -1. Press any key to finish.')
i  = 0; clear X Y

[c,d]=size(a);
for i=1:d
    plot(a(1,i), a(2,i) );
end

