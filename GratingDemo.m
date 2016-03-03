clear all
close all
x=linspace(0, 4*pi, 100);
sf=8; % spatial freq in cycles per image 
   sinewave=sin(x*sf);    
plot(x, sinewave);
close all
onematrix=ones(size(sinewave));
sinewave2D=(onematrix'*sinewave);
colormap(gray)
imagesc(sinewave2D)
axis off;
colormap(summer);
 
