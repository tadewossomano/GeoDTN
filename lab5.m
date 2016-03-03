clear all,close all;
clc;
clearvars;
close all;
workspace;
fontSize = 10;
a10p=zeros(3);
a01p=zeros(3);
a11p=zeros(3);
img00=zeros(3);
img10=zeros(3);
img01=zeros(3);
img11=zeros(3);
predictionMatrix=zeros(3,3,3);
img=imread('lena.jpg');
[i,j,C]=size(img);
e=zeros(i,j,C);  %Prediction Error
correlation10=zeros(i,j,C);
correlation00=zeros(i,j,C);
correlation01=zeros(i,j,C);
correlation11=zeros(i,j,C);
imgR01=zeros(i,j,C);
imgR10=zeros(i,j,C);
imgR11=zeros(i,j,C);
imgprediction=zeros(512,512,3);
imgVector=zeros(1,3,3);
imshow(img);
title('original');
c = waitforbuttonpress ;
for k=2:1:i-1
    for q=2:1:j-1
      correlation10(k,q,1)=img(k-1,q,1)*img(k,q,1);
      correlation10(k,q,2)=img(k-1,q,2)*img(k,q,2);
      correlation10(k,q,3)=img(k-1,q,3)*img(k,q,3);
    end
end
imshow(correlation10(:,:,:));
title('R(1,0)');
c = waitforbuttonpress ;
for k=2:1:i-1
    for q=2:1:j-1
        correlation11(k,q,1)=img(k-1,q-1,1)*img(k,q,1); 
        correlation11(k,q,2)=img(k-1,q-1,2)*img(k,q,2);   %Autocorrelation
        correlation11(k,q,3)=img(k-1,q-1,3)*img(k,q,3);
    end
end
imshow(correlation11(:,:,:));
title('R(1,1)');
c = waitforbuttonpress ;
for k=2:1:i-1
    for q=2:1:j-1
        correlation01(k,q,1)=mod(img(k,q-1,1)*img(k,q,1),255); 
        correlation01(k,q,2)=mod(img(k,q-1,2)*img(k,q,2),255);
        correlation01(k,q,3)=mod(img(k,q-1,3)*img(k,q,3),255); %Autocorrelation
    end
end
imshow(correlation01(:,:,:));
title('R(0,1)');
c = waitforbuttonpress ;
for k=2:1:i-1
    for q=2:1:j-1
       correlation00(k,q,1)=img(k-1,q-1,1)*img(k-1,q-1,1); 
        correlation00(k,q,2)=img(k-1,q-1,2)*img(k-1,q-1,2);
        correlation00(k,q,3)=img(k-1,q-1,3)*img(k-1,q-1,3);%Autocorrelation
    end
end
imshow(correlation00(:,:,:));
title('R(0,0)');
c = waitforbuttonpress ;
%%
%solving optimal predictor coefficients
%the_mean=zeros(3);
the_mean = mean(img(:,:,:));
for x=2:i
     for y=2:j
    
    img00(1)=sum(img(x,y,1));%+img00(1);
    img00(2)=sum(img(x,y,2));%+img00(2);
    img00(3)=sum(img(x,y,3));%+img00(3);
    img10(1)=sum(img(x-1,y,1));%+img10(1);
    img10(2)=sum(img(x-1,y,2));%+img10(2);
    img10(3)=sum(img(x-1,y,3));%+img10(3);
    img01(1)=sum(img(x,y-1,1));%+img01(1);
    img01(2)=sum(img(x,y-1,2));%+img01(2);
    img01(3)=sum(img(x,y-1,3));%+img01(3);
    img11(1)=sum(img(x-1,y-1,1));%+img11(1);
    img11(2)=sum(img(x-1,y-1,2));%+img11(2);
    img11(3)=sum(img(x-1,y-1,3));%+img11(3);
     end
end
%end

img00(1)=img00(1)/((i-1)*(j-1));
img00(2)=img00(2)/((i-1)*(j-1));
img00(3)=img00(3)/((i-1)*(j-1));
img10(1)=img10(1)/((i-1)*(j-1));
img10(2)=img10(2)/((i-1)*(j-1));
img10(3)=img10(3)/((i-1)*(j-1));
img01(1)=img01(1)/((i-1)*(j-1));
img01(2)=img01(2)/((i-1)*(j-1));
img01(3)=img01(3)/((i-1)*(j-1));
img11(1)=img11(1)/((i-1)*(j-1));
img11(2)=img11(2)/((i-1)*(j-1));
img11(3)=img11(3)/((i-1)*(j-1));
predictionMatrix(:,:,1)=[img10(1)^2 img10(1)*img01(1) img10(1)*img11(1);img10(1)*img01(1) img01(1)^2 img11(1)*img01(1);img10(1)*img11(1) img01(1)*img11(1) img11(1)^2]';
predictionMatrix(:,:,2)=[img10(2)^2 img10(2)*img01(2) img10(2)*img11(2);img10(2)*img01(2) img01(2)^2 img11(2)*img01(2);img10(2)*img11(2) img01(2)*img11(2) img11(2)^2]';
predictionMatrix(:,:,3)=[img10(3)^2 img10(3)*img01(3) img10(3)*img11(3);img10(3)*img01(3) img01(3)^2 img11(3)*img01(3);img10(3)*img11(3) img01(3)*img11(3) img11(3)^2]';
imgVector(1,:,1)=[img00(1)*img10(1) img00(1)*img01(1) img00(1)*img11(1)];
imgVector(1,:,2)=[img00(2)*img10(2) img00(2)*img01(2) img00(2)*img11(2)];
imgVector(1,:,3)=[img00(3)*img10(3) img00(3)*img01(3) img00(3)*img11(3)]; 
%Coefficients of Predictor per channel
img1=imgVector(1,:,1)*inv(predictionMatrix(:,:,1));  %channel 0ne
img1(1)=a10p(1) ;
img1(2)=a01p(1);
img1(3)=a11p(1);%[a10p(1,1,1) a01p(1,1,1) a11p(1,1,1)]=linsolve(predictionMatrix(:,:,1),img(1,1,1));
%syms  a10p(1,1,2) a01p(1,1,2) a11p(1,1,2) ; 
img2=imgVector(1,:,2)*inv(predictionMatrix(:,:,2));              %channel two
img2(1)=a10p(2);
img2(2)=a01p(2);
img2(3)=a11p(2);
%syms  a10p(1,1,1) a01p(1,1,1) a11p(1,1,3) ; 
 img3=imgVector(1,:,3)*inv(predictionMatrix(:,:,3));%channel three
 img3(1)=a10p(3);
 img3(2)=a01p(3);
 img3(3)=a11p(3);
 a10=(a10p(1)+a10p(2)+a10p(3))/3;
 a01=(a01p(1)+a01p(2)+a01p(3))/3;
 a11=(a11p(1)+a11p(2)+a11p(3))/3;

 for x=2:i
      for y=2:j
       imgprediction(x,y,1)=a10*img(x-1,y,1)+a01*img(x,y-1,1)+a11*img(x-1,y-1,1);
       imgprediction(x,y,2)=a10*img(x-1,y,2)+a01*img(x,y-1,2)+a11*img(x-1,y-1,2);
       imgprediction(x,y,3)=a10*img(x-1,y,3)+a01*img(x,y-1,3)+a11*img(x-1,y-1,3);
       e(x,y,1)=img(x,y,1)-(a10*img(x-1,y,1)+a01*img(x,y-1,1)+a11*img(x-1,y-1,1));
       e(x,y,2)=img(x,y,2)-(a10*img(x-1,y,2)+a01*img(x,y-1,2)+a11*img(x-1,y-1,2));
       e(x,y,3)=img(x,y,3)-(a10*img(x-1,y,3)+a01*img(x,y-1,3)+a11*img(x-1,y-1,3));
     end
 end
imshow(imgprediction(:,:,:));
title('Optimally Predicted image')
c = waitforbuttonpress ;
imshow(e(:,:,:));
title('Prediction error ')
%%
%Prediction with given coefficients
 a10Given=1/3;
 a01Given=1/3;
 a11Given=1/3 ;
 imgWithGivenCoefficients=imread('lena.jpg');
[l,m,n]=size(imgWithGivenCoefficients);
e2=zeros(l,m,n);
imgprediction2=zeros(l,m,n);
for x=2:l
    for y=2:m
imgprediction2(x,y,:)=a10Given*imgWithGivenCoefficients(x-1,y,:)+a01Given*imgWithGivenCoefficients(x,y-1,:)+a11Given*imgWithGivenCoefficients(x-1,y-1,:);
e2(x,y,1)=imgWithGivenCoefficients(x,y,1)-(imgprediction2(x,y,1));   %(aa10*img(x-1,y,:)+aa01*img(x,y-1,:)+aa11*img(x-1,y-1,:));
e2(x,y,2)=imgWithGivenCoefficients(x,y,2)-(imgprediction2(x,y,2)); 
e2(x,y,3)=imgWithGivenCoefficients(x,y,3)-(imgprediction2(x,y,3)); 
%e2(x,y,:)=imgWithGivenCoefficients(x,y,:)-(a10Given*img(x-1,y,:)+a01Given*img(x,y-1,:)+a11Given*img(x-1,y-1,:));
    end
end
imshow(imgprediction2(:,:,:));
title('Predicted image')
c = waitforbuttonpress ;
imshow(e2(:,:,:));
title('prediction error');
%%
c = waitforbuttonpress ;
sz=[512,512];
e2=zeros(512,512);
imgprediction3=zeros(512,512);
[x,y]= meshgrid(linspace(1,10,sz(2)),linspace(1,10,sz(1)));
signal=sin(2*pi*60*x).*sin(2*pi*50*y);
img2=(signal+1);
imshow(img2);
title('synthetic image')
c = waitforbuttonpress ;
for x=2:i
    for y=2:j
e2(x,y)=img2(x,y)-(a10*img2(x-1,y)+a01*img2(x,y-1)+a11*img2(x-1,y-1));
imgprediction3(x,y)=a10*img2(x-1,y)+a01*img2(x,y-1)+a11*img2(x-1,y-1);

    end
end
imshow(imgprediction3(:,:));
title('prediction for synthetic image')
c = waitforbuttonpress ;
imshow(e2(:,:));

