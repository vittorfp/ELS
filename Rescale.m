%% Faz o feature scalling das variáveis

folder = '/home/vittorfp/Documentos/Neuro/Dados/light/';
folder2 = '/home/vittorfp/Documentos/Neuro/Dados/scaled/';

for rat_num = [41:44 47:50 52 54:60] 
	for slice_num = 1:4	
	   
		file = sprintf('%sR%d_%d_spectrogram.mat',folder,rat_num,slice_num);
		load(file);

		p_total = sum([Delta_s;Theta_s;Gamma_s]);
		
		Delta_scaled = [];
		Theta_scaled = [];
		Gamma_scaled = [];
	
		% Reescala as variaveis usando a potencia total em cada época
		Delta_scaled = Delta_s./p_total;
		Theta_scaled = Theta_s./p_total;
		Gamma_scaled = Gamma_s./p_total;
		
		% Normaliza o EMG, o colocando em uma escala de 0 a 1
		Emg_scaled =  (Emg_s - min(Emg_s) ) / (max(Emg_s) - min(Emg_s)) ;
		
		file = sprintf('%sR%d_%d_scaled.mat',folder2,rat_num,slice_num);
		save(file,'Delta_scaled','Theta_scaled','Gamma_scaled','Emg_scaled');
		
	end
end