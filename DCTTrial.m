clear all
I=imread('lena.jpg');
f=rgb2gray(I);
figure;imshow(f);
f=imcrop(f,[1 1 511 511]);
%figure;imshow('f');title('original gray');
f_trim=double(f)-128;
mydct=dctmtx(8);
dct=@(block_struct)mydct*block_struct.data*mydct';
B=blockproc(f_trim,[8 8],dct);
figure;imshow(B);title('non_masked');


mask=[1 1 1 1 1 1 1 1
      1 1 1 1 1 1 1 1 
      1 1 1 1 1 1 1 0
      1 1 1 1 1 1 1 0
      1 1 1 1 1 1 0 0 
      1 1 1 1 1 0 0 0
      1 1 1 1 0 0 0 0
      1 1 1 0 0 0 0 0 ];

  anselmask=@(block_struct)block_struct.data*mask;
  Bmask=blockproc(B,[8 8],anselmask);
  figure;imshow(Bmask);title('masked');
%}
  inversedct=@(block_struct)mydct'*block_struct.data*mydct;
  reversed=blockproc(Bmask,[8 8],inversedct);
  Breversed1=uint8(reversed+128);
  figure;imshow(Breversed1);title('original');
  pause;
  
  