
clear all;close all;
X = imread('markandpeter-500x332.jpg');  
[Height,Width,Depth] = size(X);

if Depth > 1
    X = double(rgb2gray(X)); %Change to grayScale        
else
    X = double(X);
end
clear Depth Height Width;
figure ,imshow(X,[]),title('original')
pause

dwtmode('sym');
wname = 'bior4.4';
[Lo_D,Hi_D,Lo_R,Hi_R]=wfilters('bior4.4');
subplot(2,2,1);stem(Lo_D);title('Low Pass Decomposition Filter');
subplot(2,2,2);stem(Hi_D);title('High Pass Decomposition Filter');
subplot(2,2,3);stem(Lo_R);title('Low Pass Reconstruction Filter');
subplot(2,2,4);stem(Hi_R);title('High Pass Reconstruction Filter');
xlabel('***********the four filters for bior4.4  wavelet*****************');
pause;
% Plot the structure of a two stage filter bank.
t = wtree(X,2,'bior4.4');
plot(t)
pause

% Compute a 2-level decomposition of the image .
[wc,s] = wavedec2(X,2,wname);
th=20;
% Extract the level 1 coefficients.
a1 = appcoef2(wc,s,wname,1);         
h1 = detcoef2('h',wc,s,1);        
v1 = detcoef2('v',wc,s,1);          
d1 = detcoef2('d',wc,s,1);  
%set details coefficients that are less than threshold to zero
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
A1=idwt2(a1,[],[],[],wname,size(X));
H1=idwt2(h1,[],[],[],wname,size(X));
V1=idwt2(v1,[],[],[],wname,size(X));
D1=idwt2(d1,[],[],[],wname,size(X));
figure
imshow(wcodemat(A1,255));
title('1st level approximate coefficients reconstructed');
pause
imshow(wcodemat(H1,255));
title('1st level horizonatl coefficients reconstructed before thresholding');
imshow(wcodemat(V1,255));
title('1st level vertical coefficients reconstructed before thresholding');
imshow(wcodemat(D1,255));
title('1st level approximate coefficients reconstructed before thresholding');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[i j]=size(h1);
for m=1:i
    for n= 1:j
        if abs(h1(m,n))<th
            h1(m,n)=0;
        end
    end
end
h1=10*h1;
for m=1:i
    for n= 1:j
        if abs(v1(m,n)<th)
            v1(m,n)=0;
        end
    end
end
v1=10*v1;
 for m=1:i
    for n= 1:j
        if abs(d1(m,n))<th
            d1(m,n)=0;
        end
    end
end
d1=10*d1;
        
% Extract the level 2 coefficients.
a2 = appcoef2(wc,s,wname,2);
h2 = detcoef2('h',wc,s,2);
v2 = detcoef2('v',wc,s,2);
d2 = detcoef2('d',wc,s,2);
[k l]=size(h2);
for m=1:k
    for n= 1:l
        if abs(h2(m,n))<th
            h1(m,n)=0;
        end
    end
end
h2=10*h2;
for m=1:k
    for n= 1:l
        if abs(v2(m,n))<th
            v2(m,n)=0;
        end
    end
end
v2=10*v2;
 for m=1:k
    for n= 1:l
        if abs(d2(m,n))<th
            d2(m,n)=0;
        end
    end
end
d2=10*d2;

% Display the decomposition up to level 1 only.
figure;
sz = size(X);
cod_a1 = wcodemat(a1,255); cod_a1r = wkeep(cod_a1, sz/2);
cod_h1 = wcodemat(h1,255); cod_h1r = wkeep(cod_h1, sz/2);
cod_v1 = wcodemat(v1,255); cod_v1r = wkeep(cod_v1, sz/2);
cod_d1 = wcodemat(d1,255); cod_d1r = wkeep(cod_d1, sz/2);
image([cod_a1r,cod_h1r;cod_v1r,cod_d1r]);
axis image; set(gca,'XTick',[],'YTick',[]); title('Single stage decomposition coefficients')
%colormap(map)
pause
hold on
figure;
%circshift(cod_a2,4);
cod_a1s=wkeep(cod_a1,sz/2);
cod_h1s=circshift(cod_h1,[100 100]);cod_h1sd=wkeep(cod_h1,sz/2);
cod_v1s=circshift(cod_v1,[100 100]);cod_v1sd=wkeep(cod_v1,sz/2);
cod_d1s=circshift(cod_d1,[100 100]);cod_d1sd=wkeep(cod_d1,sz/2);
image([cod_a1s,cod_h1sd;cod_v1sd,cod_d1sd]);
axis image; set(gca,'XTick',[],'YTick',[]); title('Single stage decomposition coefficients after shifting')
%colormap(map)
pause
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
% Display the entire decomposition upto level 2.
cod_a2 = wcodemat(a2,255); cod_a2r = wkeep(cod_a2, sz/4);
cod_h2 = wcodemat(h2,255); cod_h2r = wkeep(cod_h2, sz/4);
cod_v2 = wcodemat(v2,255); cod_v2r = wkeep(cod_v2, sz/4);
cod_d2 = wcodemat(d2,255); cod_d2r = wkeep(cod_d2, sz/4);
image([[cod_a2r,cod_h2r;cod_v2r,cod_d2r],cod_h1r;cod_v1r,cod_d1r]);
%image([cod_a2r,cod_h2r;cod_v2,cod_d2]);
axis image; set(gca,'XTick',[],'YTick',[]); title('Two stage decomposition level 2 coefficients')
%colormap(map)
pause
hold on
cod_a2sd=wkeep(cod_a2,sz/4);
cod_h2s=circshift(cod_h2,[100 100]);cod_h2sd=wkeep(cod_h2,sz/4);
cod_v2s=circshift(cod_v2,[100 100]);cod_v2sd=wkeep(cod_v2,sz/4);
cod_d2s=circshift(cod_d2,[100 100]);cod_d2sd=wkeep(cod_d2,sz/4);
image([[cod_a2sd,cod_h2sd;cod_v2sd,cod_d2sd],cod_h1sd;cod_v1sd,cod_d1sd]);
%image([cod_a2,cod_h2;cod_v2,cod_d2]);

axis image; set(gca,'XTick',[],'YTick',[]); title('Two stage decomposition level 2 coefficient after shifting')
%colormap(map)
pause
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Here are the reconstructed branches
ra2 = wrcoef2('a',wc,s,wname,2);
rh2 = wrcoef2('h',wc,s,wname,2);
rv2 = wrcoef2('v',wc,s,wname,2);
rd2 = wrcoef2('d',wc,s,wname,2);

ra1 = wrcoef2('a',wc,s,wname,1);
rh1 = wrcoef2('h',wc,s,wname,1);
rv1 = wrcoef2('v',wc,s,wname,1);
rd1 = wrcoef2('d',wc,s,wname,1);

cod_ra2 = wcodemat(ra2,255);
cod_rh2 = wcodemat(rh2,255);
cod_rv2 = wcodemat(rv2,255);
cod_rd2 = wcodemat(rd2,255);
cod_ra1 = wcodemat(ra1,255);
cod_rh1 = wcodemat(rh1,255);
cod_rv1 = wcodemat(rv1,255);
cod_rd1 = wcodemat(rd1,255);
%{
subplot(3,4,1); image(X); axis image; set(gca,'XTick',[],'YTick',[]); title('Original')
subplot(3,4,5); image(cod_ra1); axis image; set(gca,'XTick',[],'YTick',[]); title('ra1')
subplot(3,4,6); image(cod_rh1); axis image; set(gca,'XTick',[],'YTick',[]); title('rh1')
subplot(3,4,7); image(cod_rv1); axis image; set(gca,'XTick',[],'YTick',[]); title('rv1')
subplot(3,4,8); image(cod_rd1); axis image; set(gca,'XTick',[],'YTick',[]); title('rd1')
subplot(3,4,9); image(cod_ra2); axis image; set(gca,'XTick',[],'YTick',[]); title('ra2')
subplot(3,4,10); image(cod_rh2); axis image; set(gca,'XTick',[],'YTick',[]); title('rh2')
subplot(3,4,11); image(cod_rv2); axis image; set(gca,'XTick',[],'YTick',[]); title('rv2')
subplot(3,4,12); image(cod_rd2); axis image; set(gca,'XTick',[],'YTick',[]); title('rd2')
pause;
%}
figure;imshow(X,[]);title('original')
% Adding together the reconstructed average at level 2 and all of
% the reconstructed details gives the full reconstructed image.
pause;
Xhat = cod_ra2 + cod_rh2 + cod_rv2 + cod_rd2 + cod_rh1 + cod_rv1 + cod_rd1;
imshow(Xhat,[]);title('reconstructed before  shifting detail coefficients');
hold on
%%XhatS=cod_a2+cod_h2+cod_d2+cod_v2+cod_h1+cod_v1+cod_d1;//////////////////////////////////
%%imshow(XhatS,[]);title('reconstructed before after shifting detail coefficients');%%
%sprintf('Reconstruction error (using wrcoef2) = %g', max(max(abs(X-Xhat))))
%image(Xhat); axis image; set(gca,'XTick',[],'YTick',[]); title('reconstructed')
pause
% Another way to reconstruct the image.
pause;
XXhat = waverec2(wc,s,wname);
sprintf('Reconstruction error (using waverec2) = %g', max(max(abs(X-XXhat))))
figure;image(XXhat); axis image; set(gca,'XTick',[],'YTick',[]); title('reconstructed with waverec2')
pause
sprintf('peak signal to ration between original and reconstructed=%g',psnr(X,XXhat));
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
cod_ra2 = wkeep(cod_ra2, sz/4);
cod_rh2 = wkeep(cod_rh2, sz/4);
cod_rv2 = wkeep(cod_rv2, sz/4);
cod_rd2 = wkeep(cod_rd2, sz/4);
%cod_ra1 = wcodemat(ra1,255);
cod_rh1 = wkeep(cod_rh1, sz/2);
cod_rv1 = wkeep(cod_rv1, sz/2);
cod_rd1 = wkeep(cod_rd1, sz/2);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Compression can be accomplished by applying a threshold to the
% wavelet coefficients.  wdencmp is the function that does this.
% 'h' means use hard thresholding. Last argument = 1 means do not
% threshold the approximation coefficients.
%    perfL2 = energy recovery = 100 * ||wc_comp||^2 / ||wc||^2.
%             ||.|| is the L2 vector norm.
%    perf0 = compression performance = Percentage of zeros in wc_comp.


thr = 20; 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%55

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[X_comp,wc_comp,s_comp,perf0,perfL2] = wdencmp('gbl',wc,s,wname,2,thr,'h',1);%compression and denoising function

clf
subplot(1,2,1); image(X); axis image; set(gca,'XTick',[],'YTick',[]);
title('Original')
cod_X_comp = wcodemat(X_comp,255);
subplot(1,2,2); image(cod_X_comp); axis image; set(gca,'XTick',[],'YTick',[]);
title('Compressed using global hard threshold')
xlabel(sprintf('Energy retained = %2.1f%% \nNull coefficients = %2.1f%%',perfL2,perf0))
pause

% Better compression can be often be obtained if different thresholds
% are allowed for different subbands.


thr_h = [21 17];        % horizontal thresholds. @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@2             
thr_d = [23 19];        % diagonal thresholds.                
thr_v = [21 17];        % vertical thresholds.                
thr = [thr_h; thr_d; thr_v];
[X_comp,wc_comp,s_comp,perf0,perfL2] = wdencmp('lvd',X,wname,2,thr,'h');

clf
subplot(1,2,1); image(X); axis image; set(gca,'XTick',[],'YTick',[]);
title('Original')
cod_X_comp = wcodemat(X_comp,255);
subplot(1,2,2); image(cod_X_comp); axis image; set(gca,'XTick',[],'YTick',[]);
title('Compressed using variable hard thresholds')
xlabel(sprintf('Energy retained = %2.1f%% \nNull coefficients = %2.1f%%',perfL2,perf0))

% Return to default settings.
dwtmode('zpd');
