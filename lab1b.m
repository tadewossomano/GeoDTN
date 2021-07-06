close all
clear all
rows=512;
cols=1024;
%% grayscale

   for i=1:rows
    
        for j=1:cols
        
          
           image(i,j) = (128/(0.5*i))*(sin(0.5*exp(j/150))+1);%*((i/600)^3);  
            
       end
    end
    



    figure;
imshow(image);

title('Sinusoidal Function with increasing frequency');

%% red
my_image1(512,1024,3)=0; %initialize the image

my_image1(:,:,1)=image;

figure;
imshow(my_image1);title('Sinusoidal Function with increasing frequency red');
%% green
my_image2(512,1024,3)=0; %initialize the image

my_image2(:,:,2)=image;

figure;
imshow(my_image2);title('Sinusoidal Function with increasing frequency green');
%% blue
my_image3(512,1024,3)=0; %initialize the image

my_image3(:,:,3)=image;

figure;
imshow(my_image3);title('Sinusoidal Function with increasing frequency blue');

%% cb cr components
%creo immagine rgb
result(512,1024,3)=0;
rgb(512,1024,3)=0;
rgb(:,:,1)= image;
rgb(:,:,2)= image;
rgb(:,:,3)= image;
ycbcr = rgb2ycbcr(rgb);

%% Cbcomponent
Y = mean(mean(ycbcr(:,:,1)));
Cb =(ycbcr(:,:,2));
Cr =mean(mean(ycbcr(:,:,3)));

result(:,:,1)= Y;
result(:,:,2)= Cb;
result(:,:,3)= Cr;
imageCb = ycbcr2rgb(result);
%% Crcomponent
Y = mean(mean(ycbcr(:,:,1)));
Cb =mean(mean(ycbcr(:,:,2)));
Cr =ycbcr(:,:,3);

result(:,:,1)= Y;
result(:,:,2)= Cb;
result(:,:,3)= Cr;
imageCr = ycbcr2rgb(result);

figure;

imshow(imageCb);title('Cb');
figure;
imshow(imageCr);title('Cr');

