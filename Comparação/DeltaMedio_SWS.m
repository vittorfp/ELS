%% Pontência média em DELTA
clear;
control = [41 42 43 44 52 54 55];
se = [47 48 49 50 56 57 58 59 60];

md_ctrl = [];
md_se = [];

ctrl_id = fopen('deltaM_ctrl.txt','w');
se_id = fopen('deltaM_se.txt','w');

fprintf(ctrl_id,'%12s, %12s\n','n_rato','delta_medio')
fprintf(se_id,  '%12s, %12s\n','n_rato','delta_medio')



for g = 1:2
	
	if g ==1
		group = control;
	else
		group = se;
	end
	
	
	for rat_num = group

		n_eps = 0;
		med = 0;
		sum = 0;
		n_sws = 0;
			
		for slice_num = 1:4
			
			
			%Carrega os dados
			rato = sprintf('%d_%d',rat_num,slice_num);
			file = sprintf('/home/vittorfp/Documentos/Neuro/Dados/percentuals/R%s_times.mat',rato);
			load(file,'Estados');
			file = sprintf('/home/vittorfp/Documentos/Neuro/Dados/scaled/R%s_scaled.mat',rato);
			load(file);
			
			in_sws = 0;
			%n_sws = 0;
			count = 0;
			for e = Estados
			
				count = count + 1;
				
				if ( e == 2 )
					
					if (in_sws == 0)
						in_sws = 1;
						%sum = 0;
						n_eps = n_eps + 1;
					end
					
					sum = sum + Delta_scaled(count);

					n_sws = n_sws + 1;
					
				else % e ~= 1
				
					if(in_sws == 1)
						med = med + sum;
						in_sws = 0;
						%n_sws = 0;
					end
					
				end
				
			end

			
		end
		
		if g ==1
			md_ctrl = [md_ctrl sum/n_sws];
			fprintf(ctrl_id,  '%12d, %12d\n',rat_num,sum/n_sws);

		else
			md_se = [md_se sum/n_sws];
			fprintf(se_id,  '%12d, %12d\n',rat_num,sum/n_sws);
		end
		
	end
end
%%




means = [mean(md_ctrl)  mean(md_se)];
sds = [std(md_ctrl)/sqrt(length(control))  std(md_se)/sqrt(length(se) )];


%means = [meanst; meansg];
%sds = [sdst ; sdsg];

figure(1)
bar(1:2,[means ;0 0],'LineWidth',1,'EdgeColor','k');
%ax = gca;
set(gca,'XTickLabel',{''});
legend('Ctrl','SE');
legend boxoff

title('Potencia media em Delta durante SWS');
ylabel('Potencia media normalizada');
set(gca,'XTickLabel',{'Delta'});
xlim([0.5 1.5]);
ylim([-0.0005 0.6]);
hold on

e = errorbar( [0.86 1.14 ; 1.86 2.14], [means;0 0],[0 0; 0 0], [sds;0 0],'.','MarkerSize',1,'Color','black','LineWidth',1);
%e.MarkerSize = 1;
%e.Color = 'black';
%e.LineWidth = 1;
grid();
hold off

	
set(gcf,'color','white');


saveas(1,'pMedD_sws.fig');
saveas(1,'pMedD_sws.png');
saveas(1,'pMedD_sws.svg');