function [ block_in_linea ] = getBlock(img,m,n,size_block)

    block = zeros(size_block,size_block);
     block(:,:) = img(size_block*(m-1)+1:size_block*m, size_block*(n-1)+1:size_block*n);
    
    block_in_linea = zeros(1,size_block);
    block_in_linea =  block(1,:);
    
    for k=2:size_block
        block_in_linea = cat(2,block_in_linea, block(k,:));
    end
    
end
