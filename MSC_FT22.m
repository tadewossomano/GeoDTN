function Y=MSC_FT22(s,t,f)
dt=t(2)-t(1);
[x y]=meshgrid(f,t);
exp-scale=exp(-1i*pi*x.*y);
Y=s.*exp-scale.*dt;
end