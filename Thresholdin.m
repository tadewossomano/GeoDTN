
% Example4 3.m
% Computes the Two-dimensional Discrete Wavelet Transform
% of an image up to two levels using ‘‘db2’’ wavelet. The
% DWT coefficients are placed in a large array for display
% purpose. The innermost 4 quadrants correspond to
% LL,HL,LH, and HH coefficients at level 2.
% the three outer quadrants correspond to HL,LH, and HH
% coefficients at level 1.
%
inFile = 'lena.jpg';
%inFile = ‘barbara.tif’;
%inFile = ‘liftingbody.png’;
A = imread(inFile);
[Height,Width,Depth] = size(A);
if Depth ==1
f = double(A);
else
f = double(A(:,:,1));
end
% 2-level 2D DWT
[DWT,S] = wavedec2(f,2,'db2');
% array to store all DWT coefficients for display
y = zeros(2*S(1,1)+S(2,1),2*S(1,2)+S(2,2));
% Extract approximation & detail coefficients @ level 2 and
% Place them in the large single array y for display
LL2 = appcoef2(DWT,S,2,'db2');
[HL2,LH2,HH2] = detcoef2('all',DWT,S,2);
y(1:S(1,1),1:S(1,2)) = LL2;
y(1:S(1,1),S(1,2)+1:2*S(1,2)) = HL2;
y(S(1,1)+1:2*S(1,1),1:S(1,2)) = LH2;
y(S(1,1)+1:2*S(1,1),S(1,2)+1:2*S(1,2)) = HH2;
% Now extract detail coefficients @ level 1 and
% Place them in the large single array y for display
[HL1,LH1,HH1] = detcoef2('all',DWT,S,1);
y(1:S(3,1),2*S(1,2)+1:2*S(1,2)+S(3,2)) = HL1;
y(2*S(1,1)+1:2*S(1,1)+S(3,1),1:S(3,2)) = LH1;
y(2*S(1,1)+1:2*S(1,1)+S(3,1),2*S(1,2)+1:2*S(1,2)+S(3,2)) = HH1;
% use wcodemat for visual enhancement
figure,imshow(wcodemat(y,32,'m',1),[]), title('2-Level2D DWT')
