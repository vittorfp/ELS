srate=1000;
WINDOW=10;  
NOVERLAP=5;



%[S,F,T,P] = spectrogram(R42HIPO1_1khz,WINDOW*srate,NOVERLAP*srate,[],srate);
%[S,F,T,P] = spectrogram(R42MIO1_1khz,WINDOW*srate,NOVERLAP*srate,[],srate);

%save('spectrogram.mat','S','F','T','P');

clear srate WINDOW NOVERLAP
%%

banda_emg = find(F > 300 & F < 500);
Emg = sum( P(banda_emg,:),1);

Emg_s = [];
c = length(Emg)-3;
for i = 4:c
    y = i-3;
    z = i+3;
    Emg_s = [Emg_s sum(Emg(y:z))/6];
    
end

clear i z y c

%%
banda_theta = (F >5 & F < 12);
banda_delta = (F >1 & F < 4);
banda_gamma = (F >33 & F < 55);

Theta = sum(P(banda_theta,:),1);
Delta = sum(P(banda_delta,:),1);
Gamma = sum(P(banda_gamma,:),1);

Theta_s = [];
Delta_s = [];
Gamma_s = [];
c = length(Delta)-3;
for i = 4:c
    y = i-3;
    z = i+3;
    Theta_s = [Theta_s sum(Theta(y:z))/6];
    Delta_s = [Delta_s sum(Delta(y:z))/6];
    Gamma_s = [Gamma_s sum(Gamma(y:z))/6];

end

clear i z y c
%save('spectrogram_hipo.mat','Delta','Theta','Gamma','Delta_s','Theta_s','Gamma_s');



REM_threshD = ones(length(Delta_s)) .* 0.045;
REM_threshT = ones(length(Delta_s)) .* 0.065;
%%
%Grafico para visualizar a diferença entre as potencias filtradas e as
%calculadas na tora msm

range = 3200:4000; 
figure(1)
subplot(2,1,1)
plot(Delta(:,range));hold all;plot(Theta(:,range) );hold off;figure(gcf);
legend('Delta','Theta');
title('Potencias nas bandas');
xlabel('Epocas de 10s');
ylabel('Potencia');
xlim([0 800]);
subplot(2,1,2)
plot(Delta_s(:,range));hold all;plot(Theta_s(:,range) );plot(REM_threshD(range) );plot(REM_threshT(range) );hold off;figure(gcf);
legend('Delta','Theta','REM Delta Treshold','REM Theta Treshold');
title('Potencias nas bandas (Suavizado)');
xlabel('Epocas de 10s');
ylabel('Potencia');
xlim([0 800]);
set(gcf,'color','white');


%%
REM = [ 815:855 1375:1415 ];

SWS = [600:810 860:950 1150:1360];
 
WAK = [1:150 310:590 960:1130 1530:1780 ];


%%
%Classifica os REMs e plota o resultado bunitin

MIO_thresh = ones(length(Emg_s)) .* 0.0009;
REM_threshD = ones(length(Delta_s)) .* 0.045;
REM_threshT = ones(length(Delta_s)) .* 0.054;
REM_SLEEP = zeros(1,length(Delta_s));

remis = find(Delta_s < REM_threshD(1) & Theta_s > REM_threshT(1) & Emg_s(1:4307) < MIO_thresh(1));
REM_SLEEP(remis) = 1;

range = 2500:4000; 
figure(1)
subplot(2,1,1)
plot(Delta_s(:,range));hold all;plot(Theta_s(:,range) );plot(REM_threshD(range) );plot(REM_threshT(range) );hold off;figure(gcf);
legend('Delta','Theta','REM Delta Treshold','REM Theta Treshold');
title('Potencias nas bandas (Suavizado)');
xlabel('Epocas de 10s');
ylabel('Potencia');
xlim([0 length(Delta_s(range))]);

subplot(2,1,2)
area(REM_SLEEP(range));
%plot(Emg_s);hold all; plot(MIO_thresh);hold off
xlim([0 length(Emg_s(range))]);
title('REM Stages');
xlabel('Epocas de 10s');
ylabel('Estado');
legend('REM');
set(gcf,'color','white');

clear remis range F S T P NOVERLAP WINDOW banda_delta banda_emg banda_theta banda_gamma srate idxs idxs_D idxs_T 


%%


%Classifica os REMs 

MIO_thresh = ones(length(Emg_s)) .* 0.002;
REM_threshD = ones(length(Delta_s)) .* 0.045;
REM_threshT = ones(length(Delta_s)) .* 0.054;

REM_SLEEP = zeros(1,length(Delta_s));

is_rem = find(Delta_s < REM_threshD(1) & Theta_s > REM_threshT(1) & Emg_s(1:length(Delta_s)) < MIO_thresh(1));
REM_SLEEP(is_rem) = 1;

%%

%Classifica os SWS

SW_SLEEP = zeros(1,length(Delta_s));

is_sws = find(Delta_s > REM_threshT(1) & Theta_s > REM_threshT(1) & Emg_s(1:length(Delta_s)) < MIO_thresh(1));
SW_SLEEP(is_sws) = 1;

%%

%Classifica os estados de acordado

WAKE = zeros(1,length(Delta_s));

is_wake = find( Emg_s(1:length(Delta_s)) > MIO_thresh(1));
WAKE(is_wake) = 1;

%%
range = 1:4000; 
figure(1)
subplot(4,1,1)
plot(Delta_s(:,range));hold all;plot(Theta_s(:,range) );plot(Emg_s(:,range) );plot(REM_threshD(range) );plot(REM_threshT(range) );plot(MIO_thresh(range) );hold off;figure(gcf);
legend('Delta','Theta');%,'REM Delta Treshold','REM Theta Treshold','MIO Treshold'
title('Potencias nas bandas (Suavizado)');
xlabel('Epocas de 10s');
ylabel('Potencia');
xlim([0 length(Delta_s(range))]);
grid();

subplot(4,1,2)
area(REM_SLEEP(range));
%plot(Emg_s);hold all; plot(MIO_thresh);hold off
xlim([0 length(Emg_s(range))]);
title('REM Stages');
xlabel('Epocas de 10s');
ylabel('Estado');
legend('REM');

grid();
subplot(4,1,3)
h = area(SW_SLEEP(range));
grid();
h.FaceColor = 'r';
%plot(Emg_s);hold all; plot(MIO_thresh);hold off
xlim([0 length(Emg_s(range))]);
title('SWS Stages');
xlabel('Epocas de 10s');
ylabel('Estado');
legend('SWS');
grid();

subplot(4,1,4)
h = area(WAKE(range));
h.FaceColor ='G';
%plot(Emg_s);hold all; plot(MIO_thresh);hold off
xlim([0 length(Emg_s(range))]);
title('Wake Stages');
xlabel('Epocas de 10s');
ylabel('Estado');
legend('Wake');
grid();

set(gcf,'color','white');

clear remis range F S T P NOVERLAP WINDOW banda_delta banda_emg banda_theta banda_gamma srate idxs idxs_D idxs_T 



