%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%AdaBoost submitted to Prof. Alberto Signoroni,
%Tadewos Somano ,92045
%Melkamsew Tenaw ,
% 
% 
% 
% 

%%
clear all
% Define plot style parameters
plotstyle.colors = {'g*', 'r+'};  % color for each class
plotstyle.range = [-50 50 -50 50]; % data range


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Create data: use the mouse to build the training dataset.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
figure(1); 
clf %clear current figure window
axis(plotstyle.range); hold on
axis('square')
title('Left button = class +1, right button = class -1. Press any key to finish.')
i  = 0; clear X Y

while 1
    [x,y,c] = ginput(1);
    if ismember(c, [1 3])
        i = i + 1;
        X(1,i) = x;
        X(2,i) = y;
        Y(i) = (c==1) - (c==3); % class = {-1, +1}
        plot(x, y, plotstyle.colors{(Y(i)+3)/2}, 'MarkerFaceColor', plotstyle.colors{(Y(i)+3)/2}(1), 'MarkerSize', 8);
    else
        break
    end
end


[Nfeatures, Nsamples] = size(X); 
D = ones(1,Nsamples) / Nsamples;

%%
%%% Feature 
sortX = sort(X(1,:));
WeakData = ones(1,3); 
WeakCount = 1;
for j=1:Nsamples-1 
    WeakData(WeakCount,:) = [1, ( sortX(j)+sortX(j+1) )/2, +1];
    WeakCount = WeakCount + 1;
    WeakData(WeakCount,:) = [1, ( sortX(j)+sortX(j+1) )/2, -1];
    WeakCount = WeakCount + 1;
end

%%% 
sortY = sort(X(2,:));
for j=1:Nsamples-1 
    WeakData(WeakCount,:) = [2, ( sortY(j)+sortY(j+1) )/2, +1];
    WeakCount = WeakCount + 1;
    WeakData(WeakCount,:) = [2, ( sortY(j)+sortY(j+1) )/2, -1];
    WeakCount = WeakCount + 1;
end
WeakCount = WeakCount - 1;
disp( sprintf('Feature Â : %d', WeakCount) );
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%

T = 160; %iterations 
TrainWeak = ones(1,2);

%%%classification of Data
for tIndex=1:T

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
tTError=[0];
for j=1:WeakCount
    Error=0;
    for k=1:Nsamples 
        if(WeakData(j,2) >  X(WeakData(j,1),k))%(WeakData(sortIndex(1,1),2) >  X(WeakData(sortIndex(1,1),1),j))
            if(WeakData(j,3) ~= Y(k) ) 
                Error = Error + D(1,k);
            end
        else
            if( WeakData(j,3)*-1 ~= Y(k) )
               
                Error = Error + D(1,k);
            end
        end
    end
    tTError(j)=[ Error];
end

[sortTError,sortIndex]=sort(tTError);


alpha =  0.5*log( (1-sortTError(1,1)) / sortTError(1,1) ) ;%calculate alpha


TrainWeak(tIndex, :) = [sortIndex(1,1),alpha];

tTError;
sortTError;
sortIndex;
alpha;


for j=1:Nsamples %changing the weight value D
   
    if(WeakData(sortIndex(1,1),2) >  X(WeakData(sortIndex(1,1),1),j))
        if(WeakData(sortIndex(1,1),3) ~= Y(j) ) 
            
            D(1,j) = D(1,j) * exp(alpha);
        else
           
            D(1,j) = D(1,j) * exp(-alpha);
        end
    else
        if( WeakData(sortIndex(1,1),3)*-1 ~= Y(j) )
           
            D(1,j) = D(1,j) * exp(alpha);
        else
           
            D(1,j) = D(1,j) * exp(-alpha);
        end
    end
end

disp( sprintf('%d ¹øÂ°', tIndex));
disp( sprintf('error %f', sortTError(1,1) ));
disp( sprintf('alpha %f' ,alpha));
disp( sprintf('z %f' , sum(D) ));
D = D / sum(D); %Normalize D
disp(D);

disp('============================ next round ==========================================')


end


%%%%%%%%%%%%%%5

inData = [-50:50 ; ones(1,101)*50 ];
for i=-49:50
    temp = [-50:50 ; ones(1,101)*i ];
    inData = [inData , temp];
end

[c,s] = size(inData);
inDataResult = ones(1,s); 

 
for j=1:s
H=0;
A=0;
Sigma=0;

for i=1:T
   
    A = TrainWeak(i,2);
    
    if(WeakData( TrainWeak(i,1) , 2 ) >  inData( WeakData( TrainWeak(i,1),1) , j  )) 
        
        H=WeakData( TrainWeak(i,1) , 3 );
    else
        
        H=WeakData( TrainWeak(i,1) , 3 ) * -1;
    end
    
    Sigma = Sigma + (A*H);

end

inDataResult(1,j) = sign(Sigma);
end
%}
figure(2);
clf %clear current figure window
axis(plotstyle.range); hold on
axis('square')
title('Strong Classifier -> H(x)')

color={'c-','mo'};

for i=1:3:s
    plot( inData(1,i), inData(2,i), color{(inDataResult(1,i)+3)/2},'MarkerSize', 3 );
end


for i=1:Nsamples
    x = X(1,i);
    y = X(2,i);    
    plot(x, y, plotstyle.colors{(Y(i)+3)/2}, 'MarkerFaceColor', plotstyle.colors{(Y(i)+3)/2}(1), 'MarkerSize', 6);    
end







