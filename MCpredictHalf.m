function [x,y,pf] = MCpredictHalf(A,B,N,W)
input image
[Height,Width] = size(A);
% pad input images on left, right, top, and bottom
A1 = double(padarray(A,[W/2 W/2],’symmetric’)); % reference
block
B1 = double(padarray(B,[W/2 W/2],’symmetric’)); % current
block
NumRblk = Height/N;
NumCblk = Width/N;
x = zeros(NumRblk,NumCblk);% x-component of motion vector
y = zeros(NumRblk,NumCblk);% %y-component of motion vector
pf = double(zeros(Height,Width)); % prediction frame
% Find motion vectors by exhaustive search to 1/2 pel accuracy
figure,imshow(B), title('Superimposed motion vectors')
hold on % display image & superimpose motion vectors
for r = N:N:Height
rblk = floor(r/N);
for c = N:N:Width
cblk = floor(c/N);
D = 1.0e+10;% initial city block distance
for u = -N:N
for v = -N:N
%
RefBlk = A1(r+u+1:r+u+N,c+v+1:c+v+N);
CurrentBlk = B1(r+1:r+N,c+1:c+N);
[x2,y2] = meshgrid(r+u+1:r+u+N,c+v+1:c+v+N);
[x3,y3] = meshgrid(r+u-0.5:r+u+N-1,c+v-0.5:c+v+N-1);
% interpolate at 1/2 pel accuracy
z1 = interp2(x2,y2,RefBlk,x3,y3,'*linear');
Indx = isnan(z1);
z1(Indx == 1) = CurrentBlk(Indx==1);
%
dd = CurrentBlk - round(z1);
d = sum(abs(dd(:)));
if d < D
D = d;
U = u+0.5; L = v+0.5;
pf(r-N+1:r,c-N+1:c) = dd;
end
end
end
x(rblk,cblk) = L; % Motion in the vertical direction
y(rblk,cblk) = U; % Motion in the horizontal direction
quiver(c+y(rblk,cblk),r+x(rblk,cblk),...
x(rblk,cblk),y(rblk,cblk),'k','LineWidth',1)
end
end
hold off
% Reconstruct current frame using prediction error &
reference frame
N2 = 2*N;
Br = double(zeros(Height,Width));
for r = N:N:Height
rblk = floor(r/N);
for c = N:N:Width
cblk = floor(c/N);
x1 = x(rblk,cblk); y1 = y(rblk,cblk);
Indr1 = floor(r+y1+1); Indr2 = floor(r+y1+N);
if Indr1 <= 0
Indr1 = 1;
end
if Indr2 > Height +N2
Indr2 = Height + N2;
end
Indc1 = floor(c+x1+1); Indc2 = floor(c+x1+N);
if Indc1 <= 0
Indc1 = 1;
end
if Indc2 > Width +N2
Indc2 = Width + N2;
end
RefBlk = A1(Indr1:Indr2,Indc1:Indc2);
%
[x2,y2] = meshgrid(Indr1:Indr2,Indc1:Indc2);
[x3,y3] = meshgrid(r-N+1:r,c-N+1:c);
z1 = interp2(x2,y2,RefBlk,x3,y3,'*linear');
Indx = isnan(z1);
z1(Indx==1) = RefBlk(Indx == 1);
Br(r-N+1:r,c-N+1:c)= round(pf(r-N+1:r,c-N+1:c) + z1);
end
end
figure,imshow(uint8(round(Br))),title('Reconstructed image')
