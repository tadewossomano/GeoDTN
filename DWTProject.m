clc
%[file path]=uigetfile('*.*');
a=imread('lena.jpg');
sA=size(a);
figure;imshow(a)
pause;
[ca ch cv cd]=dwt2(a,'haar');
%figure;imshow([(ca/512),ch;cv,cd])
%figure;
%subplot(2,2,1);imshow(ca/512);title('Approximation')
%subplot(2,2,2);imshow(ch);title('Horizontal')
%subplot(2,2,3);imshow(cv);title('Vertical')
%subplot(2,2,4);imshow(cd);title('Diagonal')
%pause; 
%first reconstruct aion
a1=idwt2(ca,ch,cv,cd,'haar',sA);%lookover
figure;
imshow(a1);
title('first reconstructed image');
pause;
close all;
[row col channel]=size(ch);
for i=1:row
    for j=1:col
    if ch(i,j,:)>0
        ch(i,j,:)=ch(i,j,:)*2;
    else
        ch(i,j,:)=0;
    end
    if cv(i,j,:)>0
        cv(i,j,:)=cv(i,j,:)*2;
    else
        cv(i,j,:)=0;
    end
    if cd(i,j,:)>0
        cd(i,j,:)=cd(i,j,:)*2;
    else
        cd(i,j,:)=0;
    end
    end
end
%2nd reconstruction
a2=idwt2(ca,ch,cv,cd,'haar',Size);
imshow(a2);
title('2nd reconstructed image');
figure;


subplot(2,2,1);imshow(ca/512);title('Approximation')
subplot(2,2,2);imshow(ch);title('Horizontal2')
subplot(2,2,3);imshow(cv);title('Vertical2')
subplot(2,2,4);imshow(cd);title('Diagonal2')