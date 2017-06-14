%%
totalizador = zeros(24,4);
rats = 0;
control = [41 42 43 44 52 54 55];
experiment = [47 48 49 50 56 57 58 59 60];
todos = [control experiment];

for rat_num = todos
	dia = [];
	for slice_num = 1:4
		
		file = sprintf('/home/vittorfp/Documentos/Neuro/Dados/percentuals/R%d_%d_times.mat',rat_num,slice_num);
		load(file,'Estados','total_time');

		hora = floor(total_time / 6);

		for i = 0:5
			h = Estados( (i*hora) + 1 : (i+1)*hora );

			% Converte de volta para o vetor com os estados em 
			r = find(h == 1);
			s = find(h == 2);
			wr = find(h == 3);
			wa = find(h == 4);

			REM_SLEEP = zeros(1,length(total_time));
			SW_SLEEP = zeros(1,length(total_time));
			WAKE_R = zeros(1,length(total_time));
			WAKE_A = zeros(1,length(total_time));

			REM_SLEEP(r) = 1;
			SW_SLEEP(s) = 1;
			WAKE_R(wr) = 1;
			WAKE_A(wa) = 1;

			% Vê qual o percentual de tempo o Ratovsky fica em cada estado

			REM_time = sum(REM_SLEEP)/hora;
			SWS_time = sum(SW_SLEEP)/hora;
			WAKE_time = sum(WAKE_R)/hora;
			WAKEA_time = sum(WAKE_A)/hora;

			dia = [dia;SWS_time REM_time  WAKE_time WAKEA_time];
		end
	end	
	rats = rats + 1;
	totalizador = totalizador + dia;
end

mean = totalizador/rats;

figure(2);
b = bar(mean,1,'stacked');
xlim([0.5 24.5]);
ylim([0 1]);
title('Time in each state (mean)');
ylabel('% of time');
xlabel('Hour of day (24h)');
ax = gca;
ax.XTick = [1:6:24];
ax.XTickLabelMode = 'manual';
ax.XTickLabel = {'12h','18h','0h','6h','1h'};

ax.YTick = [0:0.2:1];
ax.YTickLabelMode = 'manual';
ax.YTickLabel = {'0%','20%','40%','60%','80%','100%'};


b(1).FaceColor = [100/255 100/255 250/255];
b(1).EdgeColor = [1 1 1];

b(2).FaceColor = [160/255 160/255 230/255];
b(2).EdgeColor = [1 1 1];

b(3).FaceColor = [255/255 100/255 100/255];
b(3).EdgeColor = [1 1 1];

b(4).FaceColor = [255/255 200/255 200/255];
b(4).EdgeColor = [1 1 1];

set(gcf,'color','white');
%legend('SWS','REM','WAKE','WAKE A');
clear file i r s wa wr b