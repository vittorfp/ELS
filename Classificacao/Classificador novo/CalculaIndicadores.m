%% Calcula Theta/Delta e o Miograma
function [TD, MIO] = CalculaIndicadores(rat_num,slice_num)

	rato = sprintf('%d_%d',rat_num,slice_num);

	% Carrega dados do HIPOCAMPO
	file = sprintf('/home/vittorfp/Documentos/Neuro/Dados/Multitapers/mtapers_HIPO_%s.mat',rato);
	load(file);

	%thip = find(f > 4.5 & f < 12);
	ThetaHIPO = sum(S(:,f > 4.5 & f < 12)');

	clear S f thip file

	% Carrega dados do CORTEX PRE-FRONTAL
	file = sprintf('/home/vittorfp/Documentos/Neuro/Dados/Multitapers/mtapers_PFC_%s.mat',rato);
	load(file);

	%dpfc = find(f > 0.5 & f < 4);
	DeltaPFC = sum(S(:,f > 0.5 & f < 4)');

	clear psd f dpfc file
	% Carrega dados do MIOGRAMA
	file = sprintf('/home/vittorfp/Documentos/Neuro/Dados/Multitapers/mtapers_MIO_%s.mat',rato);
	load(file);

	%mi = find(f > 100 & f < 200);
	Miograma = sum(S(:,f > 100 & f < 200)');

	clear S f dpfc file

	% Window Averaging
	window_size = 20;
	ws2 = 10;
	TH = movmean(ThetaHIPO,ws2);
	DP = movmean(DeltaPFC,ws2);
	MIO = movmean(Miograma,window_size);


	% Theta/Delta
	TD = TH ./ DP;
	clear TH DP ThetaHIPO DeltaPFC Miograma mi window_size ws2

end