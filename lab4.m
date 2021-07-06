% 22/10/2013 - Lab. experience n.4

clear all;close all;

% ==============================================
%           point 1 - Image Sampling
% ==============================================
[U,V]=ndgrid(-15:0.05:15);
u = U(:,1)';                      
v = V(1,:);
[X,Y]=ndgrid(-6:0.05:6);
x = X(:,1)';
y = Y(1,:);

syntheticImageOriginal = 255*rect(X/2).*rect(Y/6);
syntheticImage = syntheticImageOriginal;
%figure, surf(X,Y,abs(syntheticImage)),xlabel('x'),ylabel('y'),title('syntheticImage'),axis([-6 6 -6 6 0 256]),shading interp;

syntheticImage = uint8(syntheticImage);
figure, imshow(syntheticImage);
syntheticImage = double(syntheticImage);

spectrum_image = MCS_FT2(syntheticImage, u, v, x, y);
%%
e = waitforbuttonpress ;
fftA=fft2(syntheticImage);
figure, imshow(fftA);
e = waitforbuttonpress ;
figure,imagesc(abs(fftshift(fftA)));
e = waitforbuttonpress ;
imagesc(log(abs(fftshift(fftA))));
[Height,Width,Depth] = size(syntheticImage);
if Depth == 1
f = syntheticImage;
else
f = syntheticImage(:,:,1);
end
% downsample by a factor of M, no prefiltering
M = 4;
f1 = f(1:M:Height,1:M:Width);
figure,imshow(f1), title('Downsampled by  num2str 4 :No prefiltering')
f1 = imresize(f1,2);%reconstruct to full size
figure,imshow(f1);
title('Reconstructed from downsampled image: No prefiltering')
% downsample by a factor of M, after prefiltering
% use a gaussian lowpass filter
f = imfilter(f,fspecial('gaussian',7,2.5));
f1 = f(1:M:Height,1:M:Width);
figure,imshow(f1), title('[Downsampled by  num2str(M)  afterprefiltering]')
%f1 = imresize(f1);
figure,imshow(f1)
title('Reconstructed from downsampled image: with prefiltering');
e = waitforbuttonpress ;
%%
%Quincunx sampling
%{
M = 256; N = 256;
f2 = zeros(241,241);
g = uint8(zeros(M+N,M+N));
q=[2 0;1 1]';
for n1=1:size(X)
    for n2=1:size(Y)
        t1=q(1,1)*n1+q(1,2)*n2;
        t2=q(2,1)*n1+q(2,2);
        g(520-t1,256+t2) = f2(n1,n2);
    end
end
figure,imshow(g), title('Quincunx grid')
        %}
%%
img = syntheticImage;%double(img);              %# Convert the image to type double
[nRows,nCols] = size(img);      %# Get the image size
[x,y] = meshgrid(1:nRows,1:nCols);  %# Create coordinate values for the pixels
coords = [x(:)'; y(:)'];            %# Collect the coordinates into one matrix
shearMatrix = [1 0.2; 0 1];         %# Create a shear matrix
newCoords = shearMatrix*coords;     %# Apply the shear to the coordinates
newImage = interp2(img,...             %# Interpolate the image values
                   newCoords(1,:),...  %#   at the new x coordinates
                   newCoords(2,:),...  %#   and the new y coordinates
                   'linear',...        %#   using linear interpolation
                   0);                 %#   and 0 for pixels outside the image
newImage = reshape(newImage,nRows,nCols);  %# Reshape the image data
newImage = uint8(newImage);                %# Convert the image to type uint8
figure,imshow(newImage);
e = waitforbuttonpress ;
%%
img = syntheticImage;%double(img);              %# Convert the image to type double
[nRows,nCols] = size(img);      %# Get the image size
[x,y] = meshgrid(1:nRows,1:nCols);  %# Create coordinate values for the pixels
coords = [x(:)'; y(:)'];            %# Collect the coordinates into one matrix
shearMatrix = [2 1; 0 1];         %# Create a shear matrix
newCoords = shearMatrix*coords;     %# Apply the shear to the coordinates
newImage = interp2(img,...             %# Interpolate the image values
                   newCoords(1,:),...  %#   at the new x coordinates
                   newCoords(2,:),...  %#   and the new y coordinates
                   'linear',...        %#   using linear interpolation
                   0);                 %#   and 0 for pixels outside the image
newImage = reshape(newImage,nRows,nCols);  %# Reshape the image data
newImage = uint8(newImage);                %# Convert the image to type uint8
figure,imshow(newImage);
%%
%3D synthetic signal
time=1:1:100;
f0=6;
%figure;
F(20) = struct('cdata',[],'colormap',[]);  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%55
for k=1:length(time)
    video(:,:,k) = sin(2*pi*f0*(X-k/20));
    surf(x,y,video(:,:,k)),xlabel('x'),ylabel('y'),title('video - al k-istante'),shading interp;%,axis([-6 6 -6 6 0 1]);
    F(k) = getframe;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
    %pause;
end

spectrum_video = fftn(video);
spectrum_video = fftshift(spectrum_video);

a = ceil(length(y)/2);
A = reshape(spectrum_video(:,a,:),length(x),length(time));
surf(abs(A)),shading interp;
pause;
for i=1:length(x)
    surf(abs(spectrum_video(:,:,i))),shading interp,axis([0 length(x) 0 length(y) 0 3*10^6]);
    pause;
end

