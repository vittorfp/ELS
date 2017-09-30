%%
% GRUPO 1 = CONTROLE
% GRUPO 2 = EXPERIMENTAL
% GRUPO 3 = TUDO JUNTO

grupo = 3;

totalizador = zeros(24*2,4);
rats = 0;
control    = [41 42 43 44 52 54 55];
experiment = [47 48 49 50 56 57 58 59 60];
todos = [control experiment];
todos = sort(todos);

if(grupo == 3)
	%INIT TODOS
	%Init = [9.5  10.5   7.1   9.1   12.1 6.3   8.1   10.1  1.5   11.7  8.9  2  8.9 8.9 1.1  11  7.6  ];
	Init = [9.5  10.5   7.1   9.1   12.1 6.3   8.1   10.1   11.7  8.9  2  8.9 8.9 1.1  11  7.6  ];
	ratos = todos;
	g = 'All';
end

if(grupo == 1)
	%INIT_CONTROLE
	Init = [9.5  10.5   7.1   9.1   11.7  8.9  2];
	ratos = control;
	
	g = 'Control';
end

if(grupo == 2)
	%INIT_SE
	Init = [12.1 6.3   8.1   10.1   8.9 8.9 1.1  11  7.6  ];
	ratos = experiment;
	
	g = 'SE';
end


for rat_num = ratos
	dia = zeros(size(totalizador));
	
	idx = find(rat_num == ratos);
	
	for slice_num = 1:4
		
		file = sprintf('/home/vittorfp/Documentos/Neuro/Dados/percentuals/R%d_%d_times.mat',rat_num,slice_num);
		load(file,'Estados','total_time');

		seismin = floor( total_time / 60 );

		for i = 0:59
			h = Estados( (i*seismin) + 1 : (i+1)*seismin );

			REM_SLEEP = zeros(size(h));
			SW_SLEEP  = zeros(size(h));
			WAKE_R    = zeros(size(h));
			WAKE_A    = zeros(size(h));

			REM_SLEEP(h == 1) = 1;
			SW_SLEEP (h == 2) = 1;
			WAKE_R   (h == 3) = 1;
			WAKE_A   (h == 4) = 1;

			% Vê qual o percentual de tempo o Ratovsky fica em cada estado
			REM_time   = sum(REM_SLEEP) / seismin;
			SWS_time   = sum(SW_SLEEP)  / seismin;
			WAKE_time  = sum(WAKE_R)    / seismin;
			WAKEA_time = sum(WAKE_A)    / seismin;
			
			
			if Init(idx) >= 24
				Init(idx) = 0;
			end
			
			%hora = floor(Init(idx));% / 0.1;
			%hora = int16(hora);
			
 			if Init(idx) - floor(Init(idx)) < 0.5
 				hora = int16( floor(Init(idx) ) ) + floor(Init(idx));
 			else
 				hora = int16( floor(Init(idx) ) ) + ceil(Init(idx));
 			end

			dia( hora  + 1 ,:) = [SWS_time REM_time  WAKE_time WAKEA_time];
			Init(idx) = Init(idx) + 0.1;
			
			%dia = [dia;SWS_time REM_time  WAKE_time WAKEA_time]; 
			
		end
	end
	
	rats = rats + 1;
	totalizador = totalizador + dia;
end

mean = totalizador/rats;

%mean
%

figure(grupo);
b = bar(mean,1,'stacked');
xlim([0 48.5]);
ylim([0 1]);
title(['Time in each state (' g ')']);
ylabel('% of time');
xlabel('Hour of day');
legend('SWS','REM','WAKE_R','WAKE_A')
legend boxoff
ax = gca;
ax.XTick = [ 0 : 6*2 : 24*2];
ax.XTickLabelMode = 'manual';
ax.XTickLabel = {'0h','6h','12h','18h','24h'};
 
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
box off;

hold on;
sleep = sum(mean(:,1:2),2);
plot(movmean(sleep,4),'LineWidth',3)
hold off;
set(gcf,'color','white');
%legend('SWS','REM','WAKE','WAKE A');
clear file i r s wa wr b
