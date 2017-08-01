%% Pontência média em Theta
clear;
control = [41 42 43 44 52 54 55];
se = [47 48 49 50 56 57 58 59 60];

mt_ctrl = [];
mt_se = [];

mg_ctrl = [];
mg_se = [];


ctrl_id = fopen('remMed_ctrl.txt','w');
se_id = fopen('remMed_se.txt','w');

fprintf(ctrl_id,'%12s, %12s, %12s\n','n_rato','theta_medio','gamma_medio')
fprintf(se_id,  '%12s, %12s, %12s\n','n_rato','theta_medio','gamma_medio')


for g = 1:2
	
	if g ==1
		group = control;
	else
		group = se;
	end
	
	
	for rat_num = group

		n_eps = 0;
		medt = 0;
		medg = 0;
		
		for slice_num = 1:4
			
			
			%Carrega os dados
			rato = sprintf('%d_%d',rat_num,slice_num);
			file = sprintf('/home/vittorfp/Documentos/Neuro/Dados/percentuals/R%s_times.mat',rato);
			load(file,'Estados');
			file = sprintf('/home/vittorfp/Documentos/Neuro/Dados/scaled/R%s_scaled.mat',rato);
			load(file);
			
			in_rem = 0;
			n_rem = 0;
			count = 0;
			for e = Estados
			
				count = count + 1;
				
				if ( e == 1 )
					
					if (in_rem == 0)
						in_rem = 1;
						sumt = 0;
						sumg = 0;
						n_eps = n_eps + 1;
					end
					
					sumt = sumt + Theta_scaled(count);

					sumg = sumg + Gamma_scaled(count);
					n_rem = n_rem + 1;
					
				else % e ~= Estados
				
					if(in_rem == 1)
						medt = medt + sumt/n_rem;
						medg = medg + sumg/n_rem;

						in_rem = 0;
						n_rem = 0;
					end
					
				end
				
			end

			
		end
		
		if g ==1
			mt_ctrl = [mt_ctrl medt/n_eps];
			mg_ctrl = [mg_ctrl medg/n_eps];
			fprintf(ctrl_id,'%12f, %12f, %12f\n',rat_num, medt/n_eps, medg/n_eps)
			
		else
			mt_se = [mt_se medt/n_eps];
			mg_se = [mg_se medg/n_eps];
			fprintf(se_id,  '%12f, %12f, %12f\n',rat_num, medt/n_eps, medg/n_eps)

		end
		
	end
end
%%


meanst = [mean(mt_ctrl)  mean(mt_se)];
sdst = [std(mt_ctrl)/sqrt(length(control))  std(mt_se)/sqrt(length(se) )];

meansg = [mean(mg_ctrl)  mean(mg_se)];
sdsg = [std(mg_ctrl)/sqrt( length(control))  std(mg_se)/sqrt( length(se) )];

%means = [meanst; meansg];
%sds = [sdst ; sdsg];

figure(1)
bar(1:2,[meanst ;0 0],'LineWidth',1,'EdgeColor','k');
%ax = gca;
set(gca,'XTickLabel',{''});
legend('Ctrl','SE');
legend boxoff

title('Potencia media em Theta durante o REM');
ylabel('Potencia media normalizada');
set(gca,'XTickLabel',{'Theta'});
xlim([0.5 1.5]);
ylim([-0.002 0.8]);
hold on

e = errorbar( [0.86 1.14 ; 1.86 2.14], [meanst;0 0],[0 0; 0 0], [sdst;0 0],'.','MarkerSize',1,'Color','black','LineWidth',1);
%e.MarkerSize = 1;
%e.Color = 'black';
%e.LineWidth = 1;
grid();
hold off

	
set(gcf,'color','white');


figure(2)
bar(1:2,[meansg ;0 0],'LineWidth',1,'EdgeColor','k');
%ax = gca;
set(gca,'XTickLabel',{''});
legend('Ctrl','SE');
legend boxoff

title('Potencia media em Gamma durante o REM');
ylabel('Potencia media normalizada');
set(gca,'XTickLabel',{'Gamma'});
xlim([0.5 1.5]);
ylim([-0.0003 0.15]);
hold on

e = errorbar( [0.86 1.14 ; 1.86 2.14], [meansg;0 0],[0 0; 0 0], [sdsg;0 0],'.','MarkerSize',1,'Color','black','LineWidth',1);
%e.MarkerSize = 1;
%e.Color = 'black';
%e.LineWidth = 1;
grid();
hold off

	
set(gcf,'color','white');

