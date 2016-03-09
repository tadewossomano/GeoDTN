function Y=MSC_FT(s,t,f)
dt=t(2)-t(1);
Y=zeros(100);
scale=zeros(100);
[X V]=meshgrid(f,t);
scale=exp(-1*1i*2*pi.*X.*V);
Y=s*scale*dt;
end