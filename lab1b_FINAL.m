%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% MULTIMEDIA COMMUNICATION SERVICES
% LAB n. 1b
%
%%%%%%%%%%%%%%%%%%%%%%%%%%


%% 1- Contrast Sensitivity Function

close all;
clear all;
rows=512;
cols=1024;

%-----Grayscale Sensitivity-----%

for i=1:rows
    for j=1:cols
        image(i,j) = (128/(0.5*i))*(sin(0.5*exp(j/150))+1)*((i/600)^3);  
    end
end
    
figure(1);
imshow(image);
title('Increasing Frequency Sinusoidal Function - GRAYSCALE');
c = waitforbuttonpress ;
%----Contrast Sensitivity Function----%

f=0:1:70;   % cycles per degree (CPD), which measures an angular resolution (spatial resolution), or how
            % much an eye can differentiate one object from another in terms of visual angles. Resolution 
            % in CPD can be measured by bar charts of different numbers of white/black stripe cycles. For 
            % example, if each pattern is 1.75 cm wide and is placed at 1 m distance from the eye, it will 
            % subtend an angle of 1 degree, so the number of white/black bar pairs on the pattern will be 
            % a measure of the cycles per degree of that pattern. The highest such number that the eye can 
            % resolve as stripes, or distinguish from a grey block, is then the measurement of visual 
            % acuity of the eye.
           
z=2.6*(0.0192+0.114.*f).*exp(-(0.114.*f).^1.1);

figure(2)
plot(f,z); 
title('Contrast Sensitivity Function'); 
xlabel('Spatial Resolution (Cycles per Degree - CPD) '); ylabel('Z(CPD)');
c = waitforbuttonpress ;


%-----Colors Sensitivity RGB-----%

% Red Component
my_image1(512,1024,3)=0; %initialize the image
my_image1(:,:,1)=image;
figure(3);
imshow(my_image1);
title('Increasing Frequency Sinusoidal Function - RED');
c = waitforbuttonpress ;
% Green Component
my_image2(512,1024,3)=0; %initialize the image
my_image2(:,:,2)=image;
figure(4);
imshow(my_image2);
title('Increasing Frequency Sinusoidal Function - GREEN');
c = waitforbuttonpress ;
% Blue Component
my_image3(512,1024,3)=0; %initialize the image
my_image3(:,:,3)=image;
figure(5);
imshow(my_image3);
title('Increasing Frequency Sinusoidal Function - BLUE');
c = waitforbuttonpress ;
%-----Colors Sensitivity YCBCR-----%

% Image Creation
result(512,1024,3)=0;
rgb(512,1024,3)=0;
rgb(:,:,1)= image;
rgb(:,:,2)= image;
rgb(:,:,3)= image;
ycbcr = rgb2ycbcr(rgb);

% Y Component
Y = ycbcr(:,:,1);
Cb = mean(mean(ycbcr(:,:,2)));
Cr = mean(mean(ycbcr(:,:,3)));

result(:,:,1)= Y;
result(:,:,2)= Cb;
result(:,:,3)= Cr;
imageY = ycbcr2rgb(result);

figure(6);
imshow(imageY);
title('Increasing Frequency Sinusoidal Function - Y');
c = waitforbuttonpress ;
% Cb Component
Y = mean(mean(ycbcr(:,:,1)));
Cb = (ycbcr(:,:,2));
Cr = mean(mean(ycbcr(:,:,3)));

result(:,:,1)= Y;
result(:,:,2)= Cb;
result(:,:,3)= Cr;
imageCb = ycbcr2rgb(result);

figure(7);
imshow(imageCb);
title('Increasing Frequency Sinusoidal Function - Cb');
c = waitforbuttonpress ;
% Cr Component
Y = mean(mean(ycbcr(:,:,1)));
Cb = mean(mean(ycbcr(:,:,2)));
Cr = ycbcr(:,:,3);

result(:,:,1)= Y;
result(:,:,2)= Cb;
result(:,:,3)= Cr;
imageCr = ycbcr2rgb(result);

figure(8);
imshow(imageCr);
title('Increasing Frequency Sinusoidal Function - Cr');
c = waitforbuttonpress ;

%% 2- Spatio-Temporal Sensitivity

%----Moving Sinusoids----%
cmap=gray(256);
f_x=.5;     v_x=.2;
f_y=.5;     v_y=.2;
phase=0;

[a,b]=meshgrid(1:0.1:100,1:0.1:100);

for t=1:100
    X=uint8(128*(1+sin(2*pi*f_x.*(a-(a/3)*t)+2*pi*f_y.*(b-(b/3)*t)+phase)));
    M(t)=im2frame(X,cmap);
end

implay(M,10);

%----AVI movie (attacched, already created)----%

% rows=512;
% cols=1024;
% cmap = gray(256);
% writerObj = VideoWriter('video.avi');
% open(writerObj);
% 
% for n=1:100
%     for i=1:rows
%         for j=1:cols
%             image(i,j) = uint8((128)*(sin(0.5*exp(j/150)+n)+1));
%         end
%     end
%     I = mat2gray(image,[0 255]);
%     % Transform image
%     frame(n) = im2frame(image,cmap);
%     writeVideo(writerObj,frame(n));
% end










