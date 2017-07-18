%% Carrega os dados

% Carrega o spectrograma

% Carrega os dados decimados
cd('/home/vittorfp/Documentos/Neuro/Scripts/ELS');
%rato = '52_1';
%load('/home/vittorfp/Documentos/Neuro/Dados/khz/R42MIO1_1khz.mat');
%y = hilbert(MIO_1khz);
%MIO_1khz = abs(y);
%clear y;
load('/home/vittorfp/Documentos/Neuro/Dados/khz/R42HIPO1_1khz.mat');
%% Inicializa Parâmetros

% Parâmetros do dado
Frequencia_amostral = 1000; % Hz
Tamanho_epoca = 5; % Segundos

srate=1000;
WINDOW=10;  
NOVERLAP=5;

%% Plota gráfico do traçado

t = 0:1/Frequencia_amostral:length(HIPO_1khz)/Frequencia_amostral;
n = 1;
epoca = 1500;
range = 1 + (epoca - n) * Tamanho_epoca*Frequencia_amostral:epoca*Tamanho_epoca*Frequencia_amostral;

figure(1);
plot(t(range),HIPO_1khz(range));
ylim([-0.7 0.7]);
grid();
ta = sprintf('Potencial de campo local (Taxa de amostragem = 1kHz)');
title(ta);
ax = gca;
ax.YTick = [-0.7 0 0.7];
ax.XTickLabel = {'0','0.5','1','1.5','2','2.5','3','3.5','4','4.5','5'};

ylabel('Potencial(\muV)');
xlabel('Tempo(s)');

legend boxoff
box off
set(gcf,'color','white');

%% Remoção de artefátos

load('/home/vittorfp/Documentos/Neuro/Dados/khz/R41HIPO1_1khz.mat');

% Parâmetros do dado
Frequencia_amostral = 1000;  % Hz
Tamanho_epoca = 5;			 % Segundos
n = 30;
epoca = 85;

range = 1 + (epoca - n) * Tamanho_epoca*Frequencia_amostral : epoca*Tamanho_epoca*Frequencia_amostral;

h = HIPO_1khz(range);
clear HIPO_1khz

%% 
utreshold =  mean(h) + (5*std(h)); 
ltreshold =  -utreshold;
tamanho_epoca = 5;

A = find(h > utreshold | h < ltreshold);
srate = 1000;
eA = ceil( A / (tamanho_epoca*srate) );
eA = unique(eA);

art = zeros( size(h) );
%disp(eA)

for i = eA'
	range = (1 + (i - 1) * tamanho_epoca * srate) : (i * tamanho_epoca * srate);
	art(range) = 10;
end

figure(1);
plot(h);
hold on;
range = 1 + (epoca - n) * Tamanho_epoca*Frequencia_amostral : epoca*Tamanho_epoca*Frequencia_amostral;
plot([0	length(range)],[utreshold utreshold],'--');
plot([0	length(range)],[ltreshold ltreshold],'--');

ar = area(art);
ar.FaceColor = [200/255 240/255 200/255];
%h.EdgeColor = 'none';
ar.LineWidth = 0.1;																		
ar.EdgeAlpha = 0.4;
ar.FaceAlpha = 0.3;
ylim([-1 5]);
ax = gca;
ax.XTick = [0:15000:1450000];
ax.XTickLabel = {'0','15','30','45','60','75','90','105','120','135','150'};
ylabel('Potencial (\muV)');
xlabel('Tempo (s)');
hold off;
grid();
title('Remoção de artefatos');
legend('Traçado LFP','Limite superior','Limite inferior', 'Época com artefato');
legend boxoff
box off
set(gcf,'color','white');

%% Espectrograma

load('/home/vittorfp/Documentos/Neuro/Dados/khz/R42HIPO1_1khz.mat');
% Parâmetros do dado
Frequencia_amostral = 1000; % Hz
Tamanho_epoca = 5; % Segundos

srate=1000;
WINDOW=10;  
NOVERLAP=5;

n = 60;
epoca = 1500;
range = 1 + (epoca - n) * Tamanho_epoca*Frequencia_amostral:epoca*Tamanho_epoca*Frequencia_amostral;

spectrogram(HIPO_1khz(range),WINDOW*srate,NOVERLAP*srate,[],srate,'yaxis');
title('Análise espectral')

set(gcf,'color','white');
%% Soma das bandas

load('/home/vittorfp/Documentos/Neuro/Dados/light/R42_1_spectrogram.mat');
folder2 = '/home/vittorfp/Documentos/Neuro/Dados/scaled/';
file = sprintf('%sR42_1_scaled.mat',folder2);		
load(file);


range = 1:1600;
figure(1)
subplot(3,1,1)
plot(Delta(range));
hold on
plot(Theta(range));
plot(Emg(range));
plot(Gamma(range));
hold off
grid()
%xlabel('Número da época');
ylabel('Potência');
title('Soma das potências nas bandas de frequencia');
legend('Delta','Theta','Emg','Gamma');
xlim([min(range) max(range)]);
legend boxoff
box off

subplot(3,1,2)
plot(Delta_s(range));
hold on
plot(Theta_s(range));
plot(Emg_s(range));
plot(Gamma_s(range));
hold off
grid()
%xlabel('Número da época');
ylabel('Potência média');
%title('Potências suavizadas');
legend('Delta','Theta','Emg','Gamma');
xlim([min(range) max(range)]);
legend boxoff
box off
set(gcf,'color','white');


subplot(3,1,3)
plot(Delta_scaled(range));
hold on
plot(Theta_scaled(range));
plot(Emg_scaled(range));
plot(Gamma_scaled(range));
hold off
grid()
xlabel('Número da época');
ylabel('Potência normalizada');
%title('Potências reescaladas');
legend('Delta','Theta','Emg','Gamma');
xlim([min(range) max(range)]);
legend boxoff
box off
set(gcf,'color','white');



%% Classificação

file = sprintf('/home/vittorfp/Documentos/Neuro/Dados/percentuals/R42_1_times.mat');
load(file);
folder2 = '/home/vittorfp/Documentos/Neuro/Dados/scaled/';
file = sprintf('%sR42_1_scaled.mat',folder2);		
load(file);

r = find(Estados == 1);
s = find(Estados == 2);
wr = find(Estados == 3);
wa = find(Estados == 4);
		
REM_SLEEP = zeros(1,length(Delta_scaled));
SW_SLEEP = zeros(1,length(Delta_scaled));
WAKE_R = zeros(1,length(Delta_scaled));
WAKE_A = zeros(1,length(Delta_scaled));

REM_SLEEP(r) = 1;
SW_SLEEP(s) = 1;
WAKE_R(wr) = 1;
WAKE_A(wa) = 1;


range = 1:1600;

figure(1)
subplot(3,1,1)
h = area(100*REM_SLEEP(range));
%h.LineWidth = 0.001;
%h.EdgeColor = 'none';
h.FaceColor = [85/255 20/255 201/255];
hold on;


h = area(100*SW_SLEEP(range));
h.FaceColor = [85/255 151/255 221/255];
%h.LineWidth = 0.01;
%h.EdgeAlpha = 0.5;

h = area(100*WAKE_A(range));
h.FaceColor = [200/255 240/255 200/255];
%h.EdgeColor = 'none';
%h.LineWidth = 0.0001;
%h.EdgeAlpha = 0.5;

h = area(100*WAKE_R(range));
h.FaceColor = [85/255 220/255 200/255];
%h.EdgeColor = 'none';
%h.LineWidth = 0.0001;
%h.EdgeAlpha = 0.5;

hold off;
%plot(Emg_s);hold all; plot(MIO_thresh);hold off
xlim([min(range) max(range)]);
set(gca,'YTick',[]);
title('Classificação dos estágios de sono');
%xlabel('Epocas de 10s');
%ylabel('Estado');
legend('REM','SWS','WAKE_A','WAKE_R');
%legend boxoff;
box off;
ylim([0 1]);
grid();


subplot(3,1,[2 3]);

stairs(Estados(range),'LineWidth',2);
ylim([0.5 4.5]);
xlim([min(range) max(range)]);
%yticks([1 2 3]);
%yticklabels({'REM','SWS','WAKE'});
set(gca,'YTick',[1:4]);
set(gca,'YTickLabel',{'REM' 'SWS' 'WAKE R' 'WAKE A'});
%title('Arquitetura do sono');
xlabel('Epocas de 5s');
ylabel('Estado');
grid();

set(gcf,'color','white');

		
%% Distibuição temporal
% esse vai ser o gráfico gerado pelo negocio mesmo



