%Use blockproc(). See my well-commented demo:

% Demo code to divide the image up into 16 pixel by 16 pixel blocks
% and replace each pixel in the block by the mean, 
% of all the gray levels of the pixels in the block.
%
clc;
clearvars;
close all;
workspace;
fontSize = 10;
%{
% Read in a standard MATLAB gray scale demo image.
folder = fullfile(matlabroot, '\toolbox\images\imdemos');
if ~exist(folder, 'dir')
	% If that folder does not exist, don't use a folder
	% and hope it can find the image on the search path.
	folder = [];
end
baseFileName = 'lena.jpg';
fullFileName = fullfile(folder, baseFileName);
grayImage = imread('lena.jpg');
% Get the dimensions of the image.  numberOfColorBands should be = 1.
[rows columns numberOfColorBands] = size(grayImage);
% Display the original gray scale image.
subplot(1, 2, 1);
imshow(grayImage, []);
title('Original Grayscale Image', 'FontSize', fontSize);
% Enlarge figure to full screen.
set(gcf, 'Position', get(0,'Screensize')); 
set(gcf,'name','Image Analysis Demo','numbertitle','off') 
% Define the function that we will apply to each block.
% First in this demo we will take the median gray value in the block
% and create an equal size block where all pixels have the median value.
% Image will be the same size since we are using ones() and so for each block
% there will be a block of 8 by 8 output pixels.
meanFilterFunction = @(theBlockStructure) mean2(theBlockStructure.data(:));
% Block process the image to replace every pixel in the 
% 16 pixel by 16 pixel block by the median of the pixels in the block.
blockSize = [16, 16];
blockyImage = blockproc(single(grayImage), blockSize, meanFilterFunction); 
[rows columns] = size(blockyImage);
% Display the block median image.
subplot(1, 2, 2);
imshow(blockyImage, []);
caption = sprintf('Block Mean Image\nInput block size = 16\n%d rows by %d columns', rows, columns);
title(caption, 'FontSize', fontSize);
%}
obj = VideoReader('carphone_qcif.yuv');
video=read(obj,[1,3]);
image(obj);
frame1=read(obj,1);
frame2=read(obj,2);
frame3=read(obj,3);
imshow(frame2);
[X,Y,B,F]=size(video);
N = 8;% block size is N x N pixels
W = 16; % search window size is W x W pixels
if mod(X/8)~=0
        Height= floor(X/8)*8;
      else
       Height = X;
end
if mod(Y/8)~=0
       width=floor(Y/8)*8;
    else
    width=Y;
end
depth=B;

