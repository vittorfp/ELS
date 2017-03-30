%Script que faz so subsample dos dados, diminuindo a taxa de amostragem de 2kHz para 1 kHz

%41:44 47:50 52 54:60
for i = [ 47:50 52 54:60 ] 
   for j = 1:4
       T = [];
       var = sprintf('R%dPFC%d',i,j);
       T = load( sprintf('/home/vittorfp/Documentos/Neuro/Dados/ELS_data/R%d.mat',i), '-mat', var);
       T = T.(var);
       PFC_1khz = decimate(T, 2);
       clear T; 
       file = sprintf('/home/vittorfp/Documentos/Neuro/Dados/ELS_data/khz/R%dPFC%d_1khz.mat',i,j);
       save( file ,'PFC_1khz');
       clear PFC_1khz;
       
       T = [];
       var = sprintf('R%dHIPO%d',i,j);
       T = load( sprintf('/home/vittorfp/Documentos/Neuro/Dados/ELS_data/R%d.mat',i), '-mat', var);
       T = T.(sprintf('R%dHIPO%d',i,j));
       HIPO_1khz = decimate(T, 2);
       clear T;
       file = sprintf('/home/vittorfp/Documentos/Neuro/Dados/ELS_data/khz/R%dHIPO%d_1khz.mat',i,j);
       save( file ,'HIPO_1khz');
       clear HIPO_1khz;
       
       
       
       T = [];
       var = sprintf('R%dMIO%d',i,j);
       T = load( sprintf('/home/vittorfp/Documentos/Neuro/Dados/ELS_data/R%d.mat',i), '-mat', var);
       T = T.(var);
       MIO_1khz = decimate(T, 2);
       clear T;
       
       file = sprintf('/home/vittorfp/Documentos/Neuro/Dados/ELS_data/khz/R%dMIO%d_1khz.mat',i,j);
       save( file ,'MIO_1khz');
       clear MIO_1khz;
   end
end

%% Plot da figura
cd /home/cleitonlab/Desktop/Divididos/Nova' Pasta Com Itens'/
load('R42_1_1kHz.mat')

figure(1);
set(1, 'Position', [1 1 1000 200])
subplot(3,1,1)
plot(R42HIPO1_1khz(12600000:12610000),'DisplayName','R42HIPO1_1khz','YDataSource','R42HIPO1_1khz');
xlim([0 10000])
ylabel('LFP Hipocampo')
title('Plots')

subplot(3,1,2)
plot(R42PFC1_1khz(12600000:12610000),'DisplayName','R42PFC1_1khz','YDataSource','R42PFC1_1khz');
xlim([0 10000])
ylabel('LFP Cortex pre frontal')

subplot(3,1,3)
plot(R42MIO1_1khz(12600000:12610000),'DisplayName','R42HIPO1_1khz','YDataSource','R42HIPO1_1khz');
xlim([0 10000])
ylabel('Miograma')
