clear all;close all;
X = imread('sticks.jpg');  
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
 
 plc=1;
 for scl=2:5:17
     th1=5;
for m=1:i
    for n= 1:j
        if abs(h1(m,n))<th1
             h1(m,n)=0;
            if abs(v1(m,n))<th1
                v1(m,n)=0;
                if abs(d1(m,n))<th1
            d1(m,n)=0;
                end
            end
        end
    end
end
h1t=scl*h1;
v1t=scl*v1;
d1t=scl*d1;
Rc1=a1+h1t+v1t+d1t;
figure;
imshow(Rc1,[]);
psnr1(plc,1)=PSNR(R,Rc1);
title(sprintf('threshold 5  and scale =%2.1f%',scl));
pause;
plc=plc+1;
 end
 pause;
skl=[2 7 12 17];
plot(skl,psnr1(:,1),'-.r*');
xlabel('scale');
ylabel('psnr by scale 5');
psnr2=zeros(4,1);
for scl=2:5:17
     th1=10;
for m=1:i
    for n= 1:j
        if abs(h1(m,n))<th1
             h1(m,n)=0;
            if abs(v1(m,n))<th1
                v1(m,n)=0;
                if abs(d1(m,n))<th1
            d1(m,n)=0;
                end
            end
        end
    end
end
h1t=scl*h1;
v1t=scl*v1;
d1t=scl*d1;
Rc2=a1+h1t+v1t+d1t;
figure;
imshow(Rc2,[]);
psnr2(plc,1)=PSNR(R,Rc2);
title(sprintf('threshold 10  and scale =%2.1f%',scl));
pause;
plc=plc+1;
end
pause;
plot(skl,psnr2(5:end,1),'-.r*');
xlabel('scale');
ylabel('psnr by scale 10');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
psnr3=zeros(4,1);
for scl=2:5:17
     th1=20;
for m=1:i
    for n= 1:j
        if abs(h1(m,n))<th1
             h1(m,n)=0;
            if abs(v1(m,n))<th1
                v1(m,n)=0;
                if abs(d1(m,n))<th1
            d1(m,n)=0;
                end
            end
        end
    end
end
h1t=scl*h1;
v1t=scl*v1;
d1t=scl*d1;
Rc3=a1+h1t+v1t+d1t;
figure;
imshow(Rc3,[]);
psnr3(plc,1)=PSNR(R,Rc3);
title(sprintf('threshold 20  and scale =%2.1f%',scl));
pause;
plc=plc+1;
end
pause;
plot(skl,psnr3(9:end,1),'-.r*');
xlabel('scale');
ylabel('psnr by scale 20');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Rt=a1+h1t+v1t+d1t;
psnrCH=zeros(5,1);
cod_h11=circshift(h1t,[1 -1]);pnrCH(1,1)=PSNR(h1t,cod_h11);
cod_h12=circshift(h1t,[2 -2]);pnrCH(2,1)=PSNR(h1t,cod_h12);
cod_h15=circshift(h1t,[5 -5]);psnrCH(3,1)=PSNR(h1t,cod_h15);
cod_h110=circshift(h1t,[10 -10]);psnrCH(4,1)=PSNR(h1t,cod_h110);
cod_h120=circshift(h1t,[20 -20]);psnrCH(5,1)=PSNR(h1t,cod_h120);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
psnrCV=zeros(5,1);
cod_v11=circshift(v1t,[1 -1]);pnrCV(1,1)=PSNR(v1t,cod_v11);
cod_v12=circshift(v1t,[2 -2]);pnrCV(2,1)=PSNR(v1t,cod_v12);
cod_v15=circshift(v1t,[5 -5]);psnrCV(3,1)=PSNR(v1t,cod_v15);
cod_v110=circshift(v1t,[10 -10]);psnrCV(4,1)=PSNR(v1t,cod_v110);
cod_v120=circshift(v1t,[20 -20]);psnrCV(5,1)=PSNR(v1t,cod_v120);
psnrCD=zeros(5,1);
cod_d11=circshift(d1t,[1 -1]);pnrCD(1,1)=PSNR(d1t,cod_d11);
cod_d12=circshift(d1t,[2 -2]);pnrCD(2,1)=PSNR(d1t,cod_d12);
cod_d15=circshift(d1t,[5 -5]);psnrCD(3,1)=PSNR(d1t,cod_d15);
cod_d110=circshift(d1t,[10 -10]);psnrCD(4,1)=PSNR(d1t,cod_d110);
cod_d120=circshift(d1t,[20 -20]);psnrCD(5,1)=PSNR(d1t,cod_d120);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5

 XiCS1=a1+cod_h11+cod_v11+cod_d11;
 figure;
 imshow(XiCS1,[]);
 title(' shift by 1');
 pause;
  XiCS2=a1+cod_h12+cod_v12+cod_d12;
 figure;
 imshow(XiCS2,[]);
 title(' shift  by 2');
 pause;
XiCS5=a1+cod_h15+cod_v15+cod_d15;
 figure;
 imshow(XiCS5,[]);
 title(' shift by 5');
 pause;
XiCS10=a1+cod_h110+cod_v110+cod_d110;
 figure;
 imshow(XiCS10,[]);
 title('shift by  10');
 pause;
 XiCS20=a1+cod_h120+cod_v120+cod_d120;
 figure;
 imshow(XiCS20,[]);
 title('shift by 20');
 pause;
 %%%%%%%%%%%%%%%
 psnr5=zeros(5,1);
 psnr5(1,1)=PSNR(Rt,XiCS1);psnr5(2,1)=PSNR(Rt,XiCS2);psnr5(3,1)=PSNR(Rt,XiCS5);psnr5(4,1)=PSNR(Rt,XiCS10);psnr5(5,1)=PSNR(Rt,XiCS20);
 shft=[1 2 5 10 20];
 figure;
 plot(shft,psnr5,'-.r*');
 xlabel('shift amount ');ylabel('PSNR value');
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 psnrCHn=zeros(5,1);
cod_h1n1=circshift(h1,[1 -1]);pnrCHn(1,1)=PSNR(h1,cod_h1n1);
cod_h1n2=circshift(h1,[2 -2]);pnrCHn(2,1)=PSNR(h1,cod_h1n2);
cod_h1n5=circshift(h1,[5 -5]);psnrCHn(3,1)=PSNR(h1,cod_h1n5);
cod_h1n10=circshift(h1,[10 -10]);psnrCHn(4,1)=PSNR(h1,cod_h1n10);
cod_h1n20=circshift(h1,[20 -20]);psnrCHn(5,1)=PSNR(h1,cod_h1n20);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
psnrCVn=zeros(5,1);
cod_v1n1=circshift(v1,[1 -1]);pnrCVn(1,1)=PSNR(v1,cod_v1n1);
cod_v1n2=circshift(v1,[2 -2]);pnrCVn(2,1)=PSNR(v1,cod_v1n2);
cod_v1n5=circshift(v1,[5 -5]);psnrCVn(3,1)=PSNR(v1,cod_v1n5);
cod_v1n10=circshift(v1,[10 -10]);psnrCVn(4,1)=PSNR(v1,cod_v1n10);
cod_v1n20=circshift(v1,[20 -20]);psnrCVn(5,1)=PSNR(v1,cod_v1n20);
psnrCDn=zeros(5,1);
cod_d1n1=circshift(d1,[1 -1]);pnrCDn(1,1)=PSNR(d1,cod_d1n1);
cod_d1n2=circshift(d1,[2 -2]);pnrCDn(2,1)=PSNR(d1,cod_d1n2);
cod_d1n5=circshift(d1,[5 -5]);psnrCDn(3,1)=PSNR(d1,cod_d1n5);
cod_d1n10=circshift(d1,[10 -10]);psnrCDn(4,1)=PSNR(d1,cod_d1n10);
cod_d1n20=circshift(d1,[20 -20]);psnrCDn(5,1)=PSNR(d1,cod_d1n20);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5

 XiCSn1=a1+cod_h1n1+cod_v1n1+cod_d1n1;
 figure;
 imshow(XiCSn1,[]);
 title(' shift by 1 without thresholding');
 pause;
  XiCSn2=a1+cod_h1n2+cod_v1n2+cod_d1n2;
 figure;
 imshow(XiCSn2,[]);
 title(' shift  by 2 without thresholding');
 pause;
XiCSn5=a1+cod_h1n5+cod_v1n5+cod_d1n5;
 figure;
 imshow(XiCSn5,[]);
 title(' shift by 5 without thresholding');
 pause;
XiCSn10=a1+cod_h1n10+cod_v1n10+cod_d1n10;
 figure;
 imshow(XiCSn10,[]);
 title('shift by  10 without thresholding');
 pause;
 XiCSn20=a1+cod_h1n20+cod_v1n20+cod_d1n20;
 figure;
 imshow(XiCSn20,[]);
 title('shift by 20 without thresholding');
 pause;
 %%%%%%%%%%%%%%%
 psnrn5=zeros(5,1);
 psnrn5(1,1)=PSNR(R,XiCSn1);psnrn5(2,1)=PSNR(R,XiCSn2);psnrn5(3,1)=PSNR(R,XiCSn5);psnrn5(4,1)=PSNR(R,XiCSn10);psnrn5(5,1)=PSNR(R,XiCSn20);
 shft=[1 2 5 10 20];
 figure;
 plot(shft,psnrn5,'-.r*');
 xlabel('shift amount ');ylabel('PSNR value for unthresholded one');
 %{
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[i j]=size(h1);
psnr1=zeros(4,1);
 hPercent=zeros(i,j);
 vPercent=zeros(i,j);
 dPercent=zeros(i,j);
 k=0;m=1;n=1;
 plc=1;
 for scl=2:5:17
     %th1=5;
 while(k<= 0.1*i*j)
  while(m<=i)
  while(n<=j)
%for m=1:i
   %for n= 1:j
        if h1(m,n)==max(h1(:))
             hPercent(m,n)=h1(m,n);
             h1(m,n)=0;
        %else
            %h1(m,n)=h1(m,n);
        end
        if v1(m,n)==max(v1(:))
             vPercent(m,n)=v1(m,n);
             v1(m,n)=0;
        %else
            %v1(m,n)=v1(m,n);
        end
        if d1(m,n)==max(d1(:))
             dPercent(m,n)=d1(m,n);
             d1(m,n)=0;
        %else
           % d1(m,n)=d1(m,n);
        end 
        n=n+1;
  end
   m=m+1;
  end
    k=k+1;
end
h1t=scl*hPercent;
v1t=scl*vPercent;
d1t=scl*dPercent;
Rc1=a1+h1t+v1t+d1t;
figure;
imshow(Rc1,[]);
title(sprintf('10 percent  and scale =%2.1f%',scl));
pause;
psnr1(plc,1)=PSNR(R,Rc1);
plc=plc+1;
 end
pause;
skl=[2 7 12 17];
plot(skl,psnr1(:,1),'-.r*');
xlabel('scale');
ylabel('psnr Value');
psnr2=zeros(4,1);
%{
for scl=2:5:17
     th1=10;
for m=1:i
    for n= 1:j
        if abs(h1(m,n))<th1
             h1(m,n)=0;
            if abs(v1(m,n))<th1
                v1(m,n)=0;
                if abs(d1(m,n))<th1
            d1(m,n)=0;
                end
            end
        end
    end
end
h1t=scl*h1;
v1t=scl*v1;
d1t=scl*d1;
Rc2=a1+h1t+v1t+d1t;
figure;
imshow(Rc2,[]);
psnr2(plc,1)=PSNR(R,Rc2);
title(sprintf('threshold 10  and scale =%2.1f%',scl));
pause;
plc=plc+1;
end
pause;
plot(skl,psnr2(5:end,1),'-.r*');
xlabel('scale');
ylabel('psnr by scale 10');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
psnr3=zeros(4,1);
for scl=2:5:17
     th1=20;
for m=1:i
    for n= 1:j
        if abs(h1(m,n))<th1
             h1(m,n)=0;
            if abs(v1(m,n))<th1
                v1(m,n)=0;
                if abs(d1(m,n))<th1
            d1(m,n)=0;
                end
            end
        end
    end
end
h1t=scl*h1;
v1t=scl*v1;
d1t=scl*d1;
Rc3=a1+h1t+v1t+d1t;
figure;
imshow(Rc3,[]);
psnr3(plc,1)=PSNR(R,Rc3);
title(sprintf('threshold 20  and scale =%2.1f%',scl));
pause;
plc=plc+1;
end
pause;
plot(skl,psnr3(9:end,1),'-.r*');
xlabel('scale');
ylabel('psnr by scale 20');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
psnrCH=zeros(5,1);
cod_h11=circshift(h1t,[1 -1]);pnrCH(1,1)=PSNR(h1t,cod_h11);
%figure;imshow(cod_h11,[]);title('shift by 1');pause;
cod_h12=circshift(h1t,[2 -2]);pnrCH(2,1)=PSNR(h1t,cod_h12);
%figure;imshow(cod_h12,[]);title('shift by 2');pause;
cod_h15=circshift(h1t,[5 -5]);psnrCH(3,1)=PSNR(h1t,cod_h15);
%figure;imshow(cod_h15,[]);title('shift by 5');pause;
cod_h110=circshift(h1t,[10 -10]);psnrCH(4,1)=PSNR(h1t,cod_h110);
%figure;imshow(cod_h110,[]);title('shift by 10');pause;
cod_h120=circshift(h1t,[20 -20]);psnrCH(5,1)=PSNR(h1t,cod_h120);
%figure;imshow(cod_h120,[]);title('shift by 20');pause;
%m=[1 2 5 10 20];
%figure ;plot(m,psnrCH,'-.r*');xlabel('Horizontal details shift right and bottom value');ylabel('PSNR value');
%pause;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
psnrCV=zeros(5,1);
cod_v11=circshift(v1t,[1 -1]);pnrCV(1,1)=PSNR(v1t,cod_v11);
cod_v12=circshift(v1t,[2 -2]);pnrCV(2,1)=PSNR(v1t,cod_v12);
cod_v15=circshift(v1t,[5 -5]);psnrCV(3,1)=PSNR(v1t,cod_v15);
cod_v110=circshift(v1t,[10 -10]);psnrCV(4,1)=PSNR(v1t,cod_v110);
cod_v120=circshift(v1t,[20 -20]);psnrCV(5,1)=PSNR(v1t,cod_v120);
%m=[1 2 5 10 20];
%figure ;plot(m,psnrCV,'-.r*');xlabel('vertical Details shift right and bottom value');ylabel('PSNR value');
%pause;
psnrCD=zeros(5,1);
cod_d11=circshift(d1t,[1 -1]);pnrCD(1,1)=PSNR(d1t,cod_d11);
cod_d12=circshift(d1t,[2 -2]);pnrCD(2,1)=PSNR(d1t,cod_d12);
cod_d15=circshift(d1t,[5 -5]);psnrCD(3,1)=PSNR(d1t,cod_d15);
cod_d110=circshift(d1t,[10 -10]);psnrCD(4,1)=PSNR(d1t,cod_d110);
cod_d120=circshift(d1t,[20 -20]);psnrCD(5,1)=PSNR(d1t,cod_d120);
%figure ;plot(m,psnrCD,'-.r*');xlabel('Diagonal details shift right and bottom value');ylabel('PSNR value');
%pause;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5

 XiCS1=a1+cod_h11+cod_v11+cod_d11;
 figure;
 imshow(XiCS1,[]);
 title(' shift by 1');
 pause;
  XiCS2=a1+cod_h12+cod_v12+cod_d12;
 figure;
 imshow(XiCS2,[]);
 title(' shift  by 2');
 pause;
XiCS5=a1+cod_h15+cod_v15+cod_d15;
 figure;
 imshow(XiCS5,[]);
 title(' shift by 5');
 pause;
XiCS10=a1+cod_h110+cod_v110+cod_d110;
 figure;
 imshow(XiCS10,[]);
 title('shift by  10');
 pause;
 XiCS20=a1+cod_h120+cod_v120+cod_d120;
 figure;
 imshow(XiCS20,[]);
 title('shift by 20');
 pause;
 %%%%%%%%%%%%%%%
 psnr5=zeros(5,1);
 psnr5(1,1)=PSNR(R,XiCS1);psnr5(2,1)=PSNR(R,XiCS2);psnr5(3,1)=PSNR(R,XiCS5);psnr5(4,1)=PSNR(R,XiCS10);psnr5(5,1)=PSNR(R,XiCS20);
 shft=[1 2 5 10 20];
 figure;
 plot(shft,psnr5,'-.r*');
 xlabel('shift amount ');ylabel('PSNR value');
%}
%}
 %{
psnr2=zeros(4,1);
for scl=2:5:17
     th1=10;
for m=1:i
    for n= 1:j
        if abs(h1(m,n))<th1
             h1(m,n)=0;
            if abs(v1(m,n))<th1
                v1(m,n)=0;
                if abs(d1(m,n))<th1
            d1(m,n)=0;
                end
            end
        end
    end
end
h1t=scl*h1;
v1t=scl*v1;
d1t=scl*d1;
Rc2=a1+h1t+v1t+d1t;
figure;
imshow(Rc2,[]);
psnr2(plc,1)=PSNR(R,Rc2);
title(sprintf('threshold 10  and scale =%2.1f%',scl));
pause;
plc=plc+1;
end
pause;
plot(skl,psnr2(5:end,1),'-.r*');
xlabel('scale');
ylabel('psnr by scale 10');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
psnr3=zeros(4,1);
for scl=2:5:17
     th1=20;
for m=1:i
    for n= 1:j
        if abs(h1(m,n))<th1
             h1(m,n)=0;
            if abs(v1(m,n))<th1
                v1(m,n)=0;
                if abs(d1(m,n))<th1
            d1(m,n)=0;
                end
            end
        end
    end
end
h1t=scl*h1;
v1t=scl*v1;
d1t=scl*d1;
Rc3=a1+h1t+v1t+d1t;
figure;
imshow(Rc3,[]);
psnr3(plc,1)=PSNR(R,Rc3);
title(sprintf('threshold 20  and scale =%2.1f%',scl));
pause;
plc=plc+1;
end
pause;
plot(skl,psnr3(9:end,1),'-.r*');
xlabel('scale');
ylabel('psnr by scale 20');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Rt=a1+h1t+v1t+d1t;
psnrCH=zeros(5,1);
cod_h11=circshift(h1t,[1 -1]);pnrCH(1,1)=PSNR(h1t,cod_h11);
cod_h12=circshift(h1t,[2 -2]);pnrCH(2,1)=PSNR(h1t,cod_h12);
cod_h15=circshift(h1t,[5 -5]);psnrCH(3,1)=PSNR(h1t,cod_h15);
cod_h110=circshift(h1t,[10 -10]);psnrCH(4,1)=PSNR(h1t,cod_h110);
cod_h120=circshift(h1t,[20 -20]);psnrCH(5,1)=PSNR(h1t,cod_h120);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
psnrCV=zeros(5,1);
cod_v11=circshift(v1t,[1 -1]);pnrCV(1,1)=PSNR(v1t,cod_v11);
cod_v12=circshift(v1t,[2 -2]);pnrCV(2,1)=PSNR(v1t,cod_v12);
cod_v15=circshift(v1t,[5 -5]);psnrCV(3,1)=PSNR(v1t,cod_v15);
cod_v110=circshift(v1t,[10 -10]);psnrCV(4,1)=PSNR(v1t,cod_v110);
cod_v120=circshift(v1t,[20 -20]);psnrCV(5,1)=PSNR(v1t,cod_v120);
psnrCD=zeros(5,1);
cod_d11=circshift(d1t,[1 -1]);pnrCD(1,1)=PSNR(d1t,cod_d11);
cod_d12=circshift(d1t,[2 -2]);pnrCD(2,1)=PSNR(d1t,cod_d12);
cod_d15=circshift(d1t,[5 -5]);psnrCD(3,1)=PSNR(d1t,cod_d15);
cod_d110=circshift(d1t,[10 -10]);psnrCD(4,1)=PSNR(d1t,cod_d110);
cod_d120=circshift(d1t,[20 -20]);psnrCD(5,1)=PSNR(d1t,cod_d120);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5

 XiCS1=a1+cod_h11+cod_v11+cod_d11;
 figure;
 imshow(XiCS1,[]);
 title(' shift by 1');
 pause;
  XiCS2=a1+cod_h12+cod_v12+cod_d12;
 figure;
 imshow(XiCS2,[]);
 title(' shift  by 2');
 pause;
XiCS5=a1+cod_h15+cod_v15+cod_d15;
 figure;
 imshow(XiCS5,[]);
 title(' shift by 5');
 pause;
XiCS10=a1+cod_h110+cod_v110+cod_d110;
 figure;
 imshow(XiCS10,[]);
 title('shift by  10');
 pause;
 XiCS20=a1+cod_h120+cod_v120+cod_d120;
 figure;
 imshow(XiCS20,[]);
 title('shift by 20');
 pause;
 %%%%%%%%%%%%%%%
 psnr5=zeros(5,1);
 psnr5(1,1)=PSNR(Rt,XiCS1);psnr5(2,1)=PSNR(Rt,XiCS2);psnr5(3,1)=PSNR(Rt,XiCS5);psnr5(4,1)=PSNR(Rt,XiCS10);psnr5(5,1)=PSNR(Rt,XiCS20);
 shft=[1 2 5 10 20];
 figure;
 plot(shft,psnr5,'-.r*');
 xlabel('shift amount ');ylabel('PSNR value');
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 psnrCHn=zeros(5,1);
cod_h1n1=circshift(h1,[1 -1]);pnrCHn(1,1)=PSNR(h1,cod_h1n1);
cod_h1n2=circshift(h1,[2 -2]);pnrCHn(2,1)=PSNR(h1,cod_h1n2);
cod_h1n5=circshift(h1,[5 -5]);psnrCHn(3,1)=PSNR(h1,cod_h1n5);
cod_h1n10=circshift(h1,[10 -10]);psnrCHn(4,1)=PSNR(h1,cod_h1n10);
cod_h1n20=circshift(h1,[20 -20]);psnrCHn(5,1)=PSNR(h1,cod_h1n20);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
psnrCVn=zeros(5,1);
cod_v1n1=circshift(v1,[1 -1]);pnrCVn(1,1)=PSNR(v1,cod_v1n1);
cod_v1n2=circshift(v1,[2 -2]);pnrCVn(2,1)=PSNR(v1,cod_v1n2);
cod_v1n5=circshift(v1,[5 -5]);psnrCVn(3,1)=PSNR(v1,cod_v1n5);
cod_v1n10=circshift(v1,[10 -10]);psnrCVn(4,1)=PSNR(v1,cod_v1n10);
cod_v1n20=circshift(v1,[20 -20]);psnrCVn(5,1)=PSNR(v1,cod_v1n20);
psnrCDn=zeros(5,1);
cod_d1n1=circshift(d1,[1 -1]);pnrCDn(1,1)=PSNR(d1,cod_d1n1);
cod_d1n2=circshift(d1,[2 -2]);pnrCDn(2,1)=PSNR(d1,cod_d1n2);
cod_d1n5=circshift(d1,[5 -5]);psnrCDn(3,1)=PSNR(d1,cod_d1n5);
cod_d1n10=circshift(d1,[10 -10]);psnrCDn(4,1)=PSNR(d1,cod_d1n10);
cod_d1n20=circshift(d1,[20 -20]);psnrCDn(5,1)=PSNR(d1,cod_d1n20);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5

 XiCSn1=a1+cod_h1n1+cod_v1n1+cod_d1n1;
 figure;
 imshow(XiCSn1,[]);
 title(' shift by 1 without thresholding');
 pause;
  XiCSn2=a1+cod_h1n2+cod_v1n2+cod_d1n2;
 figure;
 imshow(XiCSn2,[]);
 title(' shift  by 2 without thresholding');
 pause;
XiCSn5=a1+cod_h1n5+cod_v1n5+cod_d1n5;
 figure;
 imshow(XiCSn5,[]);
 title(' shift by 5 without thresholding');
 pause;
XiCSn10=a1+cod_h1n10+cod_v1n10+cod_d1n10;
 figure;
 imshow(XiCSn10,[]);
 title('shift by  10 without thresholding');
 pause;
 XiCSn20=a1+cod_h1n20+cod_v1n20+cod_d1n20;
 figure;
 imshow(XiCSn20,[]);
 title('shift by 20 without thresholding');
 pause;
 %%%%%%%%%%%%%%%
 psnrn5=zeros(5,1);
 psnrn5(1,1)=PSNR(R,XiCSn1);psnrn5(2,1)=PSNR(R,XiCSn2);psnrn5(3,1)=PSNR(R,XiCSn5);psnrn5(4,1)=PSNR(R,XiCSn10);psnrn5(5,1)=PSNR(R,XiCSn20);
 shft=[1 2 5 10 20];
 figure;
 plot(shft,psnrn5,'-.r*');
 xlabel('shift amount ');ylabel('PSNR value for unthresholded one');
%}
 
 