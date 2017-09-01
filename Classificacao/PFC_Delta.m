%% Algorítmo Delta-PFC  Theta-Hipo

slice_num = 1;
rat_num = 42;

percent_mio = 0.38;
percent_td = 0.07;


rato = sprintf('%d_%d',rat_num,slice_num);

% Carrega dados do HIPOCAMPO
file = sprintf('/home/vittorfp/Documentos/Neuro/Dados/Welch/welch_%s.mat',rato);
load(file);

thip = find(f > 4 & f < 12);
ThetaHIPO = sum(psd(:,thip)');

clear psd f thip file

% Carrega dados do CORTEX PRE-FRONTAL
file = sprintf('/home/vittorfp/Documentos/Neuro/Dados/WelchPFC/welch_PFC_%s.mat',rato);
load(file);

dpfc = find(f > 0.5 & f < 4);
DeltaPFC = sum(psd(:,dpfc)');

clear psd f dpfc file
% Carrega dados do MIOGRAMA
file = sprintf('/home/vittorfp/Documentos/Neuro/Dados/WelchPFC/welch_MIO_%s.mat',rato);
load(file);

mi = find(f > 100 & f < 200);
Miograma = sum(psd(:,mi)');

clear psd f dpfc file

% Window Averaging
window_size = 15;

TH = movmean(ThetaHIPO,window_size);
DP = movmean(DeltaPFC,window_size);
MIO = movmean(Miograma,window_size);


% Theta/Delta
TD = TH ./ DP;

%% Thresholds Convencionais

% Obtem o threshold o para o MIO
[f,xi] = ksdensity(MIO);

total = sum(f);

for x = fliplr(xi)
	idx = find(xi > x);
	if sum( f(idx) ) > (total*percent_mio)
		th_mio = x;
		break;
	end
end
fm = f;
clear xi f

% Classifica WAKE
w = find(MIO > th_mio);
WAKE = zeros(1,length(MIO));
WAKE(w) = 1;


% Obtem o threshold o para o T/D
[f,xi] = ksdensity(TD);
total = sum(f);

for x = fliplr(xi)
	idx = find(xi > x);
	if sum( f(idx) ) > (total*percent_td)
		th_td = x;
		break;
	end
end

% Classifica REM
r = find( TD > th_td & WAKE == 0 );
REM = zeros( 1,length(TD) );
REM(r) = 1;

s = find( REM == 0 & WAKE == 0 );
SWS = zeros(1,length(TD));
SWS(s) = 1;
%% Tresholds Aprendidos

problem_MIO = struct('points',MIO','num_classes',2,'num_queries',10);

selector = @unlabeled_selector;
label_oracle = @Oracle;
% Fazer essa função oracle, que plota um gráfico e pede ao usuario pra
% classificar uma epoca.

model = @gaussian_process_model;
% depois trocar o model para um STUMP, que usei no tp de ML
% Criar um handler para uma função que receba os mesmos parâmetros das
% outras funções model, treine um stump com os dados já classificados que
% se encontram disponiveis.


query_strategy = @argmin;
% Pega o ponto que tem a menor diferença do valor do stump

% Rodar uma rotina para classificar o maior de todos os TDs como REM e o
% menor de todos como NOT-WAKE e o maior de todos como WAKE, Para que o
% stump tenha algo para começar.

[chosen_ind, chosen_labels] = active_learning(problem, [], [], label_oracle, selector, query_strategy, model);
% Mudar o codigo do cara para que seja possivel utilizar as 



%% Plota figura para visualização
figure(1);

% Grafico de area com o REM
subplot(4,2,[1 2]);
area([REM' WAKE' SWS']);
legend('REM','WAKE','SWS')
ylim([0 1]);
grid on;
title('Periodos de REM');

% Traçado MIO com o threshold
subplot(4,2,3);
plot(MIO);
hold on;
plot([0 4300],[th_mio th_mio]);
hold off;
grid on;
title('MIO');
legend('Density','Threshold');


% Traçado TD com o threshold
subplot(4,2,4);
plot(TD);
hold on;
plot([0 4300],[th_td th_td]);
hold off;
grid on;
title('Theta/Delta');
legend('Density','Threshold');


% Distribuição de T/D com o threshold
subplot(4,2,[5 7]);
ksdensity(TD);
hold on;
plot([th_td th_td],[0 max(f)]);
legend('Density','Threshold');
hold off;
grid on;
title('T/D Density Estimation');

% Distribuição do miograma
subplot(4,2,[6 8]);
ksdensity(MIO);
hold on;
plot([th_mio th_mio],[0 max(fm)]);
legend('Density','Threshold');
hold off;
grid on;
title('MIO Density Estimation');
grid on

set(gcf,'color','white');


E = zeros(1,length(REM));
E(r) = 1;
E(s) = 2;
E(w) = 3;

load('/home/vittorfp/Documentos/Neuro/Dados/cassificacao_manual/labels-42_1.mat');
Estados(Estados == 4) = 3;
sum(E == Estados(1:length(E)))*100/ length(E)

%% Cria caixa de dialogo pra ver se vai salvar ou não threshold

choice = questdlg('Salvar threshold?', ...
	'Threshold', ...
	'Sim','Não','Não');
% Handle response
disp(choice)
if choice == 'Sim'
	load('/home/vittorfp/Documentos/Neuro/Dados/th.mat');
	th = [th;rat_num slice_num th_td th_mio ];
	save('/home/vittorfp/Documentos/Neuro/Dados/th.mat','th');
end
