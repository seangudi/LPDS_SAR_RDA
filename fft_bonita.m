% FFT sobre cols de matriz signal con frec de muestreo fs

function [X_k, frec] = fft_bonita( signal , fs) 
% el 1 en la fftshift es para que aplique el shift sobre las filas de la
% matriz, es decir, agarra una columna y fftshiftea las filas prro
X_k = fftshift(fft(signal , 2^(nextpow2( size(signal,1))) ) , 1); 

L= size(X_k,1) ; 

frec  = -fs/2 : fs/L : (fs/2 - fs/L) ;  %vector fila

end

