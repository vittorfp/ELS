
function [] = Plota_class(TD,MIO,REM,ACTIVE,REST,SWS)

	% Plota figura para visualização
	figure(1);
	set(gcf, 'Position', get(0, 'Screensize') );
	% Grafico de area com o REM
	subplot(4,2,[1 2]);
	area([REM ACTIVE REST SWS]);
	legend('REM','ACTIVE','REST','SWS')
	grid on;
	title('Periodos de REM');
	ylim([0 1]);

	% Traçado MIO com o threshold
	subplot(4,2,[7 8]);
	plot(MIO);
	hold on;
	%plot([0 4300],[th_mio th_mio]);
	hold off;
	grid on;
	title('MIO');


	% Traçado TD com o threshold
	subplot(4,2,[5 6]);
	plot(TD);
	%hold on;
	%plot([0 4300],[th_td th_td]);
	%hold off;
	grid on;
	title('Theta/Delta');

	% Traçado TD com o threshold
	subplot(4,2,[3 4]);
	stairs(E,'LineWidth',2);
	% hold on
	% stairs(E,'LineWidth',2);
	% hold off
	% legend('Ref','Classificado');
	ylim([0.5 4.5])
	%hold on;
	%plot([0 4300],[th_td th_td]);
	%hold off;
	grid on;
	title('Hipnograma');

	set(gcf,'color','white');

end