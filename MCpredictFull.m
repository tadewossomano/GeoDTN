function [x,y,pf] = MCpredictFull(A,B,N,W)
% [x,y,pf] = MCpredict Full(A,B,N,W)
% Computes motion vectors of N x N moving blocks
% in an intensity image using full search and
% does a motion compensated prediction to a single pel
accuracy
% Input:
% A = reference frame
% B = current frame
% N = block size (nominal value is 8, assumed square)
% W = search window (2N x 2N)
% Output:
% x = horizontal component of motion vector
% y = Vertical component of motion vector
% pf = motion compensated prediction image, same size as
input image
[Height,Width] = size(A);
% pad input images on left, right, top, and bottom
% padding by replicating works better than padding w/ zeros, which is
% better than symmetric which is better than circular
A1 = double(padarray(A,[W/2 W/2],’replicate’));
B1 = double(padarray(B,[W/2 W/2],’replicate’));
x = int16(zeros(Height/N,Width/N));% x-component of
motion vector
y = int16(zeros(Height/N,Width/N));% y-component of
motion vector
% Find motion vector by exhaustive search to a single pel
accuracy
figure,imshow(B), title('Superimposed motion vectors')
hold on % display image & superimpose motion vectors
for r = N:N:Height
rblk = floor(r/N);
for c = N:N:Width
cblk = floor(c/N);
D = 1.0e+10;% initial city block distance
for u = -N:N
for v = -N:N
d = B1(r+1:r+N,c+1:c+N)-A1(r+u+1:r+u+N,c+v+1:c+v+N);
d = sum(abs(d(:)));% city block distance
between pixels
if d < D
D = d;
x(rblk,cblk) = v; y(rblk,cblk) = u;
end
end
end
quiver(c+y(rblk,cblk),r+x(rblk,cblk),...
x(rblk,cblk),y(rblk,cblk),'k','LineWidth',1)
end
end
hold off
% Reconstruct current frame using prediction error &
reference frame
N2 = 2*N;
pf = double(zeros(Height,Width)); % prediction frame
Br = double(zeros(Height,Width)); % reconstructed frame
for r = 1:N:Height
rblk = floor(r/N) + 1;
for c = 1:N:Width
cblk = floor(c/N) + 1;
x1 = x(rblk,cblk); y1 = y(rblk,cblk);
pf(r:r+N-1,c:c+N-1) = B1(r+N:r+N2-1,c+N:c+N2-1)...
-A1(r+N+y1:r+y1+N2-1,c+N+x1:c+x1+N2-1);
Br(r:r+N-1,c:c+N-1) = A1(r+N+y1:r+y1+N2-1,c+N+x1:c+x1+N2-1)...
    + pf(r:r+N-1,c:c+N-1);
end
end
%
figure,imshow(uint8(round(Br))),title('Reconstructed image')
