function [blk] = block(T,dim)
ext=size(T,2)/dim;
int=sqrt(size(T,1));
k=1;
for i=1:ext
    for l=1:ext
        blk{i,l}=reshape(T(:,k),int,int)';
        k=k+1;
    end
end
end