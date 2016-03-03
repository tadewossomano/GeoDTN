function [Y422 Cb422 Cr422]=MCS_444to422(Y444, Cb444, Cr444)

h=[0.5 0.5];

Y422=Y444;

CbF=uint8(conv2(double(Cb444),h));
CrF=uint8(conv2(double(Cr444),h));
% We subsample, starting from the second sample because the first has been
% added y the filter
Cb422=CbF(:,2:2:end);
Cr422=CrF(:,2:2:end);