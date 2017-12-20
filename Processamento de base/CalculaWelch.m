%% Script que calcula welch para todos os ratos
clear

folder2 = sprintf('/home/vittorfp/Documentos/Neuro/Dados/khz/');

destino = '/home/vittorfp/Documentos/Neuro/Dados/Welch';
s_rate = 1000;     %% Hertz
tamanho_epoca = 5; %% Segundos

control = [41 42 43 44 52 54 55];
se = [47 48 49 50 56 57 58 59 60];
r = [control se];

n_rats = length(r);
for rat_num = r

	for slice_num = [1 2 3 4]
		
		%Carrega os dados
		rato = sprintf('%d_%d',rat_num,slice_num);
		file = sprintf('/home/vittorfp/Documentos/Neuro/Dados/percentuals/R%s_times.mat',rato);
		load(file,'Estados');
		disp(rato);
		clear file

		len = length(Estados);
		
		file = sprintf('%sR%dHIPO%d_1khz.mat',folder2,rat_num,slice_num);
		load(file, 'HIPO_1khz');

		clear file Estados

		% Percorre o vetor das epocas que são REM
		disp('Calculando ...');
		psd = [];
		for i = 1:len
			
			index = s_rate * tamanho_epoca * (i) ;
			index_fim = index + (tamanho_epoca * s_rate);
			epoca = HIPO_1khz(index:index_fim);
			[pxx,f] = pwelch(epoca,[],[],[],s_rate);
			psd = [psd ; pxx'];
		
		end
		disp('Salvando ...');
		save(sprintf('%s/welch_%s.mat',destino,rato),'psd','f');
	end

end