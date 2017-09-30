%% Plota gráficos com os estados do rato ao longo das 24h
%% Pega os dados

Y = [];
Init = [9.5  10.5   7.1   9.1   12.1 6.3   8.1   10.1  1.5   11.7  8.9  2  8.9 8.9 1.1  11  7.6  ];
ratos = [41:44 47:50 52 54:60];
for rat_num = ratos
	for slice_num = 1:4

		rato = sprintf('%d_%d',rat_num,slice_num);
		file = sprintf('/home/vittorfp/Documentos/Neuro/Dados/percentuals/R%s_times.mat',rato);
		load(file);
		Y = [Y ;WAKEA_time/total_time WAKE_time/total_time SWS_time/total_time REM_time/total_time ];
	end
end

%% Plota gráfico de barras
figure(21);
b = bar(Y,0.97,'stacked');
%ylim([0 1]);

%for i = 1:4
%	b(i).LineWidth = 0.0000001;
	%b(i).Width = 1;
%end
b(1).FaceColor = [200/255 240/255 200/255];
%b(1).EdgeColor = [200/255 240/255 200/255];

b(2).FaceColor = [ 85/255 220/255 200/255];
%b(2).EdgeColor = [ 85/255 220/255 200/255];

b(3).FaceColor = [ 85/255 151/255 221/255];
%b(3).EdgeColor = [ 85/255 151/255 221/255];

b(4).FaceColor = [ 85/255  20/255 201/255];
%b(4).EdgeColor = [ 85/255  20/255 201/255];

legend('WAKE A','WAKE','SWS','REM');