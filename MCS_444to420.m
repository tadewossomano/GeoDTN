function [Y420 Cb420 Cr420]=MCS_444to420(Y444, Cb444, Cr444)

h=[0.5 0.5];

Y420=Y444;

CbF=uint8(conv2(double(Cb444),h));
CrF=uint8(conv2(double(Cr444),h));
% We subsample, starting from the second sample because the first has been
% added y the filter
Cb420=CbF(2:2:end,2:2:end);
Cr420=CrF(2:2:end,2:2:end);