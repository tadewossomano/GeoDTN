%MULTIMEDIA COMMUNICATION SERVICES
%Multimedia information coding and description
%LAB 7

clear all;
close all;
clc;

%Read the image and separate the luminance component
im=rgb2ycbcr(imread('lena.jpg'));
Y=double(im(:,:,1));
bsize=8;

%Divide the image in sub-blocks
blocks=mat2cell(Y,ones(1,length(Y)/(bsize))*bsize,ones(1,length(Y)/(bsize))*bsize);

%Stack the columns of each sub-block

U=column(blocks,bsize);

%Compute the covariance matrix
Ru=zeros(length(Y)/bsize,length(Y)/bsize);
for i=1:bsize*bsize
    for l=1:bsize*bsize
        Ru(i,l)=U(i,:)*U(l,:)'/length(U(i,:));
    end
end

%Compute the eigenvectors and eigenvalues of Ru
[T Rv]=eig(Ru);
T=fliplr(T);
Rv=rot90(Rv,2);

%Display the basis function of the KLT in decreasing order of importance
Tb=block(T,bsize);
figure; imshow(cell2mat(Tb),[]); title('KLT eigenvectors');
pause;
%Apply the transform to the original image
V=T'*U;

%Divide the transform into blocks of dimension 8x8
Vb=block(V,bsize*bsize);%%%%%%%%%%%
figure; imshow(cell2mat(Vb),[]); title('KLT coefficients');
pause;
%Display the transform
Vb2=block(V',bsize);
figure; imshow(cell2mat(Vb2),[]); title('KLT coefficients2');
pause;
for k=1:bsize-1
    line([0 length(Y)],[length(Y)/bsize*k length(Y)/bsize*k],'LineWidth',1,'LineStyle','-','Color','w');
    line([length(Y)/bsize*k length(Y)/bsize*k],[0 length(Y)],'LineWidth',1,'LineStyle','-','Color','w');
end

%Compute the energy of the KLT coefficients
for i=1:size(V,1)
   Eklt(i)=sum(sum(V(i,:)*V(i,:)'))/size(V,2); 
end
Eklt=reshape(Eklt,bsize,bsize)';

%Remove useless KLT coefficients
vb=Vb;
for i=1:length(Vb)
   for l=1:length(Vb)
      vb{i,l}(1:end,8:end)=0;  %
      vb{i,l}(2:end,7:end)=0;
      vb{i,l}(3:end,5:end)=0;
      vb{i,l}(4:end,1:end)=0;
   end
end

%Reconstruction of KLT
v=column(vb,bsize);
u=(T')^-1*v;
iKLT=block(u,bsize*bsize);
figure; imshow(cell2mat(iKLT),[]); title('Reconstructed image after having removed KLT useless coefficients');
pause;


%Apply 2-dimensional DFT and DCT with 8x8 blocks
for i=1:length(Y)/bsize
    for l=1:length(Y)/bsize
        DFT{i,l}=fft2(cell2mat(blocks(i,l)));
        DCT{i,l}=dct2(cell2mat(blocks(i,l)));
    end
end

figure; imshow(cell2mat(DFT),[]); title('DFT coefficients');
figure; imshow(cell2mat(DCT),[]); title('DCT coefficients');

%Display the results
Udft=column(DFT,bsize);
Udct=column(DCT,bsize);

udft=block(Udft',bsize);%
figure; imshow(cell2mat(udft),[]); title('DFT coefficients');
for k=1:bsize-1
    line([0 length(Y)],[length(Y)/bsize*k length(Y)/bsize*k],'LineWidth',1,'LineStyle','-','Color','w');
    line([length(Y)/bsize*k length(Y)/bsize*k],[0 length(Y)],'LineWidth',1,'LineStyle','-','Color','w');
end

udct=block(Udct',bsize);
figure; imshow(cell2mat(udct),[]); title('DCT coefficients');
for k=1:bsize-1
    line([0 length(Y)],[length(Y)/bsize*k length(Y)/bsize*k],'LineWidth',1,'LineStyle','-','Color','w');
    line([length(Y)/bsize*k length(Y)/bsize*k],[0 length(Y)],'LineWidth',1,'LineStyle','-','Color','w');
end

%Compute the energies for the DCT and DFT
for i=1:64
   Edft(i)=sum(sum(Udft(i,:)*Udft(i,:)'))/size(Udft,2); 
end
Edft=reshape(Edft,bsize,bsize)';

for i=1:64
   Edct(i)=sum(sum(Udct(i,:)*Udct(i,:)'))/size(Udct,2); 
end
Edct=reshape(Edct,bsize,bsize)';

%Remove useless coefficients (same values used for KLT)
dft=DFT;
dct=DCT;
for i=1:length(DCT)
   for l=1:length(DCT)
      dft{i,l}(1:end,8:end)=0;
      dft{i,l}(2:end,7:end)=0;
      dft{i,l}(3:end,5:end)=0;
      dft{i,l}(4:end,1:end)=0;
      dct{i,l}(1:end,8:end)=0;
      dct{i,l}(2:end,7:end)=0;
      dct{i,l}(3:end,5:end)=0;
      dct{i,l}(4:end,1:end)=0;
   end
end

%Apply the inverse transform
for i=1:length(Y)/bsize
    for l=1:length(Y)/bsize
        iDFT{i,l}=ifft2(cell2mat(dft(i,l)));
        iDCT{i,l}=idct2(cell2mat(dct(i,l)));
    end
end

figure; imshow(cell2mat(iDFT),[]); title('Reconstructed image after having removed DFT useless coefficients');
figure; imshow(cell2mat(iDCT),[]); title('Reconstructed image after having removed DCT useless coefficients');

%Reconstruction errors
ErecKLT=Y-cell2mat(iKLT);
ErecDFT=Y-cell2mat(iDFT);
ErecDCT=Y-cell2mat(iDCT);

figure; imshow(ErecKLT,[]); title('KLT reconstruction error');
figure; imshow(ErecDFT,[]); title('DFT reconstruction error');
figure; imshow(ErecDCT,[]); title('DCT reconstruction error');

%Compute the energy of the reconstruction errors
UEklt=column(mat2cell(ErecKLT,ones(1,length(Y)/(bsize))*bsize,ones(1,length(Y)/(bsize))*bsize),bsize);
UEdft=column(mat2cell(ErecDFT,ones(1,length(Y)/(bsize))*bsize,ones(1,length(Y)/(bsize))*bsize),bsize);
UEdct=column(mat2cell(ErecDCT,ones(1,length(Y)/(bsize))*bsize,ones(1,length(Y)/(bsize))*bsize),bsize);

for i=1:64
   recEklt(i)=sum(sum(UEklt(i,:)*UEklt(i,:)'))/size(UEklt,2);
end
recEklt=reshape(recEklt,bsize,bsize)';

for i=1:64
   recEdft(i)=sum(sum(UEdft(i,:)*UEdft(i,:)'))/size(UEdft,2);
end
recEdft=reshape(recEdft,bsize,bsize)';

for i=1:64
   recEdct(i)=sum(sum(UEdct(i,:)*UEdct(i,:)'))/size(UEdct,2); 
end
recEdct=reshape(recEdct,bsize,bsize)';


