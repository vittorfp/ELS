% cd /home/cleitonlab/Desktop/Divididos/Nova' Pasta Com Itens'/
% load('R42_1_1kHz.mat');
% 
% Dado = R42HIPO1_1khz;
% disp('Oi! Os dados foram carregados para a memoria, comecando a processar...')
% 
% [delta] = eegfilt(Dado',1000,1,4);
% save('R42_filt.mat','delta');
% disp('Dados filtrados na frequencia Delta. Aperte enter para prosseguir')
% pause
% [theta] = eegfilt(Dado',1000,5,12);
% save('R42_filt.mat','theta','-append');
% disp('Dados filtrados na frequencia Theta. Aperte enter para prosseguir')
% pause
% 
% %Ja rodei essa parte ai de cima, os dados estao salvos no arquivo
%R42_filt.mat


% m = floor(length(Dado)/10000) ; % número de épocas (de 10s)
% 
% n = 10000; %Tamanho de cada epoca
% 
% Epocas_delta = zeros(m,n);
% Epocas_theta = zeros(m,n);
% 
% 
%  for i=1:m
% 
%      a = 1 + ( i - 1 ) * n;
% 
%      b = i*n;
% 
%      Epocas_delta(i,:) = delta(a:b);
%      Epocas_theta(i,:) = theta(a:b);
%  end
% save('R42_filt.mat','Epocas_delta', 'Epocas_theta','-append');
% disp('Dado dividido em epocas. Aperte enter para prosseguir')
% pause
% 
% clear a b i m n

s = size(Epocas);
pot = zeros(s(1),2);      %Constroi uma matriz para abrigar a potencia do theta e do delta
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                srate=1000;
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                WINDOW=10;
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                NOVERLAP=1;

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                %(1) EMG - separa epocas com movimento e sem (atonia)

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                [S,F,T,P] = spectrogram(EMG,WINDOW*srate,NOVERLAP*srate,[],srate);


for i=1:s(1)
   
   [pxx,f] = pwelch(Epocas(i,:),10000,300,512,1000);                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            
   pot(i,1) = sum(pxx(1:4));    %delta
   pot(i,2) = sum(pxx(5:12));   %theta
   
end
clear i m n a b %dado  

[EMG_filtrado] = eegfilt('R42PFC1_1khz',1000,300,500);


figure(1);
set(1, 'Position', [1 1 1000 200])
subplot(3,1,1)
plot(pot(500:1000,1),'DisplayName','R42HIPO1_1khz','YDataSource','R42HIPO1_1khz');
xlim([0 500])
ylabel('Potencia em Delta')
title('Plots')

subplot(3,1,2)
plot(pot(500:1000,2),'DisplayName','R42PFC1_1khz','YDataSource','R42PFC1_1khz');
xlim([0 500])
ylabel('Potencia em Theta')

subplot(3,1,3)
plot(R42MIO1_1khz(12600000:12610000),'DisplayName','R42HIPO1_1khz','YDataSource','R42HIPO1_1khz');
xlim([0 10000])
ylabel('Miograma')
