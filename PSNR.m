function [ psnr ] = PSNR( original,ref )
original=double(original);
ref=double(ref);
[M N]=size(original);
error=original-ref;
MSE=sum(sum(error.*error))/(M*N);
psnr=10*log10(255*255/MSE);

end

