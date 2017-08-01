%% Processa o tempo de cada rato em cada estágio

control = [41 42 43 44 52 54 55];
se = [47 48 49 50 56 57 58 59 60];

REM = [];
SWS = [];
WAKEA = [];
WAKER = [];
total = [];


rem_p = [];
sd_rem = [];

sws_p = [];
sd_sws = [];

wr_p = [];
sd_wr = [];

wa_p = [];
sd_wa = [];

%#Tempo em numero de epocas, que cada rato (n_rato) passou em cada estado (REM,SWS,WAKER,WAKEA), em cada um dos periodos de 6horas (n_periodo)
ctrl_id = fopen('tempo_ctrl.txt','w');
se_id = fopen('tempo_se.txt','w');

fprintf(ctrl_id,'%12s %12s %12s %12s %12s %12s\n','n_rato','n_periodo','REM','SWS','WAKER','WAKEA')
fprintf(se_id,  '%12s %12s %12s %12s %12s %12s\n','n_rato','n_periodo','REM','SWS','WAKER','WAKEA')

for g = 1:2
	
	if g == 1
		group = control
	else
		group = se
	end
	
	for rat_num = group
			
		for slice_num = [1:4]
			
			if g == 1
				fprintf(ctrl_id,'%12d, %12d,', rat_num , slice_num)
			else
				fprintf(se_id,  '%12d, %12d,', rat_num , slice_num)
			end
			
			rato = sprintf('%d_%d',rat_num,slice_num);
			file = sprintf('/home/vittorfp/Documentos/Neuro/Dados/percentuals/R%s_times.mat',rato);
			load(file);
			
			if g == 1
				fprintf(ctrl_id,' %12d, %12d, %12d, %12d\n', REM_time, SWS_time, WAKE_time, WAKEA_time)
			else
				fprintf(se_id,  ' %12d, %12d, %12d, %12d\n', REM_time, SWS_time, WAKE_time, WAKEA_time)
			end
			
			% Escreve no arquivo
			
			REM = [REM  REM_time];
			SWS = [SWS  SWS_time];
			WAKEA = [WAKEA  WAKEA_time];
			WAKER = [WAKER  WAKE_time];
			total = [total  total_time];

		end
	end
	


	if g == 1
		rem_p = [rem_p mean(REM)*100/mean(total)];
		sd_rem = [sd_rem (std(REM)/sqrt( length(control) )  )*100/mean(total)];

		sws_p = [sws_p mean(SWS)*100/mean(total)];
		sd_sws = [sd_sws (std(SWS)/sqrt( length(control) )  )*100/mean(total)];

		wr_p = [wr_p mean(WAKER)*100/mean(total)];
		sd_wr = [sd_wr (std(WAKER)/sqrt( length(control) )  )*100/mean(total)];

		wa_p = [ wa_p mean(WAKEA)*100/mean(total)];
		sd_wa = [sd_wa (  std(WAKEA)/sqrt(length(control) )  )*100/mean(total)];

		
	else
		rem_p = [rem_p mean(REM)*100/mean(total)];
		sd_rem = [sd_rem (std(REM)/sqrt( length(se) )  )*100/mean(total)];

		sws_p = [sws_p mean(SWS)*100/mean(total)];
		sd_sws = [sd_sws (std(SWS)/sqrt( length(se) )  )*100/mean(total)];

		wr_p = [wr_p mean(WAKER)*100/mean(total)];
		sd_wr = [sd_wr (std(WAKER)/sqrt( length(se) )  )*100/mean(total)];

		wa_p = [ wa_p mean(WAKEA)*100/mean(total)];
		sd_wa = [sd_wa (  std(WAKEA)/sqrt(length(se) )  )*100/mean(total)];

	end
end

d = sprintf('\nState percentual:\n\n\t REM: %.1f\n\t SWS: %.1f\n\tWAKE_R: %.1f\n\tWAKE_A: %.1f',rem_p,sws_p,wr_p,wa_p);
disp(d);

%%
figure(1)
means = [rem_p ;sws_p ;wr_p ;wa_p];
sds = [ sd_rem ;sd_sws ;sd_wr; sd_wa];


bar(1:4,means,'LineWidth',1,'EdgeColor','k');
ax = gca;
ax.OuterPosition = [0 0 1 1];
set(gca,'XTickLabel',{'REM' 'SWS' 'WAKE R' 'WAKE A'});
legend('Ctrl','SE');
legend boxoff
box on
hold on
title('Tempo em cada estado');
ylabel('Porcentagem de tempo');
xlabel('Estado');


m = [];
s = [];
for i = 1:size(means,1)
	for j = 1:size(means,2)
		m = [m means(i,j)];
		s = [s sds(i,j)];
	end
end

e = errorbar([0.86 1.14 1.86 2.14 2.86 3.14 3.86 4.14] ,m',[0 0 0 0 0 0 0 0],s','.');
e.MarkerSize = 1;
e.Color = 'black';
e.LineWidth = 1;
%e.CapSize = 20;
hold off

ylim([-0.1 60]);
grid()
set(gcf,'color','white');
