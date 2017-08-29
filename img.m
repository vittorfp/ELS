%% Plota um espectrograma bonitinho coloridinho

rat_num = 54;
slice_num = 2;


rato = sprintf('%d_%d',rat_num,slice_num);

file = sprintf('/home/vittorfp/Documentos/Neuro/Dados/scaled/R%s_scaled.mat',rato);
load(file);

file = sprintf('/home/vittorfp/Documentos/Neuro/Dados/percentuals/R%s_times.mat',rato);
load(file);

file = sprintf('/home/vittorfp/Documentos/Neuro/Dados/Welch/welch_%s.mat',rato);
load(file);

range = 500:4000;


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

colormap jet
psd = flipud(psd');

figure(1)
subplot(3, 1, 1);
imagesc(log10(psd(960:end,	range) ));
ax = gca;
ax.YTick = 67 - [65 55 45 35 25 15 5 ];
ax.YTickLabel = {'65','55','45','35','25','15','5'};
ylabel('Frequency (Hz)');
%xlabel('Epoch');
title('Spectrogram');


subplot(3, 1, 3);

plot(Delta_scaled(range));hold all;plot(Theta_scaled(range) );plot(Emg_scaled(range) );
hold off;
figure(gcf);
legend('Delta','Theta','EMG');%,'REM Delta Treshold','REM Theta Treshold','MIO Treshold'
%title('Classificação de sono');
%xlabel('Epocas de 10s');
ylabel('Band power');
xlim([ 0 max(range)-min(range)]);

grid();


subplot(3, 1, 2);
h = area(REM_SLEEP(range));
h.LineWidth = 1;
%h.EdgeColor = 'none';
h.FaceColor = [85/255 20/255 201/255];
hold on;


h = area(SW_SLEEP(range));	
h.FaceColor = [85/255 151/255 221/255];
h.LineWidth = 1;
%h.EdgeAlpha = 0.5;

h = area(WAKE_A(range));
h.FaceColor = [85/255 220/255 200/255];
%h.EdgeColor = 'none';
h.LineWidth = 1;
%h.EdgeAlpha = 0.5;

h = area(WAKE_R(range));

h.FaceColor = [200/255 240/255 200/255];
%h.FaceColor = [85/255 220/255 200/255];
%h.EdgeColor = 'none';
h.LineWidth = 1;
%h.EdgeAlpha = 0.5;

hold off;
%plot(Emg_s);hold all; plot(MIO_thresh);hold off
xlim([0 max(range)-min(range) ]);
%set(gca,'YTick',[]);
%title('REM Stages');
%xlabel('Epocas de 10s');
%ylabel('Estado');
legend('REM','SWS','WAKE_A','WAKE_R');
ylim([0 1]);
xlabel('Epoch');
ylabel('Sleep State');
grid();

set(gcf,'color','white');
%%

rat_num = 49;
slice_num = 1;

folder2 = sprintf('/home/vittorfp/Documentos/Neuro/Dados/khz/');
file = sprintf('%sR'%dHIPO%d_1khz.mat',folder2,rat_num,slice_num);
load(file, 'HIPO_1khz');


i = 1000;
s_rate = 1000;     %% Hertz
tamanho_epoca = 5; %% Segundos
index = s_rate * tamanho_epoca * (i) ;
index_fim = index + (tamanho_epoca * s_rate);

epoca = HIPO_1khz(index:index_fim);
%%
%figure(1)
disp('+++++++++++++++++++++++')
[p,f] = pwelch(epoca,3000,[],[],s_rate);
length(f)
%hold on
[p,f] = pwelch(epoca,[],[],[],s_rate);
length(f)
%hold off
%xlim([0 40])