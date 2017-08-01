%% Testes estatisticos
% Episodios de REM

clear;
file1 = sprintf('/home/vittorfp/Documentos/Neuro/Dados/estatisticas/eps_ctrl.txt');
file2 = sprintf('/home/vittorfp/Documentos/Neuro/Dados/estatisticas/eps_se.txt');

ctrl = csvread(file1,1,0);
se = csvread(file2,1,0);

u = unique(ctrl(:,1));
c = [];
for rato = u'
	c = [c sum(double(ctrl(:,1) == rato)) ];
end

u = unique(se(:,1));
s = [];
for rato = u'
	s = [s sum(double(se(:,1) == rato)) ];
end
disp('Episodios REM')
[h,p] = ttest2(s,c);
fprintf('Hipotese = %d; P = %12f\n\n',h,p);

% Latencia ao 1o REM

clear;
file1 = sprintf('/home/vittorfp/Documentos/Neuro/Dados/estatisticas/latencia_ctrl.txt');
file2 = sprintf('/home/vittorfp/Documentos/Neuro/Dados/estatisticas/latencia_se.txt');

ctrl = csvread(file1,1,0);
se = csvread(file2,1,0);


u = unique(ctrl(:,1));
c = [];
for rato = u'
	c = [c mean(ctrl(find(ctrl(:,1) == rato),3) ) ];
end


u = unique(se(:,1));
s = [];
for rato = u'
	s = [s mean(se( find(se(:,1) == rato),3) ) ];
end

disp('Latencia ao 1o REM')
[h,p] = ttest2(s,c);
fprintf('Hipotese = %d; P = %12f\n\n',h,p);

% Theta e Gamma Medio

clear;
file1 = sprintf('/home/vittorfp/Documentos/Neuro/Dados/estatisticas/remMed_ctrl.txt');
file2 = sprintf('/home/vittorfp/Documentos/Neuro/Dados/estatisticas/remMed_se.txt');

ctrl = csvread(file1,1,0);
se = csvread(file2,1,0);

% Theta 
disp('Theta')
[h,p] = ttest2(se(:,2),ctrl(:,2));
fprintf('Hipotese = %d; P = %12f\n\n',h,p);

% Gamma 
disp('Gamma')
[h,p] = ttest2(se(:,3),ctrl(:,3));
fprintf('Hipotese = %d; P = %12f\n\n',h,p);

% Delta Medio

clear;
file1 = sprintf('/home/vittorfp/Documentos/Neuro/Dados/estatisticas/deltaM_ctrl.txt');
file2 = sprintf('/home/vittorfp/Documentos/Neuro/Dados/estatisticas/deltaM_se.txt');

ctrl = csvread(file1,1,0);
se = csvread(file2,1,0);

disp('Delta Medio no SWS')
[h,p] = ttest2( ctrl(:,2),se(:,2) );
fprintf('Hipotese = %d; P = %12f\n\n',h,p);

% Tempo em cada estado


clear;
file1 = sprintf('/home/vittorfp/Documentos/Neuro/Dados/estatisticas/tempo_ctrl.txt');
file2 = sprintf('/home/vittorfp/Documentos/Neuro/Dados/estatisticas/tempo_se.txt');

ctrl = csvread(file1,1,0);
 se  = csvread(file2,1,0);

rem = 3;
sws = 4;
war = 5;
waa = 6;

u = unique(ctrl(:,1));

c_rem = [];
c_sws = [];
c_wr = [];
c_wa = [];

for rato = u'
	c_rem = [c_rem  sum( ctrl( find( ctrl(:,1) == rato ) , rem ) ) ];
	c_sws = [c_sws  sum( ctrl( find( ctrl(:,1) == rato ) , sws ) ) ];
	 c_wr = [ c_wr  sum( ctrl( find( ctrl(:,1) == rato ) , war ) ) ];
	 c_wa = [ c_wa  sum( ctrl( find( ctrl(:,1) == rato ) , waa ) ) ];
end

%%%%%%%%%%%%%%%%

u = unique(se(:,1));

s_rem = [];
s_sws = [];
s_wr = [];
s_wa = [];

for rato = u'
	s_rem = [s_rem sum( se( find(se(:,1) == rato) ,rem ) ) ];
	s_sws = [s_sws sum( se( find(se(:,1) == rato) ,sws ) ) ];
	s_wr = [s_wr sum( se( find(se(:,1) == rato) ,war ) ) ];
	s_wa = [s_wa sum( se( find(se(:,1) == rato) ,waa ) ) ];
end

%%%%%%%%%%%%%%%%%

disp('REM');
[h,p] = ttest2(s_rem,c_rem);
fprintf('Hipotese = %d; P = %12f\n\n',h,p);

disp('SWS');
[h,p] = ttest2(s_sws,c_sws);
fprintf('Hipotese = %d; P = %12f\n\n',h,p);

disp('WAKE R');
[h,p] = ttest2(s_wr,c_wr);
fprintf('Hipotese = %d; P = %12f\n\n',h,p);

disp('WAKE A');
[h,p] = ttest2(s_wa,c_wa);
fprintf('Hipotese = %d; P = %12f\n\n',h,p);


%%%%%%%%%%%%%%%%%%

clear