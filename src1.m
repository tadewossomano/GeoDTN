% 22/10/2013 - Lab. experience n.4

clear all;close all;

% ==============================================
%           point 1 - Image Sampling
% ==============================================

[U,V]=ndgrid(-15:0.05:15);
u = U(:,1)';                      
v = V(1,:);
[X,Y]=ndgrid(-6:0.05:6,-6:0.05:6);
x = X(:,1)';
y = Y(1,:);
syntheticImageOriginal = 255*rect4(X/2).*rect4(Y/6);
syntheticImage = syntheticImageOriginal;
%syntheticImage = uint8(syntheticImage);
figure, imshow(syntheticImage);
syntheticImage = double(syntheticImage);
synthetic_image = MCF_FT2(syntheticImage, u, v, x, y);
% "Subsample" the image by a factor of 4 in the vertical direction by 
% multiplying it by a sampling matrix made of zeros and ones.
% Compute its transform and display it.

syntheticImageSUBVertic4 = zeros(size(syntheticImage));
syntheticImageSUBVertic4(:,1:4:end)=1;

syntheticImage = syntheticImage.*syntheticImageSUBVertic4;

syntheticImage = uint8(syntheticImage);
figure, imshow(syntheticImage);
syntheticImage = double(syntheticImage);
 
synthetic_imageSUBVertic4 = mcs_ft2(syntheticImage, u, v, x, y);
figure, surf(u,v,abs(synthetic_imageSUBVertic4)),xlabel('u'),ylabel('v'),title('transform syntheticImage'),shading interp;


% Subsample the signal by a factor of 4 in both horizontal and vertical 
% directions. Compute the transform and display it.

syntheticImageSUBVertHor4 = zeros(size(syntheticImage));
syntheticImageSUBVertHor4(1:4:end,1:4:end)=1;

syntheticImage = syntheticImageOriginal.*syntheticImageSUBVertHor4;

syntheticImage = uint8(syntheticImage);
figure, imshow(syntheticImage);
syntheticImage = double(syntheticImage);
 
spettro_imageSUBVertic4 = mcs_ft2(syntheticImage, u, v, x, y);
figure, surf(u,v,abs(synthetic_imageSUBVertic4)),xlabel('u'),ylabel('v'),title('Subsample syntheticImage'),shading interp;


% Repeat the experiment using a quincunx grid.
quincunxGrid = syntheticImageSUBVertHor4;
quincunxGrid(3:4:end,3:4:end)=1;

syntheticImage = syntheticImageOriginal.*quincunxGrid;

figure, imshow(quincunxGrid);

syntheticImage = uint8(syntheticImage);
figure, imshow(syntheticImage);
syntheticImage = double(syntheticImage);

synthetic_imageQuinc = MCS_FT2(syntheticImage, u, v, x, y);
figure, surf(u,v,abs(synthetic_imageQuinc)),xlabel('u'),ylabel('v'),title(' imageQuincx'),shading interp;

pause;
close all;


%% ==============================================
%           point 2 - 3d cylindric signals
% ==============================================

time=1:1:100;
f0=6;
for k=1:length(time)
    video(:,:,k) = sin(2*pi*f0*(X-k/20));
    
end

synthetic_video = fftn(video);
synthetic_video = fftshift(synthetic_video);

a = ceil(length(y)/2);
A = reshape(synthetic_video(:,a,:),length(x),length(time));
surf(abs(A)),shading interp;
pause;

for i=1:length(x)
    surf(abs(synthetic_video(:,:,i))),shading interp,axis([0 length(x) 0 length(y) 0 3*10^6]);
    pause;
end






pause;
close all;






