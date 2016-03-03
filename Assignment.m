
clear all;close all;
X = imread('guys.jpg');  
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

dwtmode('sym');
wname = 'bior4.4';
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
figure;
[wc,s] = wavedec2(X,2,wname);
a1 = appcoef2(wc,s,wname,1);         
h1 = detcoef2('h',wc,s,1);        
v1 = detcoef2('v',wc,s,1);          
d1 = detcoef2('d',wc,s,1);  
sz = size(X);
imshow(a1, []);
title('approximate coefficients');
pause
imshow(h1, [])
title('HL coefficients ');
pause
imshow(v1, []);
title('LH coefficients ');
pause
imshow(d1, []);
title('HH coefficients ');
R=a1+h1+v1+d1;
figure;imshow(R, []);title('before thresholding and scaling,shifting');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[i j]=size(h1);
psnr1=zeros(4,1);
cod_h115=zeros(size(h1));
cod_h1105=zeros(size(h1));
cod_h125=zeros(size(h1));
cod_h1205=zeros(size(h1));
cod_v115=zeros(size(h1));
cod_v1105=zeros(size(h1));
cod_v125=zeros(size(h1));
cod_v1205=zeros(size(h1));
cod_d115=zeros(size(h1));
cod_d1105=zeros(size(h1));
cod_d125=zeros(size(h1));
cod_d1205=zeros(size(h1));
psnr115=zeros(4,1);%PSNR for shift 1
psnr125=zeros(4,1);
psnr155=zeros(4,1);
psnr1105=zeros(4,1);
psnr1205=zeros(4,1);
h2=zeros(size(h1));
v2=zeros(size(h1));
d2=zeros(size(h1));
 plc=1;
 th1=5;
 for scl=2:5:17
for m=1:i
    for n= 1:j
        if abs(h1(m,n))<th1
             h1(m,n)=0;
             h2(m,n)=h1(m,n);
        end
               if abs(v1(m,n))<th1
                v1(m,n)=0;
                v2(m,n)=v1(m,n);
               end
          if abs(d1(m,n))<th1
            d1(m,n)=0;
            d2(m,n)=d1(m,n);
          end
           
       
    end
end
h1t=scl*h1;
v1t=scl*v1;
d1t=scl*d1;
Rc1=a1+h1t+v1t+d1t;
figure;
imshow(Rc1,[]);
title(sprintf('threshold 5  and scale =%2.1f%',scl));
pause;
psnr1(plc,1)=PSNR(R,Rc1);
plc=plc+1;
 end
cod_h115=circshift(h2,[1 -1]);
cod_h125=circshift(h2,[2 -2]);
cod_h155=circshift(h2,[5 -5]);
cod_h1105=circshift(h2,[10 -10]);
cod_h1205=circshift(h2,[20 -20]);
cod_v115=circshift(v2,[1 -1]);
cod_v125=circshift(v2,[2 -2]);
cod_v155=circshift(v2,[5 -5]);
cod_v1105=circshift(v2,[10 -10]);
cod_v1205=circshift(v2,[20 -20]);
cod_d115=circshift(d2,[1 -1]);
cod_d125=circshift(d2,[2 -2]);
cod_d155=circshift(d2,[5 -5]);
cod_d1105=circshift(d2,[10 -10]);
cod_d1205=circshift(d2,[20 -20]);
Rcs1=a1+cod_h115+cod_v115+cod_d115;%shift by one
Rcs2=a1+cod_h125+cod_v125+cod_d125;%shift by 2 
Rcs5=a1+cod_h155+cod_v155+cod_d155;%shift by 5 
Rcs10=a1+cod_h1105+cod_v1105+cod_d1105;%shift by 10
Rcs20=a1+cod_h1205+cod_v1205+cod_d1205;%shift by 2 
imshow(Rcs1,[]);title('threshold 5,shift 1  ');
pause;
imshow(Rcs2,[]);title('threshold 5,shift 2 ');
pause;
imshow(Rcs5,[]);title('threshold 5,shift 5');
pause;
imshow(Rcs10,[]);title('threshold 5,shift 10 ');
pause;
imshow(Rcs20,[]);title('threshold 5,shift 20 ');
 pause;
 psnr115(plc,1)=PSNR(R,Rcs1);
psnr125(plc,1)=PSNR(R,Rcs2);
psnr155(plc,1)=PSNR(R,Rcs5);
psnr1105(plc,1)=PSNR(R,Rcs10);
psnr1205(plc,1)=PSNR(R,Rcs20);

skl=[2 7 12 17];
plot(skl,psnr1(:,1),'-.r*');
xlabel('scale');
ylabel('psnr by threshold  5');
pause;
plot(skl,psnr115(:,1),'-.r*');
xlabel('scale');
ylabel('psnr by threshold  5 & shift 1');
pause;
plot(skl,psnr125(:,1),'-.r*');
xlabel('scale');
ylabel('psnr by threshold  5 & shift 2');
pause;
plot(skl,psnr155(:,1),'-.r*');
xlabel('scale');
ylabel('psnr by threshold  5 & shift 5');
pause;
plot(skl,psnr1105(:,1),'-.r*');
xlabel('scale');
ylabel('psnr by threshold  5 & shift 10');
pause;
plot(skl,psnr1205(:,1),'-.r*');
xlabel('scale');
ylabel('psnr by threshold  5 & shift 20');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%threshold 10
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
cod_h1110=zeros(size(h1));
cod_h1510=zeros(size(h1));
cod_h11010=zeros(size(h1));
cod_h1210=zeros(size(h1));
cod_h12010=zeros(size(h1));
cod_v1510=zeros(size(h1));
cod_v1110=zeros(size(h1));
cod_v11010=zeros(size(h1));
cod_v1210=zeros(size(h1));
cod_v12010=zeros(size(h1));
cod_d1110=zeros(size(h1));
cod_d1510=zeros(size(h1));
cod_d11010=zeros(size(h1));
cod_d1210=zeros(size(h1));
cod_d12010=zeros(size(h1));
psnr1110=zeros(4,1);%PSNR for shift 1
psnr1210=zeros(4,1);
psnr1510=zeros(4,1);
psnr11010=zeros(4,1);
psnr12010=zeros(4,1);
psnr10=zeros(4,1);
 th2=10;
 plc=1;
 for scl=2:5:17     
for m=1:i
    for n= 1:j
        if abs(h1(m,n))<th2
             h1(m,n)=0;
        end
               if abs(v1(m,n))<th2
                v1(m,n)=0;
               end
           if abs(d1(m,n))<th2
            d1(m,n)=0;
           end
    end
end
cod_h1110=circshift(h1,[1 -1]);
cod_h1210=circshift(h1,[2 -2]);
cod_h1510=circshift(h1,[5 -5]);
cod_h11010=circshift(h1,[10 -10]);
cod_h12010=circshift(h1,[20 -20]);
cod_v1110=circshift(v1,[1 -1]);
cod_v1210=circshift(v1,[2 -2]);
cod_v1510=circshift(v1,[5 -5]);
cod_v11010=circshift(v1,[10 -10]);
cod_v12010=circshift(v1,[20 -20]);
cod_d1110=circshift(d1,[1 -1]);
cod_d1210=circshift(d1,[2 -2]);
cod_d1510=circshift(d1,[5 -5]);
cod_d11010=circshift(d1,[10 -10]);
cod_d12010=circshift(d1,[20 -20]);
h1t=scl*h1;
v1t=scl*v1;
d1t=scl*d1;
Rc1=a1+h1t+v1t+d1t;
Rcs1=a1+cod_h1110+cod_v1110+cod_d1110;%shift by one
Rcs2=a1+cod_h1210+cod_v1210+cod_d1210;%shift by 2 
Rcs5=a1+cod_h1510+cod_v1510+cod_d1510;%shift by 5 
Rcs10=a1+cod_h11010+cod_v11010+cod_d11010;%shift by 10
Rcs20=a1+cod_h12010+cod_v12010+cod_d12010;%shift by 20 

figure;
imshow(Rc1,[]);
title(sprintf('threshold 10  and scale =%2.1f%',scl));
pause;
imshow(Rcs1,[]);title('threshold 10,shift 1');
pause;
imshow(Rcs2,[]);title('threshold 10,shift 2 ');
pause;
imshow(Rcs5,[]);title('threshold 10,shift 5 ');
pause;
imshow(Rcs10,[]);title('threshold 10,shift 10 ');
pause;
imshow(Rcs20,[]);title('threshold 10,shift 20 ');
psnr10(plc,1)=PSNR(R,Rc1);
psnr1110(plc,1)=PSNR(R,Rcs1);
psnr1210(plc,1)=PSNR(R,Rcs2);
psnr1510(plc,1)=PSNR(R,Rcs5);
psnr11010(plc,1)=PSNR(R,Rcs10);
psnr12010(plc,1)=PSNR(R,Rcs20);
plc=plc+1;
 end
 pause;
skl=[2 7 12 17];
plot(skl,psnr10(:,1),'-.r*');
xlabel('scale');
ylabel('psnr by threshold  10');
pause;
plot(skl,psnr1110(:,1),'-.r*');
xlabel('scale');
ylabel('psnr by threshold  10 & shift 1');
pause;
plot(skl,psnr1210(:,1),'-.r*');
xlabel('scale');
ylabel('psnr by threshold  10 & shift 2');
pause;
plot(skl,psnr1510(:,1),'-.r*');
xlabel('scale');
ylabel('psnr by threshold  10 & shift 5');
pause;
plot(skl,psnr11010(:,1),'-.r*');
xlabel('scale');
ylabel('psnr by threshold  10 & shift 10');
pause;
plot(skl,psnr12010(:,1),'-.r*');
xlabel('scale');
ylabel('psnr by threshold 10 & shift 20');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%threshold 20
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
cod_h1120=zeros(size(h1));
cod_h1520=zeros(size(h1));
cod_h11020=zeros(size(h1));
cod_h1220=zeros(size(h1));
cod_h12020=zeros(size(h1));
cod_v1520=zeros(size(h1));
cod_v1120=zeros(size(h1));
cod_v11020=zeros(size(h1));
cod_v1220=zeros(size(h1));
cod_v12020=zeros(size(h1));
cod_d1120=zeros(size(h1));
cod_d1520=zeros(size(h1));
cod_d11020=zeros(size(h1));
cod_d1220=zeros(size(h1));
cod_d12020=zeros(size(h1));
psnr1120=zeros(4,1);%PSNR for shift 1
psnr1220=zeros(4,1);
psnr1520=zeros(4,1);
psnr11020=zeros(4,1);
psnr12020=zeros(4,1); 
psnr20=zeros(4,1);
th3=20;
 for scl=2:5:17   
for m=1:i
    for n= 1:j
        if abs(h1(m,n))<th3
             h1(m,n)=0;
        end
                if abs(v1(m,n))<th3
                v1(m,n)=0;
                end
            if abs(d1(m,n))<th1
            d1(m,n)=0;
            end
   end
end
cod_h1120=circshift(h1,[1 -1]);
cod_h1220=circshift(h1,[2 -2]);
cod_h1520=circshift(h1,[5 -5]);
cod_h11020=circshift(h1,[10 -10]);
cod_h12020=circshift(h1,[20 -20]);
cod_v1120=circshift(v1,[1 -1]);
cod_v1220=circshift(v1,[2 -2]);
cod_v1520=circshift(v1,[5 -5]);
cod_v11020=circshift(v1,[10 -10]);
cod_v12020=circshift(v1,[20 -20]);
cod_d1120=circshift(d1,[1 -1]);
cod_d1220=circshift(d1,[2 -2]);
cod_d1520=circshift(d1,[5 -5]);
cod_d11020=circshift(d1,[10 -10]);
cod_d12020=circshift(d1,[20 -20]);
h1t=scl*h1;
v1t=scl*v1;
d1t=scl*d1;
Rc20=a1+h1t+v1t+d1t;%Thresholded and unshifted
Rcs1=a1+cod_h1120+cod_v1120+cod_d1120;%shift by one
Rcs2=a1+cod_h1220+cod_v1220+cod_d1220;%shift by 2 
Rcs5=a1+cod_h1520+cod_v1520+cod_d1520;%shift by 5 
Rcs10=a1+cod_h11020+cod_v11020+cod_d11020;%shift by 10
Rcs20=a1+cod_h12020+cod_v12020+cod_d12020;%shift by 20 

figure;
imshow(Rc20,[]);
title(sprintf('threshold 20  and scale =%2.1f%',scl));
pause;
imshow(Rcs1,[]);title('threshold 20,shift 1 ');
pause;
imshow(Rcs2,[]);title('threshold 20,shift 2 ');
pause;
imshow(Rcs5,[]);title('threshold 20,shift 5 ');
pause;
imshow(Rcs10,[]);title('threshold 20,shift 10 ');
pause;
imshow(Rcs20,[]);title('threshold 20,shift 20');
psnr20(plc,1)=PSNR(R,Rc1);
psnr1120(plc,1)=PSNR(R,Rcs1);
psnr1220(plc,1)=PSNR(R,Rcs2);
psnr1520(plc,1)=PSNR(R,Rcs5);
psnr11020(plc,1)=PSNR(R,Rcs10);
psnr12020(plc,1)=PSNR(R,Rcs20);
plc=plc+1;
 end
 pause;
skl=[2 7 12 17];
plot(skl,psnr20(5:end,1),'-.r*');
xlabel('scale');
ylabel('psnr by threshold 20');
pause;
plot(skl,psnr1120(5:end,1),'-.r*');
xlabel('scale');
ylabel('psnr by threshold  20 & shift 1');
pause;
plot(skl,psnr1220(5:end,1),'-.r*');
xlabel('scale');
ylabel('psnr by threshold  20 & shift 2');
pause;
plot(skl,psnr1520(5:end,1),'-.r*');
xlabel('scale');
ylabel('psnr by hreshold  20 & shift 5');
pause;
plot(skl,psnr11020(5:end,1),'-.r*');
xlabel('scale');
ylabel('psnr by threshold  20 & shift 10');
pause;
plot(skl,psnr12020(5:end,1),'-.r*');
xlabel('scale');
ylabel('psnr by threshold  20 & shift 20');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


