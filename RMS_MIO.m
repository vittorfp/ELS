%load('/home/vittorfp/Documentos/Neuro/Dados/ELS_data/khz/R42MIO1_1khz.mat');


Frequencia_amostral = 1000; % Hz
Tamanho_epoca = 5; % Segundos

% Parâmetros auxiliares
epocas = length(Theta);

for i = 1:epocas
    epoca = i;
    range = 1 + (epoca - 1) * Tamanho_epoca*Frequencia_amostral:epoca*Tamanho_epoca*Frequencia_amostral;
    Emg(i) = rms(MIO_1khz(range));
end

%plot(Emg_s);

Emg_s = [];

        c = length(Delta)-3;

        for i = 4:c

            y = i-3;
            z = i+3;

            Emg_s   = [Emg_s   nanmean(  Emg(y:z)  ) ];

        end

% Parâmetros da janela
%prompt = sprintf('Enter the sleep/wake stage:\n1 - REM\n2 - SWS\n3 - Wake
%Resting\n4 - Wake Active'); dlg_title = 'Stage?'; num_lines = 1;
%     plot(t2(range2),Theta_s(range2)); hold all;
%     plot(t2(range2),Delta_s(range2)); plot(t2(range2),Emg_s(range2) );
%     plot([epoca epoca],[0 0.5]); hold off; legend('Theta','Delta','EMG');
%     ylim([0 0.4]); xlim([epoca-5 epoca+6]); grid(); title('Band
%     history');%     subplot(4,2,[6 8]); fill(x, y, [85/255 20/255
%     201/255] ); hold on; fill(x+2.5, y, [85/255 151/255 221/255]);
%     fill(x+5, y, [85/255 220/255 200/255]); fill(x+7.5, y, [200/255
%     240/255 200/255]); hold off; text(0.6,0.5,'REM');
%     text(3.1,0.5,'SWS'); text(5.3,0.5,'WAKE R'); text(7.8,0.5,'WAKE
%     A');xlim([-0.5 10]); ylim([-0.5 1.5]); set(gca,'YTick', [ -0.5 : 0.25
%     : 1.5] ); set(gca,'XTick', [0 : 0.5 : 10] );
%     set(gca,'YTickLabels',[]); set(gca,'XTickLabels',[]); grid();
%     title('Classifique a época:');
% x1=0; x2=2; y1=0; y2=1; x = [x1, x2, x2, x1, x1]; y = [y1, y1, y2, y2,
% y1];
    