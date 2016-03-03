function [Y444 Cb444 Cr444]=MCS_420to444(Y420, Cb420, Cr420)



Y444=uint8(Y420);
Cb444=uint8(kron(double(Cb420),[1 1;1 1]));
Cr444=uint8(kron(double(Cr420),[1 1; 1 1]));
