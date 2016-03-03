% Example9 1.m
% Computes the motion vectors and motion compensated
% prediction error image corresponding to two
% temporally adjacent image frames using the
% Sum of Absolute Difference (SAD) metric and
% full search procedure.
% It can estimate the motion to integer pel, half pel, or
% quarter pel accuracy.
% Motion blocks are of size 8 x 8 pixels and the
% search window size is 16 x 16 pixels.
clear all
close all
clf
Rows=288/2;
Cols=352/2;

% We load the file by creating three arrays of matrices, one for each
% component
% Alert: in general, and in particular for large video sequences, one never
% load the whole file for obvious reasons (memory). Here we do this for
% simplicity
seqfid=fopen('obj.yuv','rb');
for k=1:3
    Y(:,:,k)=(fread(seqfid,[Cols,Rows],'uint8=>uint8'))';
    Cb(:,:,k)=(fread(seqfid,[Cols/2,Rows/2],'uint8=>uint8'))';
    Cr(:,:,k)=(fread(seqfid,[Cols/2,Rows/2],'uint8=>uint8'))';
%     [YRic,CbRic,CrRic]=MCS_420to444(Y(:,:,k), Cb(:,:,k), Cr(:,:,k));
%     ImRic=cat(3,YRic,CbRic,CrRic);
%     Football(k)=im2frame(MCS_ycbcr2rgb(ImRic));
end
fclose(seqfid);

A = Y(:,:,1); % frame #1
B = Y(:,:,2); % frame #2
imshow(A);
title('frame1')
pause %e=waitforbutonpress;
imshow(B);
title('frame2')
pause
N = 8;% block size is N x N pixels
W = 16; % search window size is W x W pixels
sum1=0;
sum2=0;
sum3=0;
sum4=0;% Options: "full", "half" and "quarter"
motionVector=zeros(2);
% Make image size divisible by 8
[X,Y,Z] = size(A);
[P,Q,R]=size(B);
imgMotionPrediction=zeros(P,Q,R);
if mod(X,8)~=0
Heighta = floor(X/8)*8;
else
Heighta = X;
end
if mod(Y,8)~=0
Widtha = floor(Y/8)*8;
else
Widtha = Y;
end
Deptha = Z;
clear X Y Z
if mod(P,8)~=0
Heightb = floor(P/8)*8;
else
Height = P;
end
if mod(Q,8)~=0
Widthb = floor(Q/8)*8;
else
Widthb = Q;
end
Depthb = R;
for a18=1:8 %Row of reference frame
    for b18=1:8%column of reference frame
        for c=1:8
            for d=1:8
                sum1=sum((A(a18,b18)-B(c,d)).^2);
            end
        end
    end
end   
for a816=8:16 %Row of reference frame
    for b18=1:8%column of reference frame
        for c=1:8
            for d=1:8
                sum2=sum((A(a816,b18)-B(c,d)).^2);
            end
        end
    end
end   
   
for a18=1:8 %Row of reference frame
    for b816=8:16 %column of reference frame
        for c=1:8
            for d=1:8
                sum3=sum((A(a18,b816)-B(c,d)).^2);
            end
        end
    end
end   
for a816=8:16 %Row of reference frame
    for b816=8:16%column of reference frame
        for c=1:8
            for d=1:8
                sum4=sum((A(a816,b816)-B(c,d)).^2);
            end
        end
    end
end   
sumSet=[sum2,sum3,sum4];
minimum=min(sumSet);
switch minimum
    case sum2
                motionVector=[8 0];
                u=motionVector(1);
                v=motionVector(2);
                disp('the motion vector is (8,0)');
                
   case sum3
                motionVector=[0 8];
                 u=motionVector(1);
                 v=motionVector(2);
                disp('the motion vector is (0,8)');
    otherwise
                 motionVector=[8 8];
                 u=motionVector(1);
                 v=motionVector(2);
                disp('the motion vector is (8,8)');
 end

%%
%Move the Frame by magnitude of Motion Vector
movedFrame=zeros(P,Q,R);

for rws=1:v
     for colns=1:Q
            movedFrame(rws,colns,R)=[0 0 0];
     end
end
for i=1:P-v
    for  j=1:Q
         movedFrame(i+v,j)=B(i,j);
    end
end

    
imshow(movedFrame);
title('The moved frame')
