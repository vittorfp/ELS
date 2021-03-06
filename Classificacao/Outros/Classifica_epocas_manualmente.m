% Script para classificar epocas manualmente.
%      O programa vai exibir o traçado do LFP, do miograma e um breve
%      histórico da potencia nas bandas theta e delta e o usuário entrará
%      com a classificação que achar correta para o periodo.
%      
%      Vittor Faria Pereira

%% Carrega os dados

% Carrega o spectrograma

% Carrega os dados decimados
cd('/home/vittorfp/Documentos/Neuro/Scripts/ELS');
rato = '52_1';
load('/home/vittorfp/Documentos/Neuro/Dados/khz/R52MIO1_1khz.mat');
%y = hilbert(MIO_1khz);
%MIO_1khz = abs(y);
clear y;
load('/home/vittorfp/Documentos/Neuro/Dados/khz/R52HIPO1_1khz.mat');
load('/home/vittorfp/Documentos/Neuro/Dados/light/R52_1_spectrogram.mat');

%% Inicializa Parâmetros

% Parâmetros do dado
Frequencia_amostral = 1000; % Hz
Tamanho_epoca = 5; % Segundos

% Parâmetros auxiliares
t = 0:1/Frequencia_amostral:length(HIPO_1khz)/Frequencia_amostral;
epocas = length(Theta_s);
Estados = zeros(1,length(Theta_s));
t2 = 1:epocas;

init = 1;
%% Loada uma classificação feita anteriormente

load('/home/vittorfp/Documentos/Neuro/Dados/cassificacao_manual/man_clas.mat');
init = epoca;

%% Plota por época
init = 1;

for i = init:epocas
    epoca = i;
    range = 1 + (epoca - 1) * Tamanho_epoca*Frequencia_amostral:epoca*Tamanho_epoca*Frequencia_amostral;
    if (epoca <= 80)	
        range2 = 1:epoca+80;
    else
        if (epoca + 80 >= epocas) 
            range2 = epocas-160:epocas;
        else
            range2 = epoca-80:epoca+80;
        end
    end
    
    figure(1);
    subplot(4,2,[1 2]);
    plot(t(range),HIPO_1khz(range));
    ylim([-0.7 0.7]);
    grid();
	t = sprintf('LFP Hipocampus %s',rato);
    title(t);
    xlabel('Tempo(s)');


    subplot(4,2,[3 4]);
    plot(t(range),MIO_1khz(range));
    ylim([-0.7 0.7]);
    grid();
    title('Miogram');
    xlabel('Tempo(s)');

    subplot(4,2,[5 7]);
    plot(t2(range2),Theta_s(range2));
    hold all;
    plot(t2(range2),Delta_s(range2));
    plot(t2(range2),Emg(range2) );
    plot([epoca epoca],[0 0.5]);
    hold off;
    legend('Theta','Delta','EMG');
    ylim([0 0.4]);
     xlim([min(range2) max(range2)]);
    grid();
    title('Band history');
    
    subplot(4,2,[6 8]);
    
    stairs(Estados);
    ylim([0.5 4.5]);
    xlim([1 epoca+1]);
    %yticks([1 2 3]);
    %yticklabels({'REM','SWS','WAKE'});
    set(gca,'YTick',[1:4]);
    set(gca,'YTickLabel',{'REM' 'SWS' 'WAKE R' 'WAKE A'});
    title('Classificação parcial');
    xlabel('Epocas de 5s');
    ylabel('Estado');
    grid();

    
    set(gcf,'color','white');
	
    % Pede a opinião do usuario
    [s,v] = listdlg('PromptString','Classsifique a época:',...
                'SelectionMode','single',...
                'Name','Classificação',...
                'ListSize',[200 100], ...
                'ListString',{'' 'REM' 'SWS' 'WAKE R' 'WAKE A'});
    
    if(v == 0)
        save('/home/vittorfp/Documentos/Neuro/Dados/cassificacao_manual/man_clas.mat','Estados','epoca','init','rato');
        break;
    else
        Estados(epoca) = s-1;
    end
    
    
   

end
file = sprintf('/home/vittorfp/Documentos/Neuro/Dados/cassificacao_manual/man_clas-%s.mat',rato);
save(file,'Estados','epoca','init','rato');

%% Plota grafico bacanudo
r = find(Estados == 1);
s = find(Estados == 2);
w = find(Estados == 3);
wa = find(Estados == 4);

REM_SLEEP = zeros(1,length(Delta_s));
SW_SLEEP = zeros(1,length(Delta_s));
WAKE = zeros(1,length(Delta_s));
WAKE_A = zeros(1,length(Delta_s));

REM_SLEEP(r) = 1;
SW_SLEEP(s) = 1;
WAKE(w) = 1;
WAKE_A(wa) = 1;

%Plota a figura bonitona com os estados ja corrigidos em Area e patamares
range = 1:4311; 
%range = 1000:3000;
figure(1)
subplot(4,1,1)
plot(Delta_s(range));hold all;plot(Theta_s(range) );plot(3*Emg_s(range) );
%plot(REM_threshD(range) );plot(REM_threshT(range) );plot(MIO_thresh(range) );
hold off;figure(gcf);
legend('Delta','Theta','EMG');%,'REM Delta Treshold','REM Theta Treshold','MIO Treshold'
title('Arquitetura do sono');
%xlabel('Epocas de 10s');
ylabel('Potencia');
xlim([min(range) max(range)]);
grid();


subplot(4,1,2)
h = area(REM_SLEEP(range));
h.LineWidth = 0.001;
%h.EdgeColor = 'none';
h.FaceColor = [85/255 20/255 201/255];
hold on;


h = area(SW_SLEEP(range));
h.FaceColor = [85/255 151/255 221/255];
h.LineWidth = 0.01;
h.EdgeAlpha = 0.5;

h = area(WAKE_A(range));
h.FaceColor = [200/255 240/255 200/255];
%h.EdgeColor = 'none';
h.LineWidth = 0.0001;
%h.EdgeAlpha = 0.5;

h = area(WAKE(range));
h.FaceColor = [85/255 220/255 200/255];
%h.EdgeColor = 'none';
h.LineWidth = 0.0001;
%h.EdgeAlpha = 0.5;

hold off;
%plot(Emg_s);hold all; plot(MIO_thresh);hold off
xlim([min(range) max(range)]);
set(gca,'YTick',[]);
%title('REM Stages');
%xlabel('Epocas de 10s');
%ylabel('Estado');
legend('REM','SWS','WAKE_A','WAKE_R');
grid();

subplot(4,1,[3 4]);

stairs(Estados(range));
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

clear h res a i j z next last r w s superposicao

%% Pos processamento do dado 

rato = '42_1';
file = sprintf('/home/vittorfp/Documentos/Neuro/Dados/cassificacao_manual/man_clas-%s.mat',rato);
load(file);

clear file

%% Classifica as epocas que nao foram classificadas anteriormente

%stairs(Estados);

z = find(Estados == 0);

for i = z
   if(Estados(i) == 0)
       last = Estados(i - 1);
       j = 0;
       
       while(Estados(i + j) == 0)
          j = j + 1;
          if( (i+j) > length(Estados))
             j = j-1;
             Estados( i + j ) = last;
             break;
          end
       end
       next = Estados( i + j );
       
       if(last == next) 
           Estados(i:i + j) = next;
       else
           Estados(i : i + j) = max([last next]);
       end
   end
end

%% Elimina Estados com menos de 1 minuto

nEpocas = 12; % 12 epocas equivalem a 1 minuto

i=1;
n = 1;
while i >= 1 && i < length(Estados)
    if Estados(i) == Estados(i+1)
        n = n + 1;
        i = i + 1;
    else
        if n < nEpocas
            Estados(i-n:i) = max([Estados(i-n-1) Estados(i+1)]);
        end
        n = 1;
        i = i + 1;
    end
end
%% Salva os dados pósprocessados
file = sprintf('/home/vittorfp/Documentos/Neuro/Dados/cassificacao_manual/labels-%s.mat',rato);
save(file,'Estados','rato');

