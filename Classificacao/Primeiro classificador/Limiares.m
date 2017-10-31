%% Grafico para visualizar os limiares

MIO_thresh1 = ones(1,length(Emg_s)) .* ( nanmean(Emg_s) ); %- std(Emg_s)/2 );
MIO_thresh2 = ones(1,length(Emg_s)) .* ( nanmean(Emg_s) - std(Emg_s)/4 );
MIO_thresh3 = ones(1,length(Emg_s)) .* ( nanmean(Emg_s) - std(Emg_s)/2 );

REM_threshD = ones(1,length(Delta_s)) .* ( nanmean(Delta_s) - std(Delta_s)*(3/4) );
REM_threshT = ones(1,length(Theta_s)) .* ( nanmean(Theta_s) + std(Delta_s)*(1/4) ); % + std(Theta_s) );

SWS_threshD = ones(1,length(Delta_s)) .* ( nanmean(Delta_s) );%- std(Delta_s)/2 );
SWS_threshT = ones(1,length(Theta_s)) .* ( nanmean(Theta_s) ); % + std(Theta_s) );

Dif =   Delta_s-Theta_s;

DIF_threshS = ones(1,length(Theta_s)) .* ( nanmean(Dif) + std(Dif)*(3/4) );
DIF_threshW = ones(1,length(Theta_s)) .* ( nanmean(Dif) + std(Dif) );
DIF_threshWA = ones(1,length(Theta_s)) .* ( nanmean(Dif)- std(Dif)/4  );
range = 1:4311; 
figure(3)
subplot(2,1,1)
plot(Emg_s(:,range) );hold all;
plot(abs(Dif));hold all;plot(DIF_threshWA(range));plot(DIF_threshS(range)); hold off;
%plot(MIO_thresh1(range) );plot(MIO_thresh2(range) );plot(MIO_thresh3(range) );hold off;figure(gcf);
legend('Miograma','Threshold 1','Threshold 2','Threshold 3');
title('Thresholds do EMG');
xlabel('Epocas de 5s');
ylabel('Potência média');
xlim([min(range) max(range)]);

grid();
subplot(2,1,2)
plot(Delta_s(:,range));hold all;plot(Theta_s(:,range) );plot(REM_threshD(range) );plot(REM_threshT(range) );hold off;figure(gcf);
legend('Delta','Theta','REM Delta Treshold','REM Theta Treshold');
title('Thresholds do EEG');
xlabel('Épocas de 5s');
ylabel('Potência média');
xlim([min(range) max(range)]);
grid();
set(gcf,'color','white');

%% Visualizar limiares de SWS

MIO_thresh1 = ones(1,length(Emg_s)) .* ( nanmean(Emg_s) ); %- std(Emg_s)/2 );
MIO_thresh2 = ones(1,length(Emg_s)) .* ( nanmean(Emg_s) - std(Emg_s)/4 );
MIO_thresh3 = ones(1,length(Emg_s)) .* ( nanmean(Emg_s) - std(Emg_s)/2 );

REM_threshD = ones(1,length(Delta_s)) .* ( nanmean(Delta_s) - std(Delta_s)/2 );
REM_threshT = ones(1,length(Theta_s)) .* ( nanmean(Theta_s) ); % + std(Theta_s) );

SWS_threshD = ones(1,length(Delta_s)) .* ( nanmean(Delta_s)  + std(Delta_s)/2 );
SWS_threshT = ones(1,length(Theta_s)) .* ( nanmean(Theta_s) ); % + std(Theta_s) );


range = 1:2000; 

figure(2)
plot(Delta_s(:,range) );hold all;plot(Theta_s(:,range) );plot(SWS_threshD(range) );plot(SWS_threshT(range) );hold off;figure(gcf);
legend('Delta','Theta','Threshold Delta SWS','Threshold Theta SWS');
title('Thresholds SWS');
xlabel('Epocas de 5s');
ylabel('Potência média');
xlim([min(range) max(range)]);
set(gcf,'color','white');

%% Classifica os REMs e plota o resultado preliminar bunitin

MIO_thresh1 = ones(1,length(Emg_s)) .* ( nanmean(Emg_s) ); %- std(Emg_s)/2 );
MIO_thresh2 = ones(1,length(Emg_s)) .* ( nanmean(Emg_s) - std(Emg_s)/4 );
MIO_thresh3 = ones(1,length(Emg_s)) .* ( nanmean(Emg_s) - std(Emg_s)/2 );

REM_threshD = ones(1,length(Delta_s)) .* ( nanmean(Delta_s) - std(Delta_s)/2 );
REM_threshT = ones(1,length(Theta_s)) .* ( nanmean(Theta_s) ); % + std(Theta_s) );

SWS_threshD = ones(1,length(Delta_s)) .* ( nanmean(Delta_s)  + std(Delta_s)/2 );
SWS_threshT = ones(1,length(Theta_s)) .* ( nanmean(Theta_s) ); % + std(Theta_s) );
REM_SLEEP = zeros(1,length(Delta_s));

remis = find(Delta_s < REM_threshD(1) & Theta_s > REM_threshT(1) & Emg_s < MIO_thresh(1));
REM_SLEEP(remis) = 1;   

range = 2500:4311; 
figure(1)
subplot(2,1,1)
plot(Delta_s(:,range));hold all;plot(Theta_s(:,range) );plot(REM_threshD(range) );plot(REM_threshT(range) );
hold off;figure(gcf);
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

