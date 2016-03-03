%=====================================================================
%                        Vector Quantization
%=====================================================================

%
clc
clear all
close all

img = imread('lena.jpg');
img_ycbcr = rgb2ycbcr(img);

img_ycbcr(:,:,2)=128;
img_ycbcr(:,:,3)=128;

%Isolate luminance
x = ycbcr2rgb(img_ycbcr);
x = double(x(:,:,1));

 %figure
% imshow(uint8(img_Y));
% pause;

%=====================================================================
%                   parameters
%=====================================================================
size_bk = 8;
dim = size(x);
width = dim(2);
height = dim(1);

horizontalblocks = width/size_bk;
verticalblocks = height/size_bk;
tot_blocks = horizontalblocks*verticalblocks;

tot_iter = 8;   % number of iterations
init_seed = 256; % number of elements in the dictionary you want
%=====================================================================
%           I create the dictionary for the loaded image
%=====================================================================

test_book = zeros(1,size_bk*size_bk);
for m=1:verticalblocks
    for n=1:horizontalblocks
        test_book = cat(1,test_book,getBlock(x,m,n,size_bk));
    end
end
full_codebook = zeros(horizontalblocks*verticalblocks,size_bk*size_bk);
full_codebook = test_book(2:end,:);



init_codebook = rand(init_seed,size_bk*size_bk)*256;
error_tot = zeros(tot_iter,1);

for n_step=1:tot_iter
    n_step
    matching_rigion = zeros(tot_blocks,1);

    % Calculating distances of the centroids (which in the first step are random)
    %from training vector (t_k)
    for k=1:tot_blocks
        square_distance = zeros(init_seed,1);
        for m=1:init_seed
            square_distance(m,1) = sum((full_codebook(k,:)-init_codebook(m,:)).^2);
        end
                                                      % Searching the centroid closest to each t_k
        matching_region(k,1) = min(find(square_distance==min(square_distance)));
    end
    % Reposition centroids (center of gravity of  CLUSTER)
    for k=1:init_seed
        index = find(matching_region==k);
        if index ~= 0
            init_codebook(k,:) = sum(full_codebook(index,:))/length(index);
        end
    end

    % I estimate the indices i_x that best approximates the codeword
    % and estimate the error associated
    close_centroid = zeros(tot_blocks,1);
    error_block = zeros(tot_blocks,1);
    for k=1:tot_blocks
        square_distance = zeros(init_seed,1);
        for m=1:init_seed
            square_distance(m,1) = sum((full_codebook(k,:)-init_codebook(m,:)).^2);
        end
        % Seeking the centroid closest to each t_k
        close_centroid(k,1) = min(find(square_distance==min(square_distance)));

        error_block(k,1) = square_distance(close_centroid(k,1),1);
    end
    error_tot(n_step,1) = sum(error_block);
end

% plot square of error as a funcyion of number of iteration
%  (tot_step)
figure
x_axis = linspace(1,tot_iter,tot_iter);
plot(x_axis,error_tot);
title('total error')
xlabel('number of iterations ')
ylabel(' tot(n) error')


%=====================================================================
%                  Reconstruction and comparison
%=====================================================================
x_reconstructed = zeros(height,width);
k=1;
for m=1:verticalblocks
    for n=1:horizontalblocks
        block_m_n = (reshape(init_codebook(close_centroid(k,1),:),size_bk,size_bk))';
        x_reconstructed(size_bk*(m-1)+1:size_bk*m, size_bk*(n-1)+1:size_bk*n)=block_m_n;
        k = k+1;
    end
end
figure
subplot(1,2,1)
imshow(uint8(x))
title('Original')
subplot(1,2,2)
imshow(uint8(x_reconstructed))
title('Reconstructed')
pause
%}



