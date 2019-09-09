% Retorna convolucion de vector x y vector y multiplicando sus FFT
% si opt == 1 los vectores estan en tiempo
% si opt == 2 x esta FFT y shifteada y y en tiempo

function c = fastConv(x,y, opt) 
        % los convierto a la fuerza en columnas    
        x = x(:) ; 
        y = y(:) ; 
        
    if(opt==1)
        l_c     = length(x) + length(y) -1 ;
        NFFT    = pow2(nextpow2(l_c)) ; 

        A = ifft(fft([x; zeros(NFFT-length(x) , 1)]) .* fft([y; zeros(NFFT-length(y) , 1)]) ) ; 

        c = A(1:l_c) ; 
        
    else % aqui el x ya esta fft shifteada solo zero padeo al y 
        
        NFFT = length(x) ; 
        
        c = ifft( x .* fftshift( fft( [y; zeros(NFFT - length(y) , 1)] ) )  );
        
    end

end