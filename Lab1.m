%%%%%%%%%%%%%%%%%%%%%%%%%%
% MULTIMEDIA COMMUNICATION SERVICES
% LAB n. 1
%
% NB: this script uses Cell Mode. Each cell can be run independently
% (Step 2 uses the data computed at Step 1)
%
%%%%%%%%%%%%%%%%%%%%%%%%%%


%%  Point 1
close all;
clear all;
I=imread('monarch.tiff');
[Nr,Nc]=size(I(:,:,1));
disp(['Immagine letta e caricata come struttura di dimensioni ' num2str(size(I))]);
R=I(:,:,1);
G=I(:,:,2);
B=I(:,:,3);

figure
% Original Image
subplot(3,3,2);
imshow(I);
title('Originale')
% Components, displayed in black and white
subplot(3,3,4);
imshow(R);
title('R in scala di grigio')
subplot(3,3,5);
imshow(G);
title('G in scala di grigio')
subplot(3,3,6);
imshow(B);
title('B in scala di grigio')

% We build an image with only one non-null component
IR=I; IR(:,:,2)=0; IR(:,:,3)=0;
IG=I; IG(:,:,1)=0; IG(:,:,3)=0;
IB=I; IB(:,:,1)=0; IB(:,:,2)=0;
% Components, displayed as colors
subplot(3,3,7);
imshow(IR);
title('R')
subplot(3,3,8);
imshow(IG);
title('G')
subplot(3,3,9);
imshow(IB);
title('B')

% We convert the image in the YCbCr format
[Y,Cb,Cr]=MCS_rgb2ycbcr(I);
% We put the components together to build a single 3D structure
YCbCr=cat(3,Y,Cb,Cr);

% Display
figure
% Reconstructed Image
subplot(3,3,2);
Irec=MCS_ycbcr2rgb(YCbCr);
imshow(Irec);
title('RGB->YCbCr->RGB')
% Components, displayed as black and white 
subplot(3,3,4);
imshow(Y);
title('Y in scala di grigio')
subplot(3,3,5);
imshow(Cb);
title('Cb in scala di grigio')
subplot(3,3,6);
imshow(Cr);
title('Cr in scala di grigio')

% Components displayed as colors
subplot(3,3,7);
Yonly=cat(3,Y,Cb*0+128,Cr*0+128);
IYonly=MCS_ycbcr2rgb(Yonly);
imshow(IYonly);
title('Y')

subplot(3,3,8);
Cbonly=cat(3,Y*0+128,Cb,Cr*0+128);
ICbonly=MCS_ycbcr2rgb(Cbonly);
imshow(ICbonly);
title('Cb')

subplot(3,3,9);
Cronly=cat(3,Y*0+128,Cb*0+128,Cr);
ICronly=MCS_ycbcr2rgb(Cronly);
imshow(ICronly);
title('Cr')


%% Point 2

% ****** 4:2:2 Format ******

[Y422, Cb422, Cr422]=MCS_444to422(Y,Cb,Cr);

% We write in a file
fid422=fopen('monarch_422.yuv','wb');
fwrite(fid422,Y422,'uint8');
fwrite(fid422,Cb422,'uint8');
fwrite(fid422,Cr422,'uint8');
fclose(fid422);

% ****** 4:2:0 Format ******
[Y420, Cb420, Cr420]=MCS_444to420(Y,Cb,Cr);

% We write in a file
fid420=fopen('monarch_420.yuv','wb');
fwrite(fid420,Y420,'uint8');
fwrite(fid420,Cb420,'uint8');
fwrite(fid420,Cr420,'uint8');
fclose(fid420);

% We now read the images from the file and display them
fid422=fopen('monarch_422.yuv','rb');
fid420=fopen('monarch_420.yuv','rb');
% Alert: we need to know the size of the images, the file contains the
% pixel values with no headers
% Alert2: the images read by matlab are double even if the image was stored
% as uint8
Y422Letta=fread(fid422,size(Y),'uint8');
Cb422Letta=fread(fid422,size(Cb422),'uint8');
Cr422Letta=fread(fid422,size(Cr422),'uint8');
fclose(fid422);

% We convert to 4:4:4 and then RGB for display
[Y422Ric, Cb422Ric, Cr422Ric]=MCS_422to444(Y422Letta,Cb422Letta,Cr422Letta);
YCbCr422Ric=cat(3,Y422Ric,Cb422Ric,Cr422Ric);
RGB422Ric=MCS_ycbcr2rgb(YCbCr422Ric);

Y420Letta=fread(fid420,size(Y),'uint8');
Cb420Letta=fread(fid420,size(Cb420),'uint8');
Cr420Letta=fread(fid420,size(Cr420),'uint8');
fclose(fid420);
[Y420Ric, Cb420Ric, Cr420Ric]=MCS_420to444(Y420Letta,Cb420Letta,Cr420Letta);
whos Cr420 Y420Letta Cb420Letta Cr420Letta Y420Ric Cb420Ric Cr420Ric
YCbCr420Ric=cat(3,Y420Ric,Cb420Ric,Cr420Ric);
RGB420Ric=MCS_ycbcr2rgb(YCbCr420Ric);



figure;
subplot(1,3,1);
imshow(Irec)
title('4:4:4');
subplot(1,3,2);
imshow(RGB422Ric)
title('4:2:2');
subplot(1,3,3);
imshow(RGB420Ric)
title('4:2:0');


%% Point 3
clear all
close all

Rows=288;
Cols=352;

% We load the file by creating three arrays of matrices, one for each
% component
% Alert: in general, and in particular for large video sequences, one never
% load the whole file for obvious reasons (memory). Here we do this for
% simplicity
seqfid=fopen('Football_352x288_30.yuv','rb');
for k=1:40
    Y(:,:,k)=(fread(seqfid,[Cols,Rows],'uint8=>uint8'))';
    Cb(:,:,k)=(fread(seqfid,[Cols/2,Rows/2],'uint8=>uint8'))';
    Cr(:,:,k)=(fread(seqfid,[Cols/2,Rows/2],'uint8=>uint8'))';
    [YRic,CbRic,CrRic]=MCS_420to444(Y(:,:,k), Cb(:,:,k), Cr(:,:,k));
    ImRic=cat(3,YRic,CbRic,CrRic);
    Football(k)=im2frame(MCS_ycbcr2rgb(ImRic));
end
fclose(seqfid);

[h, w, p] = size(Football(1).cdata);  % use 1st frame to get dimensions
hf = figure; 
% resize figure based on frame's w x h, and place at (150, 150)
set(hf, 'position', [550,550,w h]);
axis off
movie(hf,Football,1,30);

% We save it also as an avi
movie2avi(Football,'Football.avi','fps',30);

% We write the luminance file

Yseqfid=fopen('FOOTBALL_352x288_30.y','wb');
for k=1:40
    fwrite(Yseqfid,Y(:,:,k)','uint8');
    FootballBN(k)=im2frame(Y(:,:,k),gray(256));
end

% Here we set the window for the video display (check Matlab's help)
[h, w, p] = size(FootballBN(1).cdata);  % use 1st frame to get dimensions
hf2 = figure; 
% resize figure based on frame's w x h, and place at (550, 550)
set(hf2, 'position', [550,550,w h]);
axis off
movie(hf2,FootballBN,1,30);
% save as an avi
movie2avi(FootballBN,'FootballBN.avi','fps',30);



% We filter the Y component of the first image and compare with the
% original
Y1=Y(:,:,1);
Y1F=conv2(double(Y1),[0.25, 0.25; 0.25, 0.25]);
Y1F=uint8(Y1F(2:end,2:end));

figure;
subplot(1,3,1);
imshow(Y1);
subplot(1,3,2);
imshow(Y1F);
subplot(1,3,3);
imshow(uint8(abs(double(Y1)-double(Y1F))));

% We now create the QCIF, we store it, we creat the matlab movie etc
QCIFseqfid=fopen('FOOTBALL_176x144_30.yuv','wb');
for k=1:40
    Ytemp=double(Y(:,:,k));
    Ytemp=conv2(Ytemp,[0.25, 0.25; 0.25, 0.25]);
    YQCIF(:,:,k)=uint8(Ytemp(2:2:end,2:2:end));
    
    Cbtemp=double(Cb(:,:,k));
    Cbtemp=conv2(Cbtemp,[0.25, 0.25; 0.25, 0.25]);
    CbQCIF(:,:,k)=uint8(Cbtemp(2:2:end,2:2:end));

    Crtemp=double(Cr(:,:,k));
    Crtemp=conv2(Crtemp,[0.25, 0.25; 0.25, 0.25]);
    CrQCIF(:,:,k)=uint8(Crtemp(2:2:end,2:2:end));

    fwrite(QCIFseqfid, YQCIF(:,:,k)','uint8');
    fwrite(QCIFseqfid, CbQCIF(:,:,k)','uint8');
    fwrite(QCIFseqfid, CrQCIF(:,:,k)','uint8');
    
    [YQCIFRic,CbQCIFRic,CrQCIFRic]=MCS_420to444(YQCIF(:,:,k), CbQCIF(:,:,k), CrQCIF(:,:,k));
    ImRicQCIF=cat(3,YQCIFRic,CbQCIFRic,CrQCIFRic);
    FootballQCIF(k)=im2frame(MCS_ycbcr2rgb(ImRicQCIF));
end

fclose(QCIFseqfid);

[h, w, p] = size(FootballQCIF(1).cdata);  % use 1st frame to get dimensions
hf3 = figure; 
% resize figure based on frame's w x h, and place at (550, 550)
set(hf3, 'position', [550,550,w h]);
axis off
movie(hf3,FootballQCIF,1,30);
movie2avi(FootballQCIF,'FootballQCIF.avi','fps',30);
