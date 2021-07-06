% Implements JPEG2000 wavelet transform-based compression.
% Implements only the scalar quantization normative of the
% standard. Implements up to NL levels of 2D DWT using
% Daubechies’ 9/7 filter bank.
% Implements 4:2:0 and 4:2:2 sampling formats specified
%292 IMAGE COMPRESSION IN THE WAVELET DOMAIN
% by the user.
% Uses the frequency weightings recommended by JPEG2000 standard
% in the uniform scalar quantization of the DWT coefficients.
%
clear
NL = 3; % number of levels of 2D DWT
SamplingFormat = ’4:2:2’;
%A = imread(’cameraman.tif’);
A = imread(’lighthouse.ras’);
% make sure that the image size is divisible by NL
[X,Y,Z] = size(A);
if mod(X,2ˆNL) ?=0
Height = floor(X/(2ˆNL))*(2ˆNL);
else
Height = X;
end
if mod(Y,2ˆNL) ?=0
Width = floor(Y/(2ˆNL))*(2ˆNL);
else
Width = Y;
end
Depth = Z;
clear X Y Z
% Do forward Irreversible Component Transformation (ICT)
% In JPEG2000 jargon, y0 corresponds to the Luma Y,
% y1 to Cb and y2 to Cr.
if Depth == 1
y0 = double(A(1:Height,1:Width)) - 128; % DC level shift
else
A1 = double(A(1:Height,1:Width,:))-128; % DC level shift
y0 = 0.299*A1(:,:,1) + 0.587*A1(:,:,2) + 0.144*A1(:,:,3);
y1 = -0.16875*A1(:,:,1) - 0.33126*A1(:,:,2) + 0.5*A1(:,:,3);
y2 = 0.5*A1(:,:,1) - 0.41869*A1(:,:,2) - 0.08131*A1(:,:,3);
clear A1
switch SamplingFormat
case ’4:2:0’
y1 = imresize(y1,[Height/2 Width/2],’cubic’);
y2 = imresize(y2,[Height/2 Width/2],’cubic’);
case ’4:2:2’
y1 = imresize(y1,[Height Width/2],’cubic’);
y2 = imresize(y2,[Height Width/2],’cubic’);
end
end
% Daubechies 9/7 Filters
% Note: The Daubechies 9/7 filter bank has 9 taps for its analysis
% Lowpass and synthesis highpass FIR filters;
% 7 taps for its analysis highpass and synthesis lowpass
% FIR filters. However, in order to obtain subbands that are
% exact multiples of 2ˆ-n, n being a positive integer, the
% number of taps in the filters must be even. That is why you
% will notice the filter lengths to be 10 instead of 9 or 7.
%8.4 JPEG2000 293
% The extra tap values are zero.
%
% LO D = analysis lowpass filter
% LO R = synthesis lowpass filter
% HI D = analysis highpass filter
% HI R = synthesis highpass filter
LO D = [0 0.0267487574 -0.0168641184 -0.0782232665 0.2668641184...
0.6029490182 0.2668641184 -0.0782232665 -0.0168641184...
0.0267487574];
HI D = [0 0.0912717631 -0.0575435263 -0.5912717631...
1.1150870525 -0.5912717631 -0.0575435263 0.0912717631 0 0];
%
LO R = [0 -0.0912717631 -0.0575435263 0.5912717631...
1.1150870525 0.5912717631 -0.0575435263 -0.0912717631 0 0];
HI R = [0 0.0267487574 0.0168641184 -0.0782232665 -0.2668641184...
0.6029490182 -0.2668641184 -0.0782232665 0.0168641184...
0.0267487574];
%
% "dwt Coef" cell array has NL x 4 cells.
% In each cell at level NL, the 1st component is the LL
% coefficients,
% 2nd component is HL coefficients, 3rd component LH and
% 4th component HH coefficients.
%
% Do an NL-level 2D DWT of the Y component
dwt y0 = cell(NL,4);
for n = 1:NL
if n == 1
[dwt y0{n,1},dwt y0{n,2},dwt y0{n,3},dwt y0{n,4}] =...
dwt2(y0,LO D,HI D,’mode’,’per’);
else
[dwt y0{n,1},dwt y0{n,2},dwt y0{n,3},dwt y0{n,4}] =...
dwt2(dwt y0{n-1,1},LO D,HI D,’mode’,’per’);
end
end
% Quantize the Y DWT coefficients
[dwt y0,y0Bits] = jpg2K Quantize(dwt y0,NL,1);
%
% Do an NL-level 2D IDWT of the Y component
% The cell array idwt img has NL cells with each cell
% corresponding to
% the reconstructed LL image at that level.
idwt y0 = cell(NL,1);
for n = NL:-1:1
if n == 3
idwt y0{n} = idwt2(dwt y0{n,1},dwt y0{n,2},dwt y0{n,3},...
dwt y0{n,4},LO R,HI R,’mode’,’per’);
else
idwt y0{n} = idwt2(idwt y0{n+1},dwt y0{n,2},dwt y0{n,3},...
dwt y0{n,4},LO R,HI R,’mode’,’per’);
end
%294 IMAGE COMPRESSION IN THE WAVELET DOMAIN
end
SNRy0 = 20*log10(std2(y0)/std2(y0-idwt y0{1}));
if Depth > 1
% Do an NL-level 2D DWT of the Cb and Cr components
dwt y1 = cell(NL,4);
dwt y2 = cell(NL,4);
for n = 1:NL
if n == 1
[dwt y1{n,1},dwt y1{n,2},dwt y1{n,3},dwt y1{n,4}] =...
dwt2(y1,LO D,HI D,’mode’,’per’);
[dwt y2{n,1},dwt y2{n,2},dwt y2{n,3},dwt y2{n,4}] =...
dwt2(y2,LO D,HI D,’mode’,’per’);
else
[dwt y1{n,1},dwt y1{n,2},dwt y1{n,3},dwt y1{n,4}] =...
dwt2(dwt y1{n-1,1},LO D,HI D,’mode’,’per’);
[dwt y2{n,1},dwt y2{n,2},dwt y2{n,3},dwt y2{n,4}] =...
dwt2(dwt y2{n-1,1},LO D,HI D,’mode’,’per’);
end
end
%
% Quantize the Cb and Cr DWT coefficients
[dwt y1,y1Bits] = jpg2K Quantize(dwt y1,NL,2);
[dwt y2,y2Bits] = jpg2K Quantize(dwt y2,NL,3);
%
% % Do an NL-level 2D IDWT of the Cb and Cr components
idwt y1 = cell(NL,1);
idwt y2 = cell(NL,1);
%
for n = NL:-1:1
if n == 3
idwt y1{n} = idwt2(dwt y1{n,1},dwt y1{n,2},dwt y1{n,3},...
dwt y1{n,4},LO R,HI R,’mode’,’per’);
idwt y2{n} = idwt2(dwt y2{n,1},dwt y2{n,2},dwt y2{n,3},...
dwt y2{n,4},LO R,HI R,’mode’,’per’);
else
idwt y1{n} = idwt2(idwt y1{n+1},dwt y1{n,2},dwt y1{n,3},...
dwt y1{n,4},LO R,HI R,’mode’,’per’);
idwt y2{n} = idwt2(idwt y2{n+1},dwt y2{n,2},dwt y2{n,3},...
dwt y2{n,4},LO R,HI R,’mode’,’per’);
end
end
% Compute the SNR of Cb and Cr components due to quantization
SNRy1 = 20*log10(std2(y1)/std2(y1-idwt y1{1}));
SNRy2 = 20*log10(std2(y2)/std2(y2-idwt y2{1}));
% Upsample Cb & Cr components to original full size
y1 = imresize(idwt y1{1},[Height Width],’cubic’);
y2 = imresize(idwt y2{1},[Height Width],’cubic’);
end
% Do inverse ICT & level shift
if Depth == 1
Ahat = idwt y0{1} + 128;
58.4 JPEG2000 295
figure,imshow(uint8(Ahat))
sprintf(’Average bit rate = %5.2f bpp\n’,y0Bits/(Height*Width))
sprintf(’SNR(Y) = %4.2f dB\n’,SNRy0)
else
Ahat = zeros(Height,Width,Depth);
Ahat(:,:,1) = idwt y0{1} + 1.402*y2 + 128;
Ahat(:,:,2) = idwt y0{1} - 0.34413*y1 - 0.71414*y2 + 128;
Ahat(:,:,3) = idwt y0{1} + 1.772*y1 + 128;
figure,imshow(uint8(Ahat))
sprintf(’Average bit rate = %5.2f bpp\n’,...
(y0Bits+y1Bits+y2Bits)/(Height*Width))
SNRy0 = 20*log10(std2(y0)/std2(y0-idwt y0{1}));
sprintf(’SNR(Y) %4.2fdB\tSNR(Cb) = %4.2f dB\tSNR(Cr) =
%4.2fdB\n’,...
SNRy0,SNRy1,SNRy2)
end
TotalBits = 0;
for n = 1:NL
if n < NL
m1 = 2;
else
m1 = 1;
end
for m = m1:4
maxVal(m) = max(x{n,m}(:));
t = round(log2(maxVal(m)/Qstep(n,m)));
if t < 0
Qbits(n,m)= 0;
else
Qbits(n,m)= t;
end
TotalBits = TotalBits+Qbits(n,m)*size(x{n,m},1)*size(x{n,m},2);
end
end
%
for n = 1:NL
if n < NL
m1 = 2;
else
m1 = 1;
end
for m = m1:4
s = sign(x{n,m});
q2 = Qstep(n,m)/2;
y{n,m} = s .* round(abs(x{n,m})/q2)*q2;
end
end