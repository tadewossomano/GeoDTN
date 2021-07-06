clear all
close all
clf
I=imread('lena.jpg');
imshow(I);
title('RGB')
[Y,Cb,Cr]=MCS_rgb2ycbcr(I);
pause
imshow(Y);
title('luminance')
pause
%I = imread('lena_gray.jpg');        %lena_gray    prova
[n0,n1,depth] = size(Y);

%{
if Depth > 1
    Y = double(rgb2gray(I));         
else
    I = double(I);
end
%I=I-sum(sum(I));
%}


clear Depth;
%%

%if mod(n0/8)~=0
        height= floor(n0/8)*8;
     % else
       %Height = n0;
%end
%if mod(n1/8)~=0
       width=floor(n1/8)*8;
     %else
      %width=n1;
%end
blockWidth = 8;
blockHeight = 8;
%blocks = zeros((Width/blockWidth),(Height/blockHeight),blockHeight*blockWidth);
%autoCorrel_t = 0;
yCorrelation=zeros(height,width);
for i_t=1:(width/blockWidth)
   for j_t=1:(height/blockHeight)
        for blockRow=1:8
          for blockColumn=1:8
                %while (blockRow+8*(i_t))<height 
                 %while  (blockColumn+8*(j_t))<width 
             sum1=(sum(Y(blockRow+8*(i_t-1),blockColumn+8*(j_t-1)))*sum(Y(blockRow+8*(i_t-1),blockColumn+8*(j_t-1))))/64;
                 %end
                %end
         end
        end
      for correlationRow=1:8
      for correlationColumn=1:8
                
        yCorrelation(correlationRow+8*(i_t-1),correlationColumn+8*(j_t-1))=sum1;
      end
       end
        %temp_t=Y((j_t-1)*blockHeight+1:(j_t)*blockHeight,(i_t-1)*blockWidth+1:(i_t)*blockWidth);        
       % blocks(:,i_t,j_t)=temp_t(:);      
        
        %autoCorrel_t = autoCorrel_t + blocks(:,i_t,j_t)*blocks(:,i_t,j_t)';
        %figure, imshow(uint8(blocchi(:,i_t,j_t)));  pause;
    end
end
imshow(yCorrelation)
%R_blocks = (autoCorrel_t)/((Width/blockWidth)*(Height/blockHeight));
