%% Script para pegar a PSD dos ratos
clear

folder2 = sprintf('/home/vittorfp/Documentos/Neuro/Dados/khz/');

s_rate = 1000;     %% Hertz
tamanho_epoca = 5; %% Segundos

control = [41 42 43 44 52 54 55];
se = [47 48 49 50 56 57 58 59 60];
r = [control se];

n_rats = length(r);
for rat_num = r
	
	rato_rem = [];
	rato_sws = [];
	rato_wake = [];
	
	figure(1);
	for slice_num = [1 2 3 4]
		
		%Carrega os dados
		rato = sprintf('%d_%d',rat_num,slice_num);
		
		file = sprintf('/home/vittorfp/Documentos/Neuro/Dados/percentuals/R%s_times.mat',rato);
		load(file,'Estados');
		file = sprintf('/home/vittorfp/Documentos/Neuro/Dados/Welch/welch_%s.mat',rato);
		load(file);

		disp(rato);
		clear file rato

		REM = find(Estados == 1);
		SWS = find(Estados == 2);
		WAKE = find(Estados == 3 | Estados == 4);

		for i = 1:length(f')
			psd(i,:) = psd(i,:) .* f';
		end
		
		psd_rem = psd(REM,:);
		psd_sws = psd(SWS,:);
		psd_wake = psd(WAKE,:);
		
		subplot(1,5,slice_num)
		plot(f,mean(psd_rem) );
		xlim([0 40]);
		title(sprintf('Epoca %d',slice_num))
		hold on
		plot(f,mean(psd_sws) );


		plot(f,mean(psd_wake) );
		hold off;
		grid();
		legend('REM','SWS','WAKE');	
		

		rato_rem = [rato_rem ; psd_rem];
		rato_sws = [rato_sws; psd_sws];
		rato_wake = [ rato_wake ; psd_wake];
	
	end

	subplot(1,5,5)
	plot(f,mean(rato_rem) );
	title('Media')
	hold on;
	plot(f,mean(rato_sws) );
	plot(f,mean(rato_wake) );
	xlim([0 40]);
	grid();
	hold off
	
	
	set(gcf,'color','white');
	x0=0;
	y0=0;
	width=1300;
	height=240;
	set(gcf,'units','points','position',[x0,y0,width,height])	
	disp('Salvando figura... ');
	saveas(1,sprintf('/home/vittorfp/Documentos/Neuro/Graficos/PSD/fig/PSD_rato%d.fig',rat_num));
	saveas(1,sprintf('/home/vittorfp/Documentos/Neuro/Graficos/PSD/png/PSD_rato%d.png',rat_num));
	saveas(1,sprintf('/home/vittorfp/Documentos/Neuro/Graficos/PSD/svg/PSD_rato%d.svg',rat_num));
	
end