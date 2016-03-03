
clear all;close all;
X = imread('lena.jpg');  
[height,width,Depth] = size(X);

if Depth > 1
    X = double(rgb2gray(X)); %Change to grayScale        
else
    X = double(X);
end
clear Depth Height Width;
figure ,imshow(X,[]),title('original')
pause
clf;
%{
Haar              		haar           
Daubechies        		db             
Symlets           		sym            
Coiflets          		coif           
BiorSplines       		bior           
ReverseBior       		rbio           
Meyer             		meyr           
DMeyer            		dmey           
Gaussian          		gaus           
Mexican_hat       		mexh           
Morlet            		morl           
Complex Gaussian  		cgau           
Shannon           		shan           
Frequency B-Spline		fbsp           
Complex Morlet    		cmor  
%}

dwtmode('sym');
wname = 'bior4.4';
%wname = 'haar';
[Lo_D,Hi_D,Lo_R,Hi_R]=wfilters('bior4.4');
subplot(2,2,1);stem(Lo_D);title('Low Pass Decomposition Filter');
subplot(2,2,2);stem(Hi_D);title('High Pass Decomposition Filter');
subplot(2,2,3);stem(Lo_R);title('Low Pass Reconstruction Filter');
subplot(2,2,4);stem(Hi_R);title('High Pass Reconstruction Filter');
xlabel('the four filters for bior4.4  wavelet');
pause;
[phi,w] = phasez(Lo_D,10);
figure;
subplot(2,2,1);plot(w,phi);xlabel('frequency');ylabel('phase');title('LP Decomposition Filter phase response');
[phi1,w1] = phasez(Hi_D,10);
subplot(2,2,2);plot(w1,phi1);xlabel('frequency');ylabel('phase');title('HP Decomposition Filter phase response');
[phi2,w2] = phasez(Lo_R,10);
subplot(2,2,3);plot(w2,phi2);xlabel('frequency');ylabel('phase');title('LP Reconstruction Filter phase response');
[phi3,w3] = phasez(Hi_R,10);
subplot(2,2,4);plot(w3,phi3);xlabel('frequency');ylabel('phase');title('HP Reconstruction Filter phase response');
pause
t = wtree(X,2,'bior4.4');
plot(t)
pause

figure;
% Compute a 2-level decomposition of the image .
[wc,s] = wavedec2(X,2,wname);
%th=10;
% Extract the level 1 coefficients.
a1 = appcoef2(wc,s,wname,1);         
h1 = detcoef2('h',wc,s,1);        
v1 = detcoef2('v',wc,s,1);          
d1 = detcoef2('d',wc,s,1);  
sz = size(X);
%{
cod_a1b = wcodemat(a1,255); cod_a1br = wkeep(cod_a1b, sz/2);
cod_h1b = wcodemat(h1,255); cod_h1br = wkeep(cod_h1b, sz/2);
cod_v1b = wcodemat(v1,255); cod_v1br = wkeep(cod_v1b, sz/2);
cod_d1b = wcodemat(d1,255); cod_d1br = wkeep(cod_d1b, sz/2);
figure,imshow([cod_a1br,cod_h1br;cod_v1br,cod_d1br],[]);
axis image; set(gca,'XTick',[],'YTick',[]); title('Single stage decomposition coefficients before thresholding');
pause
%}
%Set details coefficients that are less than threshold to zero
imshow(a1, []);
title('approximate coefficients of 1st level decomposition');
pause
imshow(h1, [])
title('HL coefficients of 1st level decomposition ');
pause
imshow(v1, []);
title('LH coefficients of 1st level decomposition ');
pause
imshow(d1, []);
title('HH coefficients of 1st level decomposition ');
%{
[hh wh]=size(h1);
tCounter=0;
tHolderH=zeros(hh,wh);
while(tCounter<=0.1*hh*wh
    for i=1:hh
        for j=1:wh
            if h1(i,j)==max(h1(:))
                tHolderH(i,j)=h1(i,j);
                h1(i,j)=0;
            else
                tHolderH(i,j)=0;
            end
        end
    end
   tCounter=tCounter+1; 
                
end

%tHolderH1=zeros(height,width);
tHolderH1=2*tHolderH;
imshow(tHolderH1, []);
title('10% & *2 HL 1st level coefficients');
pause;
%}
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[i j]=size(h1);
psnr1=zeros(4,1);
 th1=5;
 plc=1;
 for scl=2:5:17
for m=1:i
    for n= 1:j
        if abs(h1(m,n))<th1
            h1(m,n)=0;
        end
    end
end
h1t=scl*h1;
figure;
imshow(h1t,[]);
psnr1(plc,1)=PSNR(h1,h1t);
title('threshold and scale ');
pause;
plc=plc+1;
 end
skl=[2 7 12 17];
plot(skl,psnr1(:,1),'-.r*');
xlabel('scale');
ylabel('psnr');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
plc2=1;
psnr2=zeros(4,1);
th2=10;
[iv jv]=size(v1);
for scl=2:5:17
for m=1:iv
    for n= 1:jv
        if abs(v1(m,n)<th2)
            v1(m,n)=0;
        end
    end
end
v1t=scl*v1;
figure;
imshow(h1t,[]);
psnr2(plc2,1)=PSNR(v1,v1t);
title('threshold and scale ');
pause;
plc2=plc2+1;
end
%skl=[2 7 12 17];
plot(skl,psnr2(:,1),'-.r*');
xlabel('scale');
ylabel('psnr');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
th3=20;
plc3=1;
psnr3=zeros(4,1);
[id jd]=size(d1);
for scl=2:5:17
 for m=1:i
    for n= 1:j
        if abs(d1(m,n))<th3
            d1(m,n)=0;
        end
    end
 end
 d1t=scl*d1;
 figure;
 imshow(d1t,[]);
 psnr3(plc3,1)=PSNR(v1,v1t);
 title('vertical thresholded and scaled');
 pause;
 plc3=plc3+1;
end
skl=[2 7 12 17];
plot(skl,psnr3(:,1),'-.r*');
xlabel('scale');
ylabel('psnr');
tCounter=0;
[ht,wt]=size(h1);
tHolderV=zeros(height,width);
while(tCounter<=0.1*ht*wt)
    for i=1:ht
        for j=1:wt
            if v1(i,j)==max(v1(:))
                tHolderV(i,j)=v1(i,j);    
                v1(i,j)=0;
            else
                tHolderV(i,j)=0;
            end
        end
    end
    
             tCounter=tCounter+1;     
end
%tHolderV1=zeros(height,width);
tHolderV1=2*tHolderV;
imshow(tHolderV1, []);
title('10% & *2 LH 1st level coefficients');
pause;
tHolderD=zeros(height,width);
while(tCounter<=0.1*height*width)
    for i=1:height
        for j=1:width
            if d1(i,j)==max(v1(:))
                tHolderD(i,j)=v1(i,j);  
                 d1(i,j)=0;
            else
                tHolderD(i,j)=0;
            end
        end
    end
   
     tCounter=tCounter+1;   
end
%tHolderD1=zeros(height,width);
tHolderD1=2*tHolderD;
imshow(tHolderD1, []);
title('10% & *2 HH 1st level coefficients');
pause;
%}
  % Display the decomposition up to level 1 only.
imshow(h1t, [])
title('HL coefficients of 1st thshing and amplification');
pause
imshow(v1t, []);
title('LH coefficients of 1st level decomposition //');
pause
imshow(d1t, []);
title('HH coefficients of 1st level decomposition//');
pause
R1=a1+h1t+v1t+d1t;
imshow(R1 ,[]);
title('Reconstructed after thshing&amlification level 1');

%{
cod_a1t = wcodemat(a1,255); cod_a1tr = wkeep(cod_a1t, sz/2);
cod_h1t = wcodemat(h1t,255); cod_h1tr = wkeep(cod_h1t, sz/2);
cod_v1t = wcodemat(v1t,255); cod_v1tr = wkeep(cod_v1t, sz/2);
cod_d1t = wcodemat(d1t,255); cod_d1tr = wkeep(cod_d1t, sz/2);
figure,imshow([cod_a1tr,cod_h1tr;cod_v1tr,cod_d1tr],[]);
axis image; set(gca,'XTick',[],'YTick',[]); title('Single stage decomposition coefficients after thresholding');
sprintf('The psnr(h1,h1t)  is =%0.5e', PSNR(h1,h1t));
sprintf('The psnr(v1,v1t)  is =%0.5e', PSNR(v1,v1t));
sprintf('The psnr(d1,d1t)  is =%0.5e', PSNR(d1,d1t));
%colormap(map)
%}
pause      
% Extract the level 2 coefficients.
a2 = appcoef2(wc,s,wname,2);
h2 = detcoef2('h',wc,s,2);
v2 = detcoef2('v',wc,s,2);
d2 = detcoef2('d',wc,s,2);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
%{
%Display the entire decomposition upto level 2.
cod_a2 = wcodemat(a2,255); cod_a2r = wkeep(cod_a2, sz/4);
cod_h2 = wcodemat(h2,255); cod_h2r = wkeep(cod_h2, sz/4);
cod_v2 = wcodemat(v2,255); cod_v2r = wkeep(cod_v2, sz/4);
cod_d2 = wcodemat(d2,255); cod_d2r = wkeep(cod_d2, sz/4);
imshow([[cod_a2r,cod_h2r;cod_v2r,cod_d2r],cod_h1tr;cod_v1tr,cod_d1tr],[]);
%image([cod_a2r,cod_h2r;cod_v2,cod_d2],cod_h1r;cod_v1r,cod_d1r);
axis image; set(gca,'XTick',[],'YTick',[]); title('Two stage decmstn after thresholding level 1 coeff. and b/re thshing level 2 coeff.')
pause
%}


%circshift(cod_a2,4);
%cod_a1s=wkeep(cod_a1t,sz/2);
cod_h1=circshift(h1t,[50 50]);%cod_h1s=wkeep(cod_h1,sz/2);
cod_v1=circshift(v1t,[50 50]);%cod_v1s=wkeep(cod_v1,sz/2);
cod_d1=circshift(d1t,[50 50]);%cod_d1s=wkeep(cod_d1,sz/2);
%imshow([cod_a1s,cod_h1s;cod_v1s,cod_d1s],[]);
%axis image; set(gca,'XTick',[],'YTick',[]); title('Single stage decomposition coefficients after shifting')
%colormap(map)
imshow(cod_h1, [])
title('HL coefficients of 1 level  a/r shifting');
pause
imshow(cod_v1, []);
title('LH coefficients of 1 level  //');
pause
imshow(cod_d1, []);
title('HH coefficients of 1 level  //');
pause
R2=a1+cod_h1+cod_v1+cod_d1;
imshow(R2, []);
title('Reconstructed after shifting level coefficients');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%cod_a2s=wkeep(cod_a2,sz/4);
imshow(h2, [])
title('HL coefficients of 2nd level ');
pause
imshow(v2, []);
title('LH coefficients of 2nd level ');
pause
imshow(d2, []);
title('HH coefficients of 2nd level ');
[k l]=size(h2);
for m=1:k
    for n= 1:l
        if abs(h2(m,n))<th
            h2(m,n)=0;
        end
    end
end
h2t=5*h2;
for m=1:k
    for n= 1:l
        if abs(v2(m,n))<th
            v2(m,n)=0;
        end
    end
end
v2t=5*v2;
 for m=1:k
    for n= 1:l
        if abs(d2(m,n))<th
            d2(m,n)=0;
        end
    end
end
d2t=5*d2;


imshow(h2t, [])
title('HL coefficients of 2 level  a/r thresholdin');
pause
imshow(v2t, []);
title('LH coefficients of 2 level //');
pause
imshow(d2t, []);
title('HH coefficients of 2 level //');
cod_h2=circshift(h2t,[50 50]);%cod_h2s=wkeep(cod_h2,sz/4);
cod_v2=circshift(v2,[50 50]);%cod_v2s=wkeep(cod_v2,sz/4);
cod_d2=circshift(d2t,[50 50]);%cod_d2s=wkeep(cod_d2,sz/4);
%imshow([[cod_a2s,cod_h2s;cod_v2s,cod_d2s],cod_h1s;cod_v1s,cod_d1s],[]);
imshow(cod_h2, [])
title('HL coefficients of 2 level a/r shifting');
pause
imshow(cod_v2, []);
title('LH coefficients of 2 level //');
pause
imshow(cod_d2, []);
title('HH coefficients of 2 level //');
pause

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
%{
% Display the entire decomposition upto level 2.
cod_a2t = wcodemat(a2,255); cod_a2r = wkeep(cod_a2t, sz/4);
cod_h2t = wcodemat(h2t,255); cod_h2r = wkeep(cod_h2t, sz/4);
cod_v2t = wcodemat(v2t,255); cod_v2r = wkeep(cod_v2t, sz/4);
cod_d2t = wcodemat(d2t,255); cod_d2r = wkeep(cod_d2t, sz/4);
imshow([[cod_a2r,cod_h2r;cod_v2r,cod_d2r],cod_h1tr;cod_v1tr,cod_d1tr],[]);
%image([cod_a2r,cod_h2r;cod_v2,cod_d2],cod_h1r;cod_v1r,cod_d1r);

axis image; set(gca,'XTick',[],'YTick',[]); title('Two stage decmpn after thrshding level 1 and 2 coeff.')
%colormap(map)


sprintf('The psnr(h2,h2t)  is =%0.5e', PSNR(h2,h2t));
sprintf('The psnr(v2,v2t)  is =%0.5e', PSNR(v2,v2t));
sprintf('The psnr(d2,d2t)  is =%0.5e', PSNR(d2,d2t));

pause
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Amfd=cod_a2+cod_h1+cod_v1+cod_d1+cod_h2+cod_v2+cod_d2;
%image(Amfd);
%axis image; set(gca,'XTick',[],'YTick',[]); title('Two stage reconstruction after thresholding level 1 coefficients')
%colormap(map)
%pause
%}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5

%image([cod_a2,cod_h2;cod_v2,cod_d2]);

%axis image; set(gca,'XTick',[],'YTick',[]); title('Two stage decomposition after shifting L1&2 coeff.')
%colormap(map)
%pause

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
title('Reconstructed using global hard threshold')
xlabel(sprintf('Energy retained = %2.1f%% \nNull coefficients = %2.1f%%',perfL2,perf0))
pause
message = sprintf('The PSNR using global thshold  is %.2f.\nThe PSNR = %.2f',PSNR(X,X_comp));
msgbox(message);
pause;
% Better compression can be often be obtained if different thresholds
% are allowed for different subbands.


thr_h = [21 17];        % horizontal thresholds. @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@2             
thr_d = [23 19];        % diagonal thresholds.                
thr_v = [21 17];        % vertical thresholds.                
thr = [thr_h; thr_d; thr_v];
[X_comp1,wc_comp,s_comp,perf0,perfL2] = wdencmp('lvd',X,wname,2,thr,'h');
subplot(1,2,1); image(X); axis image; set(gca,'XTick',[],'YTick',[]);
title('Original')
cod_X_comp = wcodemat(X_comp1,255);
subplot(1,2,2); image(cod_X_comp); axis image; set(gca,'XTick',[],'YTick',[]);
title('Reconstructed using variable threshold')
xlabel(sprintf('Energy retained = %2.1f%% \nNull coefficients = %2.1f%%',perfL2,perf0))
pause
message = sprintf('The PSNR with variable thshold is %.2f.\nThe PSNR = %.2f',PSNR(X,X_comp1));
msgbox(message);
pause;
psnr=zeros(40,1);
for i=1:40 
   [X_comp2,wc_comp,s_comp,perf0,perfL2] = wdencmp('gbl',wc,s,wname,2,i,'h',1);
   psnr(i,1)=PSNR(X,X_comp2);
end
 x=1:40;
 figure;
plot(x,psnr(:,1),'-.r*');
xlabel('threshold value');
ylabel('corresponding PSNR value');




