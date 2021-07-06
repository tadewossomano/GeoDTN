% 19/12/2012 - Lab. experience n.10

clear all;close all;

I = imread('lena_gray.jpg');        %lena_gray    prova
[Height,Width,Depth] = size(I);

if Depth > 1
    I = double(rgb2gray(I));         
else
    I = double(I);
end

clear Depth;

%% Estrazione dei blocchi.

blockWidth = 8;
blockHeight = 8;
numBlocchi = (Width/blockWidth)*(Height/blockHeight);

blocchi = zeros(blockHeight,blockWidth,(Width/blockWidth),(Height/blockHeight));

for i_t=1:(Width/blockWidth)
    for j_t=1:(Height/blockHeight)
        temp_t=I((j_t-1)*blockHeight+1:(j_t)*blockHeight,(i_t-1)*blockWidth+1:(i_t)*blockWidth);        
        blocchi(:,:,i_t,j_t)=temp_t;      
        %figure, imshow(uint8(blocchi(:,:,i_t,j_t)));  pause;
    end
end

clear -regexp _t;

%% 

dimDizio = 256;
indice_X = round(1+63.*rand(dimDizio,1));
indice_Y = round(1+63.*rand(dimDizio,1));

dizionario = zeros(blockHeight,blockWidth,dimDizio);
for i_t=1:dimDizio;
    dizionario(:,:,i_t) = blocchi(:,:,indice_X(i_t),indice_Y(i_t));
end

clear -regexp _t;

%% 



distorsione = zeros(dimDizio,1);
indiciMinimi = zeros(numBlocchi,1);

for i_t=1:numBlocchi
    
    bloccoI = trainingSet(:,:,i_t);                     %blocco i_t
    
    for j_t=1:dimDizio
        
        codeWordJ = dizionario(:,:,j_t);
        
        distorsione(j_t) = sum(abs(bloccoI-codeWordJ).^2);
        
    end
    
    min(distorsione(j_t));
    
    
    
end













