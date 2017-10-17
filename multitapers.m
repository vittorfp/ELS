%% Multitapers spectrogram
clear

folder2 = sprintf('/home/vittorfp/Documentos/Neuro/Dados/khz/');

destino = '/home/vittorfp/Documentos/Neuro/Dados/Multitapers';

% PARAMETROS
df = 1;
window = 5;
step = window;
srate = 1000;

TW = window*df/2;
K = floor(2*TW) - 1;

% Tresholds
th_mio = 15;
th_pfc = 9;
th_hipo = 9;


% ANIMAIS
control = [41 42 43 44 52 54 55];
se = [47 48 49 50 56 57 58 59 60];
r = [control se];
slices = [1 2 3 4];

% ADEQUAÇÂO PARA TESTES
r = 41;
slices = 1;

n_rats = length(r);

for rat_num = r
	for slice_num = slices
		
		
		file = sprintf('%sR%dHIPO%d_1khz.mat',folder2,rat_num,slice_num);
        disp('Processando LFP:');
		disp(file);
		load(file, 'HIPO_1khz');
				
		file = sprintf('%sR%dMIO%d_1khz.mat',folder2,rat_num,slice_num);
        disp('Processando LFP:');
		disp(file);
		load(file, 'MIO_1khz');
		
		
		file = sprintf('%sR%dPFC%d_1khz.mat',folder2,rat_num,slice_num);
        disp('Processando LFP:');
		disp(file);
		load(file, 'PFC_1khz');

		m = mean(MIO_1khz);
		utreshold =  m + (th_mio*std(MIO_1khz)); 
		ltreshold = m - (th_mio*std(MIO_1khz));
		A = find(MIO_1khz > utreshold | MIO_1khz < ltreshold)';
		
		
		m = mean(PFC_1khz);
		utreshold =  m + (th_pfc*std(PFC_1khz)); 
		ltreshold = m - (th_pfc*std(PFC_1khz));
		A = [A find(PFC_1khz > utreshold | PFC_1khz < ltreshold)'];
		
		
		m = mean(HIPO_1khz);
		utreshold =  m + (th_hipo*std(HIPO_1khz)); 
		ltreshold = m - (th_hipo*std(HIPO_1khz));
		A = [A find(HIPO_1khz > utreshold | HIPO_1khz < ltreshold)'];
		
		
		eA = ceil( A ./ (window*srate) );
		eA = unique(eA);
		
		for i = eA
			range = 1 + (i - 1) * window*srate:i*window*srate;
			HIPO_1khz(range) = 0;
			MIO_1khz(range) = 0;
			PFC_1khz(range) = 0;
		end


		params = struct('Fs',srate,'tapers',[TW K],'fpass',[0 50]);
		[S,t,f] = mtspecgramc(HIPO_1khz,[window step],params);

		save(sprintf('%s/mtapers_HIPO_%d_%d.mat',destino,rat_num,slice_num),'S','t','f');
		
		params = struct('Fs',srate,'tapers',[TW K],'fpass',[0 50]);
		[S,t,f] = mtspecgramc(PFC_1khz,[window step],params);
		
		save(sprintf('%s/mtapers_PFC_%d_%d.mat',destino,rat_num,slice_num),'S','t','f');
		
		params = struct('Fs',srate,'tapers',[TW K], 'fpass',[100 200]);
		[S,t,f] = mtspecgramc(MIO_1khz,[window step],params);
		
		save(sprintf('%s/mtapers_MIO_%d_%d.mat',destino,rat_num,slice_num),'S','t','f');
		
	end
end
clear 

%% carrega um dado

th_mio = 15;
th_pfc = 9;
th_hipo = 9;

%load('/home/vittorfp/Documentos/Neuro/Dados/khz/R41MIO1_1khz.mat')
load('/home/vittorfp/Documentos/Neuro/Dados/khz/R41HIPO1_1khz.mat')
%load('/home/vittorfp/Documentos/Neuro/Dados/khz/R41PFC1_1khz.mat')

dado = HIPO_1khz;
%dado = MIO_1khz;
%dado = PFC_1khz;


% PARAMETROS
df = 1;
window = 10;
step = 5;
srate = 1000;


TW = window*df /2;
K = floor(2*TW) - 1;

figure(2)
subplot(3,1,1)
plot(dado)
title('Traçado do miograma')
xlim([0 length(dado)]);

%

m = mean(dado);
utreshold =  m + (th_hipo*std(dado)); 
ltreshold = m - (th_hipo*std(dado));

A = find(dado > utreshold | dado < ltreshold);
eA = ceil( A/(window*srate) );
eA = unique(eA);
%
for i = eA'
	range = 1 + (i - 1) * window*srate:i*window*srate;
	dado(range) = 0;
end

%
params = struct('Fs',srate,'tapers',[TW K] ,'fpass',[0 50]);
[S,t,f] = mtspecgramc(dado,[window step],params);

%
subplot(3,1,2)
imagesc(flipud(log(S)'))
colormap jet
title('Espectro do miograma')

%%
params = struct('Fs',srate,'tapers',[TW K] ,'fpass',[0 50]);
[S,t,f] = mtspecgramc(PFC_1khz,[window step],params);

%%
subplot(3,1,3)
imagesc(flipud(log(S)'))
colormap jet
title('Espectro do PFC')
	
