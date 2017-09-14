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
clear TH DP 
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
%% Tresholds Aprendidos MIO

problem_MIO = struct('points',MIO' ,'num_queries',10,'rat_num',rat_num,'slice_num',slice_num);

x = [ find(  min(problem_MIO.points)  == problem_MIO.points ) ; find(  max(problem_MIO.points)  == problem_MIO.points ) ] ;
y = [0; 1];																																											
%

c = 1;
strs = {'Dormindo','Acordado'};
for i = 1:problem_MIO.num_queries

	model = fitcsvm(problem_MIO.points(x) , y ,'KernelFunction','rbf','BoxConstraint',Inf,'ClassNames',[0,1]);
	[label,score] = predict(model,problem_MIO.points); 

	 	
 	a = ones(size(label));
 	a(x) = 0;
 	a = logical(a);
	
	x_star = find(   score( :, c) == min( score( a ,c))   );
	
	x_star = x_star + randi([1 length(problem_MIO.points)-x_star ],1);
	
	% observe point(s)
	
	
	y_star = Oracle(problem_MIO, x_star,MIO,x,y ,strs);
	

	% add observation(s) to training set
	x = [x; x_star];
	y = [y; y_star];
	

	if c == 1 
		c = 2;
	elseif c == 2
		c = 1;
	end
	
end

model = fitcsvm(problem_MIO.points(x), y,'KernelFunction','rbf','BoxConstraint',Inf,'ClassNames',[0,1]);
[WAKE,score] = predict(model,problem_MIO.points);

figure(2)
subplot(2,1,1)
area(WAKE)
subplot(2,1,2)
plot(MIO)
hold on;
color = y;
color(color == 0) = 2;
scatter(x,MIO(x),30,color,'filled');
hold off;
grid on;

%% Tresholds Aprendidos TD

problem_TD = struct('points',TD' ,'num_queries',10,'rat_num',rat_num,'slice_num',slice_num);

x = [ find(  min(problem_TD.points)  == problem_TD.points ) ; find(  max(problem_TD.points)  == problem_TD.points ) ] ;
y = [0; 1];
%

c = 1;
strs = {'SWS','REM'};
for i = 1:problem_MIO.num_queries

	model = fitcsvm(problem_TD.points(x) , y ,'KernelFunction','rbf','BoxConstraint',Inf,'ClassNames',[0,1]);
	[label,score] = predict(model,problem_TD.points); 

	 	
 	a = ones(size(label));
 	a(x) = 0;
	a(WAKE) = 0;
 	a = logical(a);
	
	x_star = find(   score( :, c) == min( score( a ,c))   );
	
	x_star = x_star + randi([1 length(problem_TD.points)-x_star ],1);
	
	% observe point(s)
	
	
	y_star = Oracle(problem_TD, x_star,TD,x,y ,strs);
	

	% add observation(s) to training set
	x = [x; x_star];
	y = [y; y_star];
	

	if c == 1 
		c = 2;
	elseif c == 2
		c = 1;
	end
	
end

model = fitcsvm(problem_TD.points(x), y,'KernelFunction','rbf','BoxConstraint',Inf,'ClassNames',[0,1]);
[REM,score] = predict(model,problem_TD.points);

figure(2)
subplot(2,1,1)
area(REM)
subplot(2,1,2)
plot(TD)
hold on;
color = y;
color(color == 0) = 2;
scatter(x,TD(x),30,color,'filled');
hold off;
grid on;

%% Plota figura para visualização
figure(1);

REM= [];
SWS = [];

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
sum(E == Estados(1:length(E)))*100 / length(E)

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
