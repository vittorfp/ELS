%% Script que faz so subsample dos dados, diminuindo a taxa de amostragem de 2kHz para 1 kHz

folder = '/home/vittorfp/Documentos/Neuro/Dados/ELS_data/'
folder2 = sprintf('%skhz/',folder);
folder3 = sprintf('%sspectrograms/',folder2);

%41:44 47:50 52 54:60
for i = [41:44 47:50 52 54:60] 
   for j = 1:4
    
       T = [];
       var = sprintf('R%dPFC%d',i,j);
	   disp(var);
       T = load( sprintf('%sR%d.mat',folder,i), '-mat', var);
       T = T.(var);
       PFC_1khz = decimate(T, 2);
       clear T; 
       file = sprintf('%sR%dPFC%d_1khz.mat',folder2,i,j);
       save( file ,'PFC_1khz');
       clear PFC_1khz;
       
       T = [];
       var = sprintf('R%dHIPO%d',i,j);
	   disp(var);
       T = load( sprintf('%sR%d.mat',folder,i), '-mat', var);
       T = T.(var);
       HIPO_1khz = decimate(T, 2);
       clear T;
       file = sprintf('%sR%dHIPO%d_1khz.mat',folder2,i,j);
       save( file ,'HIPO_1khz');
       clear HIPO_1khz;
       
       
       
       T = [];
       var = sprintf('R%dMIO%d',i,j);
	   disp(var);
       T = load( sprintf('%sR%d.mat',folder,i), '-mat', var);
       T = T.(var);
       MIO_1khz = decimate(T, 2);
       clear T;
       
       file = sprintf('%sR%dMIO%d_1khz.mat',folder2,i,j);
       save( file ,'MIO_1khz');
       clear MIO_1khz;
  
   end
end

%% Teste: Resample x Downsample x Decimate

%load('/home/vittorfp/Documentos/Neuro/Dados/ELS_data/R42.mat', 'R42HIPO1');
%data = R42HIPO1(1:5000);
%clear R42HIPO1

Dec = decimate(data, 2);
ReS = resample(data,1,2);
DowS  = downsample(data,2);

figure(1)
subplot(4,1,1);
plot(data);
title('Dado Original');
legend('EEG 2khz');
grid();

subplot(4,1,2);
plot(Dec);
title('Decimate x Downsample');hold on; plot(DowS);hold off;
legend('Decimate','Downsample');
grid();

subplot(4,1,3);
plot(ReS);
title('Resample x Decimate');hold on; plot(Dec);hold off;
legend('Resample','Decimate');
grid();

subplot(4,1,4);
plot(DowS);
title('Downsample x Resample');hold on; plot(ReS);hold off;
legend('Downsample','Resample');
grid();
set(gcf,'color','white');
%decimate != downsample ( downsample parece mais fiel ao dado, o dacimate
%deixa o dado meio quebrado

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
