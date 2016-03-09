% Example3 5.m
% Karhunen-Loeve Transform of an image
%
N = 8; % N x N is the transform size
%{
A = imread(’cameraman.tif’);
[Height,Width,Depth] = size(A);
f = double(A(:,:,1));
%}
A = imread('lena.jpg');
Height = 256;
Width = 256;
f = double(A(Height,Width,1));% cropped image
%
b = zeros(N,N);
R = zeros(N,N);
Meanfc = zeros(1,N);% mean vector along column dimension
Meanfr = zeros(1,N);% mean vector along row dimension
% % compute the mean N-vectors along column & row dimensions
for n = 1:Width-N
    for k = 1:N
           Meanfc(k) = Meanfc(k) + sum(f(:,n+k-1));
           Meanfr(k) = Meanfr(k) + sum(f(n+k-1,:),2);
   end
end
Meanfc = floor(Meanfc/(Height*Width/N));
Meanfr = floor(Meanfr/(Height*Width/N));
% calculate the N x N covariance matrix of N-vectors
% along column dimension
for m = 1:Height
for n = 1:N:Width
    b = (f(m,n:n+N-1)-Meanfc)'*(f(m,n:n+N-1)-Meanfc);
R = R + b;
end
end
R = R/max(R(:));
[EVc,Evalc] = eig(R);% eigen matrix of R
% reorder the covariance matrix in descending order of
% eigen values
EVc = EVc(:,N:-1:1);
EVc = EVc(N:-1:1,:);
%
% calculate the N x N covariance matrix of N-vectors
% along rows
R(:,:) = 0;
for n = 1:Width
for m = 1:N:Height
b = (f(m:m+N-1,n)-Meanfr')*(f(m:m+N-1,n)-Meanfr')';
R = R + b;
end
end
R = R/max(R(:));
[EVr,Evalr] = eig(R);% eigen matrix of R
% reorder the covariance matrix in descending order of
% eigen values
EVr = EVr(:,N:-1:1);
EVr = EVr(N:-1:1,:);
%
% Compute basis images and display
X = ones(192,192) * 16; % inscribe each N x N submatrix into X
T2 = zeros(N*N,N*N);
for k = 0:N-1
rIndx = k*24 + 1;
rInd = k*N + 1;
for l = 0:N-1
cIndx = l*24 +1;
cInd = l*N +1;
y = EVr(:,k+1) * EVc(:,l+1)';
T = y;
T2(rInd:rInd+N-1,cInd:cInd+N-1) = y;
if k == 0
T = T/max(T(:))*255;
else
T = (T-min(T(:)))/(max(T(:))-min(T(:)))*255;
end
T1 = imresize(T,[16 16],'bicubic'); % expand matrix
% to 2N x 2N
X(rIndx+3:rIndx+18,cIndx+3:cIndx+18) = T1;
end
end
figure,imshow(X,[]),title([num2str(N) 'x' num2str(N) ' basis images for KLT'])
%
% compute mse due to basis restriction
x1 = zeros(N,N);
x2 = zeros(Height,Width);
mse = zeros(N,N);
for m = 0:N-1 % take each basis image along rows
mInd = m*N + 1;
for n = 0:N-1 % take each basis image along columns
nInd = n*N + 1;
for r = 1:N:Height % take N rows at a time
  for c = 1:N:Width % take N columns at a time
       x1 = EVr'*double( f(r:r+N-1,c:c+N-1))*EVc;
       sum1 = x2(r:r+N-1,c:c+N-1);
       x2(r:r+N-1,c:c+N-1) = sum1 +...
       x1(m+1,n+1) * T2(mInd:mInd+N-1,nInd:nInd+N-1);
  end
end
if(m == 0 && n == 0) || (m == 1 && n == 4)
figure,imshow(x2,[])
title(['No. of basis images used = ' num2str(m*N+n+1)])
end
mse(m+1,n+1) = (std2(double(f) - x2)) ^2;
end
end
figure,imshow(x2,[])
%
figure,plot(0:N^2-1,[mse(1,:) mse(2,:) mse(3,:) mse(4,:) mse(5,:) mse(6,:) mse(7,:) mse(8,:)],'k:','LineWidth',2)
xlabel(' # of basis images used')
ylabel('MSE')
                 %title('MSE Vs basis images for KLT')