function Y=MSC_FT3(s1,x,f,y,f2)
dx=x(2)-x(1);
dy=y(2)-y(1);
%Y=zeros(100);
%y2=zeros(100);
%scale=zeros(100);
%scale2=zeros(100);
[X V]=meshgrid(f,x);
scale=exp(-1*1i*2*pi.*X.*V);
y2=s1*scale;
[X V]=meshgrid(f2,y);
scale2=exp(-1*1i*2*pi.*X.*V);
Y=(y2'.*scale2)*dy*dx;
end