%%
function [label] = Oracle(problem, query_ind, caracteristica , x , y , strs)

	% Carrega dados do rato
	load(['/home/vittorfp/Documentos/Neuro/Dados/khz/R' num2str(problem.rat_num) 'HIPO' num2str(problem.slice_num) '_1khz.mat']);
	load(['/home/vittorfp/Documentos/Neuro/Dados/khz/R' num2str(problem.rat_num) 'MIO' num2str(problem.slice_num) '_1khz.mat']);
	load(['/home/vittorfp/Documentos/Neuro/Dados/light/R' num2str(problem.rat_num) '_' num2str(problem.slice_num) '_spectrogram.mat']);
	
	
	% Parâmetros do dado
	Frequencia_amostral = 1000; % Hz
	Tamanho_epoca = 5; % Segundos
	
	% Parâmetros auxiliares
	t = 0: 1/Frequencia_amostral : length(HIPO_1khz)/Frequencia_amostral;
	epocas = length(Theta_s);
	label = [];
	t2 = 1:epocas;
	rato = [num2str(problem.rat_num) '_' num2str(problem.slice_num)];
	
	% Plota as epocas escolhidas (EMG/LFP)	
	for epoca = query_ind
		
		range = 1 + (epoca - 1) * Tamanho_epoca*Frequencia_amostral :  (epoca*Tamanho_epoca*Frequencia_amostral) - 1;
	
		figure(2);
		set(gcf, 'Position', get(0, 'Screensize'));
		subplot(4,2,[1 2]);
		plot(t(range)',HIPO_1khz(range));
		ylim([-0.7 0.7]);
		grid();
		ti = sprintf('LFP Hipocampus %s',rato);
		title(ti);
		xlabel('Tempo(s)');
		
		
		subplot(4,2,[3 4]);
		plot(t(range),...
			MIO_1khz(range));
		ylim([-0.7 0.7]);
		grid();
		title('Miogram');
		xlabel('Tempo(s)');
		
		subplot(2,1,2)
		plot(caracteristica)
		hold on;
		color = y;
		color(color == 0) = 2;
		scatter(x,caracteristica(x),30,color,'filled');
		hold off;
		grid on;

		% Pergunta o estado via janelinha
		clear HIPO_1khz MIO_1khz Estados Emg Theta Delta Gamma Theta_s Delta_s Gamma_s Emg_s

		[s,v] = listdlg('PromptString','Classifique:',...
					'SelectionMode','single',...
					'Name','Classificação',...
					'ListSize',[200 100], ...
					'ListString',strs);


		% Recebe o resultado
		if(v ~= 0)
			label = [label s-1];
		end
		
		% Fecha o plot
		%close(2);
	
	end
	
end