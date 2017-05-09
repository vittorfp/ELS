% Script para classificar epocas manualmente.
%      O programa vai exibir o traçado do LFP, do miograma e um breve
%      histórico da potencia nas bandas theta e delta e o usuário entrará
%      com a classificação que achar correta para o periodo.
%      
%      Vittor Faria Pereira

%% Carrega os dados

% Carrega o spectrograma

% Carrega os dados decimados
cd()
rato = '42_1';
load('/home/vittorfp/Documentos/Neuro/Dados/ELS_data/khz/R42MIO1_1khz.mat');
%y = hilbert(MIO_1khz);
%MIO_1khz = abs(y);
clear y;
load('/home/vittorfp/Documentos/Neuro/Dados/ELS_data/khz/R42HIPO1_1khz.mat');
load('/home/vittorfp/Documentos/Neuro/Dados/light/R42_1_spectrogram.mat');

%% Inicializa Parâmetros

% Parâmetros do dado
Frequencia_amostral = 1000; % Hz
Tamanho_epoca = 5; % Segundos

% Parâmetros auxiliares
t = 0:1/Frequencia_amostral:length(HIPO_1khz)/Frequencia_amostral;
epocas = length(Theta_s);
Estados = zeros(1,length(Theta_s));
t2 = 1:epocas;

init = 1;man_clas.mat
%% Loada uma classificação feita anteriormente

load('/home/vittorfp/Documentos/Neuro/Dados/cassificacao_manual/man_clas.mat');
init = epoca;

%% Plota por época


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
    title('LFP Hipocampus');
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
    
    % Pede a opinião do usuario
   
%     xix = -1; 
%     ypstlon = -1;
%     while ~( ( ypstlon < 0 && ypstlon > 1) && ( ( xix < 0) || (xix > 2 && xix < 2.5) || (xix > 4.5 && xix < 5) || (xix > 7 && xix < 7.5) || (xis > 9.5) ) ) 
%         [xix,ypstlon] = ginput(1);  
%     end
%     
%     if xix <= 2
%         Estados(epoca) = 1;
%     elseif xix <= 4.5
%         Estados(epoca) = 2;
%     elseif xix <= 7
%         Estados(epoca) = 3;
%     elseif xix <= 9.5
%         Estados(epoca) = 4;
%     else 
%         Estados(epoca) = 0;
%     end
% 

end