clear all
close all
clc
%% CARGA MATRIZ DE DATOS DESEADA

% load raw_puntal_sim.mat
% load raw_1taget_bandaX.mat
% load raw_aeropuerto.mat

%% DEFINICION DE PARAMETROS
c       = 3e8 ; 
lambda  = c / Fc ; % Fc es la frec de portadora del satelite
R0      = .5*c* (te + Tp) ; 

rang_ob = @(idx) R0 + (idx-1)*.5*c/fs ; % me da las distancias del rango 

BW_3db  =  .886 * lambda / La ; % ancho de banda del beam 
chirp_BW_Az = 2*Vr*.886/La ; 

%%
s = createChirp(chirp_BW, Tp, fs); % le doy fs porque es en rango, el chirp es positivo 



D = size(raw) ; 
% un for que recorre todas las filas de raw
for i=1:D(1)
    RangComp(i,:) = fastConv( raw(i,:) , s, 1) ;  % le doy opt 1 porque todo esta en tiempo
end


%% Agarramos la RangComp y fftamos las cols 
% D = size(RangComp) ; 
% FFT de azimut
[AzFFT , f_az] = fft_bonita(RangComp , PRF) ; 


%% Correccion en rango 
N_az = size(AzFFT) ; 
% creamos vector de R inicial Ri
Ri = rang_ob(1: N_az(2)) ; 

% creamos el vector de R final Rf, literalmente modificaremos el eje 

for k = 1 : N_az(1)
    
    Rf = Ri * ( 1 + (1/8)*(lambda*f_az(k)/Vr)^2) ;
    
    % interpolamos porque el Rf puede que no exista en Ri
    AzFFT_corrected(k,:) = interp1(Ri, AzFFT(k,:), Rf, 'PCHIP' , NaN) ; 
    
    % notemos que size(AzFFT_corrected) = size(AzFFT)
end

%% comprimimos en azimut, cada convolucion en cada col va con un chirp diferente

% dado que la matriz ya está en FFT, uso fastConv con opción 2
N_az = size(AzFFT_corrected) ; 

for k=1:N_az(2)
    Tp_az   = (BW_3db/Vr) * rang_ob(k) ;
    
    % le doy PRF porque es en azimut, el chirp es negativo porque asi lo dijo Dios
    s_az    = exp(-j*4*pi*R0/lambda) * createChirp(-chirp_BW_Az, Tp_az, PRF); 
    
    AzComp(:,k) = fastConv( AzFFT_corrected(:,k) , s_az,2) ; % le doy opt 2 porque el primro esta en FFT shifteada
    
   
end
