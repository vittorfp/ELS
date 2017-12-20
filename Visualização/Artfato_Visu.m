%%
load('/home/vittorfp/Documentos/Neuro/Dados/khz/R42HIPO1_1khz.mat')
%% COM ARTEFATO
s_rate = 1000;
e = HIPO_1khz(0.556*10000000:0.559*10000000);

figure(1);
subplot(2,1,1);
plot(e);


subplot(2,1,2);
[pxx,f] = pwelch(e,[],[],[],s_rate);
m = pxx .* f;
plot(f,m)
%ylim([0 0.02])
xlim([0 200])

%% SEM ARTEFATO

e = HIPO_1khz(0.559*10000000:0.562*10000000);

figure(2);
subplot(2,1,1);
plot(e);


subplot(2,1,2);
[pxx,f] = pwelch(e,[],[],[],s_rate);
m = pxx .* f;
plot(f,m)
%ylim([0 0.02])
xlim([0 200])
