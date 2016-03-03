%%move
clear all;
close all;
clc;
rows=512;
cols=1024;
cmap = gray(256);
writerObj = VideoWriter('video.avi');
open(writerObj);

for n=1:100
    for i=1:rows
        for j=1:cols
image(i,j) = uint8((128)*(sin(0.5*exp(j/150)+n)+1));


       end
    end
I = mat2gray(image,[0 255]);
 
% Transform image


    frame(n) = im2frame(image,cmap);
      writeVideo(writerObj,frame(n));
end

%%figure;

%%implay(frame,5);