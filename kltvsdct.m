% Program to compress with KL Transform and compare with DCT


%Clearing memory and command window
clc;clear all;close all;

%  KL transform of image.
im=imread('lena.jpg');
im=rgb2gray(im);
x = double(im)/255;               %convert to double and normalize
y11=reshape(x(1:8,1:8),64,1);
y12=reshape(x(1:8,9:16),64,1);
y21=reshape(x(9:16,1:8),64,1);
y22=reshape(x(9:16,9:16),64,1);
x=[y11,y12,y21,y22];
%Calculate the average
figure;
subplot(2,4,1),imshow(im),title('ori');
avrgx = mean(x')';
imsize = size(im); 
dct_mat=dctmtx(16);  %DCT MATRIX for comparison
im=im2double(im);    % to match data type
trans_mat=dct_mat*im*dct_mat';% image transfomed
% Creating masks for various commpression ratio
mask1=zeros(16);
mask1(1:4,1:4)=1;
mask2=zeros(16);
mask2(1:8,1:8)=1;
mask3=zeros(16);
mask3(1:12,1:12)=1;
dct1=mask1.*trans_mat;
dct2=mask2.*trans_mat;
dct3=mask3.*trans_mat;
% ***** PLOTING DCT VALUES  ****** %
subplot(2,4,6),imshow(dct_mat'*dct1*dct_mat),title('dct 1/4');
subplot(2,4,7),imshow(dct_mat'*dct2*dct_mat),title('dct 2/4');
subplot(2,4,8),imshow(dct_mat'*dct3*dct_mat),title('dct 3/4');

for i=1:1:4
    x(:,i) = x(:,i) - avrgx; % substruct the average
end;

cov_mat = x'*x;
[V,D] = eig(cov_mat);         %eigen values of cov matrix
V = x*V*(abs(D))^-0.5;               
KLC =  x'*V;

eigen_values = sort(diag(D,0));% sorting eigen values to remove 
                               % least eigen vector for compressing
% one eigen vector removed
for i=1:1:4
    if D(i,i)==eigen_values(1)
        comV=V;
        comV(:,i)=0;
        reconst = comV*KLC';
        y11=reshape(reconst(:,1),8,8);
        y12=reshape(reconst(:,2),8,8);
        y21=reshape(reconst(:,3),8,8);
        y22=reshape(reconst(:,4),8,8);
        re_img=[y11,y12;y21,y22];
        subplot(2,4,4),imshow(re_img),title('KL 3/4');
    end
end
% second eigen vector removed
for i=1:1:4
        if D(i,i)==eigen_values(2)  
         comV(:,i)=0;
         reconst = comV*KLC';
         y11=reshape(reconst(:,1),8,8);
         y12=reshape(reconst(:,2),8,8);
         y21=reshape(reconst(:,3),8,8);
         y22=reshape(reconst(:,4),8,8);
         re_img=[y11,y12;y21,y22];
         subplot(2,4,3),imshow(re_img),title('KL 2/4');
        end
end
% Third eigen vector removed
for i=1:1:4
             if D(i,i)==eigen_values(3)  
             comV(:,i)=0;
             reconst = comV*KLC';
             y11=reshape(reconst(:,1),8,8);
             y12=reshape(reconst(:,2),8,8);
             y21=reshape(reconst(:,3),8,8);
             y22=reshape(reconst(:,4),8,8);
             re_img=[y11,y12;y21,y22];
             subplot(2,4,2),imshow(re_img),title('KL 1/4');
             end
end