function [Y444 Cb444 Cr444]=MCS_422to444(Y422, Cb422, Cr422)



Y444=uint8(Y422);
Cb444=uint8(kron(double(Cb422),[1 1]));
Cr444=uint8(kron(double(Cr422),[1 1]));
