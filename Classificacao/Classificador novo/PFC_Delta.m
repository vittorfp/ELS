%% Algorítmo Delta-PFC  Theta-Hipo
clear 

slice_num = 1;
rat_num = 41;

rato = sprintf('%d_%d',rat_num,slice_num);

% Carrega dados do HIPOCAMPO
file = sprintf('/home/vittorfp/Documentos/Neuro/Dados/Multitapers/mtapers_HIPO_%s.mat',rato);
load(file);

thip = find(f > 4.5 & f < 12);
ThetaHIPO = sum(S(:,thip)');

clear S f thip file

% Carrega dados do CORTEX PRE-FRONTAL
file = sprintf('/home/vittorfp/Documentos/Neuro/Dados/Multitapers/mtapers_PFC_%s.mat',rato);
load(file);

dpfc = find(f > 0.5 & f < 4);
DeltaPFC = sum(S(:,dpfc)');

clear psd f dpfc file
% Carrega dados do MIOGRAMA
file = sprintf('/home/vittorfp/Documentos/Neuro/Dados/Multitapers/mtapers_MIO_%s.mat',rato);
load(file);

mi = find(f > 100 & f < 200);
Miograma = sum(S(:,mi)');

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
%% Tresholds Aprendidos

% MIO
problem_MIO = struct('points',MIO' ,'num_queries',10,'rat_num',rat_num,'slice_num',slice_num,'strs','WAKE');
[WAKE, wk_svm] = ActiveLearnThreshold(problem_MIO,[]);

%TD
problem_TD = struct('points',TD' ,'num_queries',7,'rat_num',rat_num,'slice_num',slice_num,'strs','REM');
[REM , rem_svm] = ActiveLearnThreshold(problem_TD,WAKE);
SWS = (~REM & ~WAKE);


%TD
problem_TD = struct('points',MIO' ,'num_queries',7,'rat_num',rat_num,'slice_num',slice_num,'strs','ACTIVE');
[ACTIVE , act_svm] = ActiveLearnThreshold(problem_TD,~WAKE);
REST = (WAKE & ~ACTIVE);


% Roda para o restante das 6 horas e ve se com o usuario se está tudo ok
for slice = [1 2 3 4]
	
	[WAKE,score] = predict(model,);


	E = zeros(1,length(REM));
	E(REM==1) = 1;
	E(SWS==1) = 2;
	E(REST==1) = 3;
	E(ACTIVE==1) = 4;

	% Converte de volta para o vetor com os estados em 
	REM_SLEEP = zeros(1,length(E));
	SW_SLEEP = zeros(1,length(E));
	WAKE_R = zeros(1,length(E));
	WAKE_A = zeros(1,length(E));

	REM_SLEEP(E == 1) = 1;
	SW_SLEEP(E == 2) = 1;
	WAKE_R(E == 3) = 1;
	WAKE_A(E == 4) = 1;

	% Vê qual o percentual de tempo o Ratovsky fica em cada estado

	total_time = length(REM_SLEEP);
	REM_time = sum(REM_SLEEP);
	SWS_time = sum(SW_SLEEP);
	WAKE_time = sum(WAKE_R);
	WAKEA_time = sum(WAKE_A);


	% Plota figura para visualização
	figure(1);
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

	Estados = E;
	save(sprintf('/home/vittorfp/Documentos/Neuro/Dados/Percentuals_new/R%d_%d_times.mat', rat_num,slice_num ),'total_time','REM_time','SWS_time','WAKE_time','WAKEA_time','Estados');

end

%% Cria caixa de dialogo pra ver se vai salvar ou não threshold

choice = questdlg('Salvar Classificação?', ...
	'Classificação', ...
	'Sim','Não','Não');
% Handle response
disp(choice)
if choice == 'Sim'
	load('/home/vittorfp/Documentos/Neuro/Dados/th.mat');
	th = [th;rat_num slice_num th_td th_mio ];
	save('/home/vittorfp/Documentos/Neuro/Dados/th.mat','th');
end

%%
load('/home/vittorfp/Documentos/Neuro/Dados/cassificacao_manual/labels-42_1.mat');
%Estados(Estados == 4) = 3;
l = min(length(E),length(Estados));

sum( E( 1:l ) == Estados( 1:l ) ) * 100 / l
