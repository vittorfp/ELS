%% Carrega os dados

% Carrega o spectrograma

% Carrega os dados decimados
cd('/home/vittorfp/Documentos/Neuro/Scripts/ELS');
rato = '52_1';
%load('/home/vittorfp/Documentos/Neuro/Dados/khz/R42MIO1_1khz.mat');
%y = hilbert(MIO_1khz);
%MIO_1khz = abs(y);
%clear y;
load('/home/vittorfp/Documentos/Neuro/Dados/khz/R42HIPO1_1khz.mat');
%load('/home/vittorfp/Documentos/Neuro/Dados/light/R42_1_spectrogram.mat');
%% Inicializa Parâmetros

% Parâmetros do dado
Frequencia_amostral = 1000; % Hz
Tamanho_epoca = 5; % Segundos

srate=1000;
WINDOW=10;  
NOVERLAP=5;

%% Plota gráfico do traçado

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
n = 60;
epoca = 1500;
range = 1 + (epoca - n) * Tamanho_epoca*Frequencia_amostral:epoca*Tamanho_epoca*Frequencia_amostral;

spectrogram(HIPO_1khz(range),WINDOW*srate,NOVERLAP*srate,[],srate,'yaxis');
title('Análise espectral')
legend boxoff
box off
set(gcf,'color','white');
%% Soma das bandas

[S2,F2,T2,P2] = spectrogram(HIPO_1khz,WINDOW*srate,NOVERLAP*srate,[],srate); 

utreshold =  mean(MIO_1khz) + (3*std(MIO_1khz)); %Definido empiricamente
ltreshold =  -utreshold; %Definido empiricamente
A = find(MIO_1khz > utreshold | MIO_1khz < ltreshold);

eA2 = ceil( A/(tamanho_epoca*srate) );
eA2 = unique(eA2);

clear MIO_1khz A1 A2
clear S2 T2 A utreshold ltreshold Aq A2

banda_theta = find(F >5 & F < 12 );
banda_delta = find(F >1 & F < 4);
banda_gamma = find(F >33 & F < 55);
banda_emg = find(F2 > 300 & F2 < 500);

Emg   = sum( P2(banda_emg , : ) );
Theta = sum( P(banda_theta, : ) );
Delta = sum( P(banda_delta, : ) );
Gamma = sum( P(banda_gamma, : ) );

clear P P2 F F2

Emg(eA) = 0;
Theta(eA) = 0;
Delta(eA) = 0;
Gamma(eA) = 0;
		
%% Media na janela

%% Classificação

%% Distibuição temporal