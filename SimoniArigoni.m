%% part 1
clc;
close all;
clear all;

scrsz = get(0,'ScreenSize');

step = 0.05;
x = -6:step:6;
y = -6:step:6;

[xx, yy] = ndgrid (x, y);

%----s----%
s = rectpuls(xx/2).*rectpuls(yy/2); 
%s = sin(2*pi*xx/2);
S = fft2(s);
S = fftshift(S);

figure;
imagesc(y,x,s); title('s(x,y)'); ylabel('x'); xlabel('y');
colormap(gray);
pause;
figure;
imagesc(-0.5:0.25:0.5,-0.5:0.25:0.5,abs(S)); 
title('|S(fx,fy)|'); xlabel('fx'); ylabel('fy');

% figure;
% surf(abs(S)); shading interp; 
% title('|S(fx,fy)|'); ylabel('fx'); xlabel('fy');

pause;

%----subsampling vertical factor 4----%
matrix_sub = zeros(size(s,1), size(s,2));
matrix_sub(1:4:size(s,1),:) = 1;

s_4v = s.*matrix_sub;
S_4v = fft2(s_4v);
S_4v = fftshift(S_4v);

figure;
imagesc(y,x,s_4v); 
title('s(x,y) vertical subsample factor 4'); ylabel('x'); xlabel('y');
colormap(gray);

figure;
imagesc(-0.5:0.25:0.5, -0.5:0.25:0.5, abs(S_4v));
title('|S(fx,fy) vertical subsample factor 4|'); ylabel('fx'); xlabel('fy');

% figure;
% surf(abs(S_4v)); shading interp;
% title('S(fx,fy) vertical subsample factor 4'); ylabel('fx'); xlabel('fy');

pause;

%----subsampling vertical and horizontal factor 4----%
matrix_sub=zeros(size(s,1),size(s,2));
matrix_sub(1:4:size(s,1),1:4:size(s,2))=1;
s_4=s.*matrix_sub;
S_4 = fft2(s_4);
S_4 = fftshift(S_4);

figure;
imagesc(y,x,s_4); 
title('s(x,y) subsample factor 4'); ylabel('x'); xlabel('y');
colormap(gray);

figure;
imagesc(-0.5:0.25:0.5, -0.5:0.25:0.5, abs(S_4));
title('|S(fx,fy) subsample factor 4|'); ylabel('fx'); xlabel('fy');

% figure;
% surf(abs(S_4)); shading interp;
% title('S(fx,fy) subsample factor 4'); ylabel('fx'); xlabel('fy');

pause;

%----subsampling Quincunx grid----%
matrix_sub=zeros(size(s,1),size(s,2));
matrix_sub(1:4:size(s,1),1:2:size(s,2))=1;
matrix_sub(3:4:size(s,1),2:2:size(s,2))=1;
s_q=s.*matrix_sub;
S_q = fft2(s_q);
S_q = fftshift(S_q);

figure;
imagesc(y,x,s_q);
title('s(x,y) Quincunx grid subsample'); ylabel('x'); xlabel('y');
colormap(gray);

figure;
imagesc(-0.5:0.25:0.5, -0.5:0.25:0.5, abs(S_q));
title('|S(fx,fy) Quincunx grid subsample|'); ylabel('fx'); xlabel('fy');

% figure;
% surf(abs(S_q)); shading interp;
% title('S(fx,fy) Quincunx grid subsample'); ylabel('fx'); xlabel('fy');

pause;

%% part 2
clc;
close all;
clear all;

scrsz = get(0,'ScreenSize');
figure('Position',[50 150 scrsz(3)-100 (1/2)*scrsz(4)]);

step = 0.05;
x = -6:step:6;
y = -6:step:6;

fps=15;
seconds=15;
t = 0:1/fps:seconds;

velocity = pi;
%velocity = 4*pi;
%velocity = 2*pi*10;

[xx, yy] = ndgrid (x, y);

%----video----%
v=zeros(size(xx,1),size(xx,2),length(t),'double');
for f=1:length(t)
    v(:,:,f) = sin(2*pi*xx+t(f)*velocity);
end

implay(v,fps);
pause
V = fftn(v);
V = fftshift(V);

V_cut(:,:)=V(:,round(length(y)/2),:);%%%%%
subplot(1,3,1);
%imshow(uint8(abs(V_cut)));
%imshow(abs(V_cut/max(max(V_cut))));
imagesc(abs(V_cut));
title('S(fx,ft)');
xlabel('ft'); ylabel('fx');

%%
%----video with subsampling vertical and horizontal factor 4----%
matrix_sub=zeros(size(v,1),size(v,2));
matrix_sub(1:4:size(v,1),1:4:size(v,2))=1;
v=zeros(size(xx,1),size(xx,2),length(t),'double');
for f=1:length(t)
    v(:,:,f) = matrix_sub.*sin(2*pi*xx+t(f)*velocity);
end

implay(v,fps);
pause
V = fftn(v);
V = fftshift(V);

V_cut(:,:)=V(:,round(length(y)/2),:);
subplot(1,3,2);
%imshow(uint8(abs(V_cut)));
%imshow(abs(V_cut/max(max(V_cut))));
imagesc(abs(V_cut));
title('S(fx,ft) subsample factor 4');
xlabel('ft'); ylabel('fx');

%%
%----video interlaced----%
matrix_odd=zeros(size(v,1),size(v,2));
matrix_odd(1:2:size(v,1),:)=1;
matrix_even=zeros(size(v,1),size(v,2));
matrix_even(2:2:size(v,1),:)=1;
v=zeros(size(xx,1),size(xx,2),length(t),'double');
for f=1:2:length(t)
    v(:,:,f) = matrix_odd.*sin(2*pi*xx+t(f)*velocity);
end
for f=2:2:length(t)
    v(:,:,f) = matrix_even.*sin(2*pi*xx+t(f)*velocity);
end

implay(v,fps);
pause
V = fftn(v);
pause
V = fftshift(V);

V_cut(:,:)=V(:,round(length(y)/2),:);%%%%%%
subplot(1,3,3);
%imshow(uint8(abs(V_cut)));
%imshow(abs(V_cut/max(max(V_cut))));
imagesc(abs(V_cut));
title('S(fx,ft) interlaced');
xlabel('ft'); ylabel('fx');

% for i=1:length(t)
%     m(i) = im2frame(v(:,:,i)), gray);
% end
% % movie(m,1,fps);
% movie2avi(m,'test.avi','fps',fps);