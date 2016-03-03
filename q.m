function prob=q(n,i,p);
if(n<i)
  prob=0;
else
  prob=nchoosek(n,i)*p^i*(1-p)^(n-i);
end;
