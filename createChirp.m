function s = createChirp(chirp_BW, Tp, fs)

% la ctte loca del chirp
K   = chirp_BW / Tp ; 

% armamos el h
t   = -Tp/2 : 1/fs : (Tp/2 - 1/fs) ;  
t   = t(:) ; 

s   = conj(exp(j*pi*K* (t.^2) )) ; 
s   = s(:) ; % lo regresa como columna
    
end