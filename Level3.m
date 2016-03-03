% Example4 4.m
% Computes the Two-dimensional Discrete Wavelet Transform
% of an image up to three levels using orthogonal or
% biorthogonal wavelet.
% Then computes the energy in the coefficients at different
% levels and orientations as a percentage of total energy in the
% image. It also computes the histogram of the coefficients.
% dwtType = ’’ortho’’ or ’’biortho’’
% WaveletName = ’’db2’’ or ’’bior2.2’’. Type help ’’wfilters’’
% for the possible wavelets.
inFile = 'goldhill2.jpg';
%inFile = ’barbara.tif’;
%inFile = ’liftingbody.png’;
A = imread(inFile);
[Height,Width,Depth] = size(A);
if Depth == 1
f = double(A);
else
f = double(A(:,:,1));
end
dwtType = 'ortho';
WaveletName = 'db2';
switch dwtType
case 'ortho'
% Energy compaction in orthogonal DWT
% 3-level 2D DWT
[DWT,S] = wavedec2(f,3,WaveletName);
% Extract the approximation & detail coefficients at
all levels
LL3 = appcoef2(DWT,S,3,WaveletName);
[HL3,LH3,HH3] = detcoef2('all',DWT,S,3);
[HL2,LH2,HH2] = detcoef2('all',DWT,S,2);
[HL1,LH1,HH1] = detcoef2('all',DWT,S,1);
% compute the percentage of energy in the coefficients
[Ea,Eh,Ev,Ed] = wenergy2(DWT,S);
sprintf('Energy in LL3 = %5.2f%%',Ea)
sprintf('\t\t\t Energy in \nHL3 = %5.4f%% \t HL2 = %5.4f%%\t HL1 = %5.4f%% \n',Eh)
sprintf('\t\t\t Energy in \nLH3 = %5.4f%% \t LH2 = %5.4f%%\t LH1 = %5.4f%% \n',Ev)
sprintf('\t\t\t Energy in \nHH3 = %5.4f%% \t HH2 = %5.4f%%\t HH1 = %5.4f%% \n',Ed)
[Na,Ba] = hist(LL3(:),128);
[Nh3,Bh3] = hist(HL3(:),64);
[Nv3,Bv3] = hist(LH3(:),64);
[Nd3,Bd3] = hist(HH3(:),64);
figure,subplot(4,1,1),plot(Ba,Na,'k')
title(['Histo. of Approx. & detail coefficients @Level 3: ' WaveletName])
subplot(4,1,2),plot(Bh3,Nh3,'k')
subplot(4,1,3),plot(Bv3,Nv3,'k')
subplot(4,1,4),plot(Bd3,Nd3,'k')
[Nh2,Bh2] = hist(HL2(:),64);
[Nv2,Bv2] = hist(LH2(:),64);
[Nd2,Bd2] = hist(HH2(:),64);
figure,subplot(3,1,1),plot(Bh2,Nh2,'k')
title(['Histo. of detail coefficients @ Level 2:' WaveletName])
subplot(3,1,2),plot(Bv2,Nv2,'k')
subplot(3,1,3),plot(Bd2,Nd2,'k')
[Nh1,Bh1] = hist(HL1(:),64);
[Nv1,Bv1] = hist(LH1(:),64);
[Nd1,Bd1] = hist(HH1(:),64);
figure,subplot(3,1,1),plot(Bh1,Nh1,'k')
title(['Histo. of detail coefficients @ Level 1:' WaveletName])
subplot(3,1,2),plot(Bv1,Nv1,'k')
subplot(3,1,3),plot(Bd1,Nd1,'k')
case 'biortho'
% Energy compaction in orthogonal DWT
% 3-level 2D DWT
[DWT,S] = wavedec2(f,3,'bior2.2');
% Extract the approximation & detail coefficients at
all levels
LL3 = appcoef2(DWT,S,3,'db2');
[HL3,LH3,HH3] = detcoef2('all',DWT,S,3);
[HL2,LH2,HH2] = detcoef2('all',DWT,S,2);
[HL1,LH1,HH1] = detcoef2('all',DWT,S,1);
% compute the percentage of energy in the coefficients
[Ea,Eh,Ev,Ed] = wenergy2(DWT,S);
sprintf('Energy in LL3 = %5.2f%%',Ea);
sprintf('\t\t\t Energy in \nHL3 = %5.4f%% \t HL2 = %5.4f%%\t HL1 = %5.4f%% \n',Eh)
sprintf('\t\t\t Energy in \nLH3 = %5.4f%% \t LH2 = %5.4f%%\t LH1 = %5.4f%% \n',Ev)
sprintf('\t\t\t Energy in \nHH3 = %5.4f%% \t HH2 = %5.4f%%\t HH1 = %5.4f%% \n',Ed)
[Na,Ba] = hist(LL3(:),128);
[Nh3,Bh3] = hist(HL3(:),64);
[Nv3,Bv3] = hist(LH3(:),64);
[Nd3,Bd3] = hist(HH3(:),64);
figure,subplot(4,1,1),plot(Ba,Na,'k')
title(['Histo. of Approx. & detail coefficients @Level 3: ' WaveletName])
subplot(4,1,2),plot(Bh3,Nh3,'k')
subplot(4,1,3),plot(Bv3,Nv3,'k')
subplot(4,1,4),plot(Bd3,Nd3,'k')
[Nh2,Bh2] = hist(HL2(:),64);
[Nv2,Bv2] = hist(LH2(:),64);
[Nd2,Bd2] = hist(HH2(:),64);
figure,subplot(3,1,1),plot(Bh2,Nh2,'k')
title(['Histo. of detail coefficients @ Level 2:' WaveletName])
subplot(3,1,2),plot(Bv2,Nv2,'k')
subplot(3,1,3),plot(Bd2,Nd2,'k')
[Nh1,Bh1] = hist(HL1(:),64);
[Nv1,Bv1] = hist(LH1(:),64);
[Nd1,Bd1] = hist(HH1(:),64);
figure,subplot(3,1,1),plot(Bh1,Nh1,'k')
title(['Histo. of detail coefficients @ Level 1:' WaveletName])
subplot(3,1,2),plot(Bv1,Nv1,'k')
subplot(3,1,3),plot(Bd1,Nd1,'k')
end