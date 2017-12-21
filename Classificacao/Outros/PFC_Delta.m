%% Algorítmo Delta-PFC  Theta-Hipo
clear 
%control = [41 42 43 44 52 54 55];
control = [ ];
%se = [47 48 49 50 56 57 58 59 60];
se = [59 60];
r = [control se];

for rato = r
	for slice = [1 2 3 4]
		slice_num = slice;
		rat_num = rato;

		[TD, MIO] = CalculaIndicadores(rat_num,slice_num);


		% Tresholds Aprendidos

		% MIO
		problem_MIO = struct('points',MIO' ,'num_queries',10,'rat_num',rat_num,'slice_num',slice_num,'strs','WAKE');
		[WAKE, wk_svm] = ActiveLearnThreshold(problem_MIO,[]);

		%TD
		problem_TD = struct('points',TD' ,'num_queries',15,'rat_num',rat_num,'slice_num',slice_num,'strs','REM');
		[REM , rem_svm] = ActiveLearnThreshold(problem_TD,WAKE);
		%SWS = (~REM & ~WAKE);


		%TD
		problem_TD = struct('points',MIO' ,'num_queries',7,'rat_num',rat_num,'slice_num',slice_num,'strs','ACTIVE');
		[ACTIVE , act_svm] = ActiveLearnThreshold(problem_TD,~WAKE);
		%REST = (WAKE & ~ACTIVE);


		% Roda para o restante das 6 horas e ve se com o usuario se está tudo ok

		[TD, MIO] = CalculaIndicadores(rat_num,slice);

		[WAKE,~] = predict(wk_svm,MIO');
		[REM,~] = predict(rem_svm,TD');
		[ACTIVE,~] = predict(act_svm,MIO');
		SWS = (~REM & ~WAKE);
		REST = (WAKE & ~ACTIVE);


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

		Plota_class(TD,MIO,REM,ACTIVE,REST,SWS,E)

		Estados = E;

		choice = questdlg('A Classificação ficou OK para esse periodo de 6 horas? ', ...
			'Classificação', ...
			'Sim','Não',...
			'Não');

		% Handle response
		if strcmp(choice, 'Sim')
			save(sprintf('/home/vittorfp/Documentos/Neuro/Dados/Percentuals_new/R%d_%d_times.mat', rat_num,slice_num ),'total_time','REM_time','SWS_time','WAKE_time','WAKEA_time','Estados');
			save(['/home/vittorfp/Documentos/Neuro/Dados/SVMs/svms_' num2str(rat_num) '_' num2str(slice_num) '.mat' ], 'wk_svm', 'rem_svm', 'act_svm');
		end
		
	end
end

%% Cria caixa de dialogo pra ver se vai salvar ou não threshold

choice = questdlg('Salvar Classificação?', ...
	'Classificação', ...
	'Sim','Não','Não');
% Handle response
disp(choice)
if strcmp(choice, 'Sim')
	load('/home/vittorfp/Documentos/Neuro/Dados/th.mat');
	th = [th;rat_num slice_num th_td th_mio ];
	save('/home/vittorfp/Documentos/Neuro/Dados/th.mat','th');
end

%%
load('/home/vittorfp/Documentos/Neuro/Dados/cassificacao_manual/labels-42_1.mat');
%Estados(Estados == 4) = 3;
l = min(length(E),length(Estados));

sum( E( 1:l ) == Estados( 1:l ) ) * 100 / l
