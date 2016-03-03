function [Out1, Cb, Cr]=CMR_rgb2ycbcr(I,G,B)
%CMR_rgb2ycbcr Converts from RGB to YCbCr
% [YCbCr]=CMR_rgb2ycbcr(I) outputs the 3D structure with the YCbCr
% components
% [Y,Cb,Cr]=CMR_rgb2ycbcr(I) outputs the three separate components 



% *******************
% Simple method
% *******************
% if there is only one input, this will contain the three components;
% otherwise, the R, G and B are the three inputs
% nargin is an internal variable that says how many inputs are passed to
% the function

if nargin == 1
    I=double(I);
    R=I(:,:,1); 
    G=I(:,:,2);
    B=I(:,:,3);
elseif nargout==3
    R=double(I);
    G=double(G);
    B=double(B);
else
      error('Invalid number of intput variables');
end

Y=uint8(0.299*R+0.587*G+0.114*B);
Cb=uint8( -0.169*R-0.331*G+0.500*B+128);
Cr=uint8(  0.500*R-0.419*G-0.081*B+128); 

% if called as YCbCr=... outputs the 3D structure
% if called as [Y, Cb, Cr]=... outputs the three components
% nargout is an internal variables which says how many output are requested
if nargout == 1
     Out1=cat(3,Y,Cb,Cr);
elseif nargout==3
     Out1=Y;
else
      error('Invalid number of output variables');
end
% *******************



% % *******************
% % Less simple method
% % *******************
% % For those who want to use the matrix product for color transformation.
% % Only shown as an excuse to show some tricks, it is not really needed
% % here
% % 
% % 
% % Study the single commands to learn how to use them yourself
% %
% MatRGB=reshape(I,[length(I(:))/3,3]);
% MatRGB=MatRGB';
% T=[0.299, 0.587, 0.114;
%     -0.169,-0.331,0.500;
%      0.500,-0.419,-0.081]; 
% MatYCbCr=uint8(T*MatRGB+repmat([0, 128, 128]', [1,size(MatRGB,2)]));
% YCbCr=reshape(MatYCbCr',size(I));
% 
% if nargout == 1
%      Out1=YCbCr;
% elseif nargout==3
%      Out1=YCbCr(:,:,1);
%      Cb=YCbCr(:,:,2);
%      Cr=YCbCr(:,:,3);
% else
%       error('Invalid number of output variables');
% end
% 
% % *******************

