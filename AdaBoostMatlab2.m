%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
clear all
% Define plot style parameters
plotstyle.colors = {'gs', 'ro'};  % color for each class
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
        plot(x, y, plotstyle.colors{(Y(i)+3)/2}, 'MarkerFaceColor', plotstyle.colors{(Y(i)+3)/2}(1), 'MarkerSize', 2);
    else
        break
    end
end
[Nfeatures, Nsamples] = size(X); 
%%% 웨이트 만들기
D = ones(1,Nsamples) / Nsamples;

%%
%%%직선 분류 Feature 만들기 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% x축에 대해서 데이터 생성
sortX = sort(X(1,:));
WeakData = ones(1,3); %가로인지(1) 세로인지(2), 좌표, 왼쪽 혹은 위가 +1인가 -1 지역인가?
WeakCount = 1;
for j=1:Nsamples-1
    %가로 x면 1, 세로 y면 2  
    WeakData(WeakCount,:) = [1, ( sortX(j)+sortX(j+1) )/2, +1];
    WeakCount = WeakCount + 1;
    WeakData(WeakCount,:) = [1, ( sortX(j)+sortX(j+1) )/2, -1];
    WeakCount = WeakCount + 1;
end

%%% y축에 대해서 데이터 생성
sortY = sort(X(2,:));
for j=1:Nsamples-1
    %가로 x면 1, 세로 y면 2  
    WeakData(WeakCount,:) = [2, ( sortY(j)+sortY(j+1) )/2, +1];
    WeakCount = WeakCount + 1;
    WeakData(WeakCount,:) = [2, ( sortY(j)+sortY(j+1) )/2, -1];
    WeakCount = WeakCount + 1;
end
WeakCount = WeakCount - 1;
disp( sprintf('Feature 개수는 : %d', WeakCount) );
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%반복횟수
T = 500;

%T개의 특징과 알파
TrainWeak = ones(1,2);

%%
for tIndex=1:T

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Weak Classifier를 이용하여 최고 작은 에러를 찾는다.
tTError=[0];
%%% 특징에 대한 모든 에러를 구하고 그 중 가장 작은 에러값을 찾는다. 그 에러에 대한 특징요소들도 저장하고 있어야 함.
for j=1:WeakCount
    Error=0;
    %%j번째 특징에 대해서 error값을 구한다.
    for k=1:Nsamples
        %%X데이터가 왼쪽 +1 클래스 인가?
        if(WeakData(j,2) >  X(WeakData(j,1),k))
            if(WeakData(j,3) ~= Y(k) ) 
                %잘못 구별되어 웨이트를 더함
                Error = Error + D(1,k);
            end
        else
            if( WeakData(j,3)*-1 ~= Y(k) )
                %잘못 구별되어 웨이트를 더함
                Error = Error + D(1,k);
            end
        end
    end
    tTError(j)=[ Error];
end

% tTError에 feature에 대한 error값이 들어있다. 이중에 최고 작은 Error값을 찾고 그 Weak를 선택
[sortTError,sortIndex]=sort(tTError);

%최고 작은 에러값으로 알파값을 구한다.
alpha = 0.5 * log( (1-sortTError(1,1)) / sortTError(1,1) ) ;

%알파값과 약분류기를 저장(feature=분류방법)
TrainWeak(tIndex, :) = [sortIndex(1,1),alpha];

%weight 업데이트
for j=1:Nsamples
    %%X데이터가 왼쪽 +1 클래스 인가?
    if(WeakData(sortIndex(1,1),2) >  X(WeakData(sortIndex(1,1),1),j))
        if(WeakData(sortIndex(1,1),3) ~= Y(j) ) 
            %잘못 구별됨
            D(1,j) = D(1,j) * exp(alpha);
        else
            %잘 구별됨
            D(1,j) = D(1,j) * exp(-alpha);
        end
    else
        if( WeakData(sortIndex(1,1),3)*-1 ~= Y(j) )
            %잘못 구별되어 웨이트를 더함
            D(1,j) = D(1,j) * exp(alpha);
        else
            %잘 구별됨
            D(1,j) = D(1,j) * exp(-alpha);
        end
    end
end

disp( sprintf('%d 번째', tIndex));
disp( sprintf('error %f', sortTError(1,1) ));
disp( sprintf('alpha %f' ,alpha));
disp( sprintf('z %f' , sum(D) ));

D = D / sum(D);

disp(D);

disp('============================ next round ==========================================')


end


%% 입력데이터에 대한 분류 시작
%데이터 만들기
inData = [-50:50 ; ones(1,101)*50 ];
for i=-49:50
    temp = [-50:50 ; ones(1,101)*i ];
    inData = [inData , temp];
end

[c,s] = size(inData);
inDataResult = ones(1,s); %+1 인지 -1 인지 결과를 담을 매트릭스


%입력 데이터에 대한 j 번째 검사 
for j=1:s
H=0;
A=0;
Sigma=0;

for i=1:T
    %입력 데이터에 대한 약분류기 T개로 검사
  
    %Alpha를 구함
    A = TrainWeak(i,2);
    %H(x)를 구함
    if(WeakData( TrainWeak(i,1) , 2 ) >  inData( WeakData( TrainWeak(i,1),1) , j  )) 
        %구별 영역의 왼쪽
        H=WeakData( TrainWeak(i,1) , 3 );
    else
        %구별 영역의 오른쪽
        H=WeakData( TrainWeak(i,1) , 3 ) * -1;
    end
    
    Sigma = Sigma + (A*H);

end

inDataResult(1,j) = sign(Sigma);
end

figure(2);
clf %clear current figure window
axis(plotstyle.range); hold on
axis('square')
title('Strong Classifier -> H(x)')

color={'g','r'};

for i=1:s
    plot( inData(1,i), inData(2,i), color{(inDataResult(1,i)+3)/2}  );
end


for i=1:Nsamples
    x = X(1,i);
    y = X(2,i);    
    plot(x, y, plotstyle.colors{(Y(i)+3)/2}, 'MarkerFaceColor', plotstyle.colors{(Y(i)+3)/2}(1), 'MarkerSize', 2);    
end







