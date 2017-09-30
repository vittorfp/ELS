%% Algorítmo Delta-PFC  Theta-Hipo

slice_num = 1;
rat_num = 42;

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
window_size = 20;
ws2 =10;
TH = movmean(ThetaHIPO,ws2);
DP = movmean(DeltaPFC,ws2);
MIO = movmean(Miograma,window_size);


% Theta/Delta
TD = TH ./ DP;
clear TH DP ThetaHIPO DeltaPFC Miograma mi window_size ws2
%% Tresholds Aprendidos

% MIO
problem_MIO = struct('points',MIO' ,'num_queries',10,'rat_num',rat_num,'slice_num',slice_num,'strs','WAKE');
WAKE = ActiveLearnThreshold(problem_MIO,[]);

%TD
problem_TD = struct('points',TD' ,'num_queries',7,'rat_num',rat_num,'slice_num',slice_num,'strs','REM');
REM = ActiveLearnThreshold(problem_TD,WAKE);
SWS = (~REM & ~WAKE);


%TD
problem_TD = struct('points',MIO' ,'num_queries',7,'rat_num',rat_num,'slice_num',slice_num,'strs','ACTIVE');
ACTIVE = ActiveLearnThreshold(problem_TD,~WAKE);
REST = (WAKE & ~ACTIVE);


%
E = zeros(1,length(REM));
E(REM==1) = 1;
E(SWS==1) = 2;
E(REST==1) = 3;
E(ACTIVE==1) = 4;

%%
load('/home/vittorfp/Documentos/Neuro/Dados/cassificacao_manual/labels-42_1.mat');
%Estados(Estados == 4) = 3;
sum(E == Estados(1:length(E)))*100 / length(E)

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
subplot(4,2,[3 4]);
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


% Distribuição de T/D com o threshold
%subplot(4,2,[5 7]);
%ksdensity(TD);
%hold on;
%plot([th_td th_td],[0 max(f)]);
%legend('Density','Threshold');
%%hold off;
%grid on;
%title('T/D Density Estimation');

% Distribuição do miograma
%subplot(4,2,[6 8]);
%ksdensity(MIO);
%hold on;
%plot([th_mio th_mio],[0 max(fm)]);
%legend('Density','Threshold');
%hold off;
%grid on;
%title('MIO Density Estimation');
%grid on

set(gcf,'color','white');


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
