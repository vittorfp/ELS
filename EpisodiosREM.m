%% Episodios de REM

control = [41 42 43 44 52 54 55];
se = [47 48 49 50 56 57 58 59 60];

eps_s = zeros(size(se));
eps_c = zeros(size(control));


ctrl_id = fopen('eps_ctrl.txt','w');
se_id = fopen('eps_se.txt','w');

fprintf(ctrl_id,'%12s, %12s, %12s\n','n_rato','n_periodo','epoca_inicio')
fprintf(se_id,  '%12s, %12s, %12s\n','n_rato','n_periodo','epoca_inicio')


for g = 1:2
	
	if g ==1
		group = control;
	else
		group = se;
	end
	
	for rat_num = group
		
		for slice_num = 1:4
			count = 0;
			%Carrega os dados
			rato = sprintf('%d_%d',rat_num,slice_num);
			file = sprintf('/home/vittorfp/Documentos/Neuro/Dados/percentuals/R%s_times.mat',rato);
			load(file,'Estados');
			
			in_rem = 0;
			
			for e = Estados
			
				count = count + 1;
				if ( e == 1 ) 
			
					if (in_rem == 0)
					
						if g == 1
	
							eps_c(find(control == rat_num) ) = eps_c(find(control == rat_num) ) + 1;
							fprintf(ctrl_id,'%12d, %12d, %12d\n', rat_num, slice_num, count)
						
						else
							
							eps_s(find(se == rat_num) ) = eps_s(find(se == rat_num) ) + 1;
							fprintf(se_id,  '%12d, %12d, %12d\n', rat_num, slice_num, count)
						
						end

						in_rem = 1;
					end
					
				else
					in_rem = 0;
				end	
			end
			
		end
	end
end
%%
figure(1)

means = [mean(eps_c)  mean(eps_s)];
sds = [std(eps_c)/sqrt(length(control) ) ; std(eps_s)/sqrt( length(se) ) ];

bar(1:2,[means;0 0],'LineWidth',1,'EdgeColor','k');
%ax = gca;
set(gca,'XTickLabel',{''});
legend('Ctrl','SE');
legend boxoff

title('Numero de episodios de REM');
ylabel('Episodios de sono REM');
xlabel('');
xlim([0.5 1.5]);
ylim([-0.1 50]);
hold on

e = errorbar([0.86 1.14 1.86 2.14] ,[means 0 0],[0 0 0 0],[sds; 0; 0],'.');
e.MarkerSize = 1;
e.Color = 'black';
e.LineWidth = 1;
hold off
grid();

set(gcf,'color','white');
