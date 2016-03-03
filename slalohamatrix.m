function M=slalohamatrix(m,qa,qr)

% crea una matrice vuota
M=zeros([m+1 m+1]);

% calcola tutti gli elementi della matrice
for id=1:m+1,
  for jd=id-1:m+1,
    if ( jd == 0 )
      continue;
    end;
    n=id-1; % mi trovo allo stato n=i-1
    % quattro casi
    if ( id == jd ) % da n rimango a n
      M(id,jd)=q(m-n,1,qa)*q(n,0,qr)+q(m-n,0,qa)*(1-q(n,1,qr));
    elseif ( jd == id-1 ) % da n vado a n-1
      M(id,jd)=q(m-n,0,qa)*q(n,1,qr);
    elseif ( jd == id+1 ) % da n vado a n+1
      M(id,jd)=q(m-n,1,qa)*(1-q(n,0,qr));
    else % da n vado a n+(jd-id)
      M(id,jd)=q(m-n,jd-id,qa);
    end;
  end;
end;

