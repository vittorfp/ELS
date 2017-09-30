%% Multitapers spectrogram

% carrega um dado
load('/home/vittorfp/Documentos/Neuro/Dados/ELS_data/R42.mat');

%%
df = 0.5;
window = 5;
step = window;

TW = window*df/2;
K = floor(2*TW) - 1;

params = struct('Fs',1000,'tapers', [TW K],'fpass',[0 50]);
[S,t,f] = mtspecgramc(h,[window step],params);

