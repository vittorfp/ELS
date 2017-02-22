%subsample 
cd /home/cleitonlab/Desktop/Divididos/Nova' Pasta Com Itens'/
load('R42.mat');
clear R42HIPO2
clear R42HIPO3
clear R42HIPO4

clear R42MIO2
clear R42MIO3
clear R42MIO4

clear R42PFC2
clear R42PFC3
clear R42PFC4

R42HIPO1_1khz = decimate(R42HIPO1,2);
clear R42HIPO1
R42MIO1_1khz = decimate(R42MIO1,2);
clear R42MIO1
R42PFC1_1khz = decimate(R42PFC1,2);
clear R42PFC1
save('R42_1kHz.mat',R42HIPO1_1khz,R42MIO1_1khz,R42PFC1_1khz)



% Plot da figura
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
