function [U] = column(blocks,bsize)
ext=size(blocks,1);
k=1;
for i=1:ext
    for l=1:ext
        U(:,k)=reshape(blocks{i,l}',bsize*bsize,1);
        k=k+1;
    end
end
end