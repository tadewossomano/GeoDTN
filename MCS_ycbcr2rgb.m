function [Out1, G, B]=MCS_ycbcr2rgb(I, Cb, Cr)



if nargin == 1
    I=double(I);
    Y=I(:,:,1); 
    Cbn=I(:,:,2)-128;
    Crn=I(:,:,3)-128;
elseif nargout==3
    Y=double(Y);
    Cbn=double(Cb)-128;
    Crn=double(Cr)-128;
else
      error('Invalid number of intput variables');
end


R=uint8(Y+1.4025*Crn);
G=uint8(Y-0.344*Cbn -0.7142*Crn);
B=uint8(Y+ 1.773*Cbn);


if nargout == 1
     Out1=cat(3,R,G,B);
elseif nargout==3
     Out1=R;
else
      error('Invalid number of output variables');
end
