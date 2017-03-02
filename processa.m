cd /home/cleitonlab/Desktop/Divididos/Nova' Pasta Com Itens'/
load('R42_1_1kHz.mat');

Dado = R42HIPO1_1khz;
disp('Oi! Os dados foram carregados para a memoria, comecando a processar...')

[delta] = eegfilt(Dado',1000,1,4);
save('R42_filt.mat','delta');
disp('Dados filtrados na frequencia Delta. Aperte enter para prosseguir')
pause
[theta] = eegfilt(Dado',1000,5,12);
save('R42_filt.mat','theta','-append');
disp('Dados filtrados na frequencia Theta. Aperte enter para prosseguir')
pause

%Ja rodei essa parte ai de cima, os dados estao salvos no arquivo
%R42_filt.mat


m = floor(length(Dado)/10000) ; % número de épocas (de 10s)

n = 10000; %Tamanho de cada epoca

Epocas_delta = zeros(m,n);
Epocas_theta = zeros(m,n);


 for i=1:m

     a = 1 + ( i - 1 ) * n;

     b = i*n;

     Epocas_delta(i,:) = delta(a:b);
     Epocas_theta(i,:) = theta(a:b);
 end
save('R42_filt.mat','Epocas_delta', 'Epocas_theta','-append');
disp('Dado dividido em epocas. Aperte enter para prosseguir')
pause

clear a b i m n

s = size(Epocas_delta);
pot = zeros(s(1),2);      %Constroi uma matriz para abrigar a potencia do theta e do delta

for i=1:s(1)
    
   pot(i,1) = ( norm(Epocas_delta(i,:) ) ^ 2 ) / s(2);
   pot(i,2) = ( norm(Epocas_theta(i,:) ) ^ 2 ) / s(2);
   
end
clear i m n a b dado    