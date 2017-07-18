%% latencia até primeiro REM do bloco de dados (6h)

control = [41 42 43 44 52 54 55];
se = [47 48 49 50 56 57 58 59 60];

l_se = zeros(4,size(se,2) );
l_ctrl =  zeros(4,size(control,2) );


ctrl_id = fopen('latencia_ctrl.txt','w');
se_id = fopen('latencia_se.txt','w');

fprintf(ctrl_id,'%12s, %12s, %12s\n','n_rato','n_periodo','latencia')
fprintf(se_id,  '%12s, %12s, %12s\n','n_rato','n_periodo','latencia')



for g = 1:2
	if g ==1
		group = control;
	else
		group = se;
	end
	
	for rat_num = group
		for slice_num = 1:4
			%Carrega os dados
			rato = sprintf('%d_%d',rat_num,slice_num);
			file = sprintf('/home/vittorfp/Documentos/Neuro/Dados/percentuals/R%s_times.mat',rato);
			load(file,'Estados');
			
			in_sws = 0;
			lat = 0;
			
			for e = Estados
				if in_sws == 0
					if e == 2
						in_sws = 1;
						lat = 1;
					end
				else
					if e == 1
						break;
					else
						lat = lat + 1;
					end
				end
			end
			
			if g == 1
				l_ctrl(slice_num,find(control == rat_num) ) =  lat;
			else
				l_se(slice_num,find(se == rat_num) ) =  lat;
			end
			
				
		end
	end
end
%
mc = mean(l_ctrl);
ms = mean(l_se);

means = [mean(mc) mean(ms)] .* 0.083333333;
sds = [std(mc)/sqrt( length(control) ) std(ms)/sqrt(length(se) )].* 0.083333333;

%%
figure(1)
%means = [mean(eps_c)  mean(eps_s)];
%sds = [std(eps_c) ; std(eps_s)];


bar(1:2,[means;0 0],'LineWidth',1,'EdgeColor','k');
ax = gca;
set(gca,'XTickLabel',{'' });
legend('Ctrl','SE');
legend boxoff

title('Latencia do primeiro episodio de REM');
ylabel('Latencia (Minutos)');
xlabel('');
xlim([0.5 1.5]);

hold on


e = errorbar([0.86 1.14 1.86 2.14] ,[means 0 0],[0 0 0 0],[sds 0 0],'.');
e.MarkerSize = 1;
e.Color = 'black';
e.LineWidth = 1;
hold off
%ylim([- 800]);
grid();

set(gcf,'color','white');