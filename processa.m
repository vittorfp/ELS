cd /home/cleitonlab/Desktop/Divididos/Nova' Pasta Com Itens'/
load('R42_1_1kHz.mat');

Dado = R42HIPO1_1khz;
[delta] = eegfilt(Dado',1000,1,4);
[theta] = eegfilt(Dado',1000,5,12);


m = floor(length(dado)/10000) ; % número de épocas (de 10s)

n = 10000; %Tamanho de cada epoca

Epocas_delta = zeros(m,n);
Epocas_theta = zeros(m,n);

 for i=1:m

     a = 1 + ( i - 1 ) * n;

     b = i*n;

     Epocas_delta(i,:) = delta(a:b);
     Epocas_theta(i,:) = theta(a:b);
 end

 
s = size(Epocas_delta);
pot = zeros(s(1),2);      %Constroi uma matriz para abrigar a potencia do theta e do delta

for i=1:s(1)
    
   pot(i,1) = ( norm(Epocas_delta(i,:) ) ^ 2 ) / s(2);
   pot(i,2) = ( norm(Epocas_theta(i,:) ) ^ 2 ) / s(2);
   
end
clear i m n a b dado    