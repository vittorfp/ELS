%% 

MIO_thresh1 = ones(1,length(Emg_scaled)) .* ( nanmean(Emg_scaled) ) ; %- std(Emg_s)/2 );
MIO_thresh2 = ones(1,length(Emg_scaled)) .* ( nanmean(Emg_scaled) + std(Emg_scaled)/4 );
MIO_thresh3 = ones(1,length(Emg_scaled)) .* ( nanmean(Emg_scaled) + std(Emg_scaled)/2 );

REM_threshD = ones(1,length(Delta_scaled)) .* ( nanmean(Delta_scaled) - std(Delta_scaled)*(3/4) );
REM_threshT = ones(1,length(Theta_scaled)) .* ( nanmean(Theta_scaled) + std(Delta_scaled)*(1/4) ); % + std(Theta_s) );

SWS_threshD = ones(1,length(Delta_scaled)) .* ( nanmean(Delta_scaled)  + std(Delta_scaled)/3 );
SWS_threshT = ones(1,length(Theta_scaled)) .* ( nanmean(Theta_scaled) ); % + std(Theta_s) );

Dif =   Theta_scaled./Delta_scaled;
DIF_thresh1 = ones(1,length(Theta_scaled)) .* ( nanmean(Dif) + std(Dif)*(1/4) );
DIF_thresh2 = ones(1,length(Theta_scaled)) .* ( nanmean(Dif) + std(Dif) );
DIF_thresh3 = ones(1,length(Theta_scaled)) .* ( nanmean(Dif)  );


REM_SLEEP = zeros(1,length(Delta_scaled));
REM_Prob = zeros(1,length(Delta_scaled));
SW_SLEEP = zeros(1,length(Delta_scaled));
SWS_Prob = zeros(1,length(Delta_scaled));
WAKE = zeros(1,length(Delta_scaled));
Active = zeros(1,length(Delta_scaled));

Rest = zeros(1,length(Delta_scaled));

%Classifica os REMs 
is_rem = find(Delta_scaled < REM_threshD(1) & Theta_scaled < REM_threshT(1)   & Emg_scaled < MIO_thresh2(1));
REM_SLEEP(is_rem) = 1;

%Classifica os SWS
is_sws = find( ( ( Delta_scaled > SWS_threshD(1) ) & ( Theta_scaled > SWS_threshT(1) ) & ( Emg_scaled < MIO_thresh1(1) ) )  & (Dif > DIF_thresh1(1)) );
SW_SLEEP(is_sws) = 1;


%Classifica os estados d acordado
is_wake = find( Emg_scaled > MIO_thresh1(1) & (Dif < DIF_thresh1 & Dif > -DIF_thresh1 ) );
WAKE(is_wake) = 1;

range = 1:length(Delta_scaled); 


%Classifica provaveis SWSs 
is_sws = find(Dif < DIF_thresh3);
SWS_Prob(is_sws) = 1;


figure(1)
subplot(4,1,1)
plot(Delta_scaled(range));hold all;plot(Theta_scaled(range) );plot(Emg_scaled(range) );
plot(MIO_thresh1(range) );
hold off;
legend('Delta','Theta','EMG');%,'REM Delta Treshold','REM Theta Treshold','MIO Treshold'
title('Potencias nas bandas (Suavizado)');
xlabel('Epocas de 10s');
ylabel('Potencia');
xlim([min(range) max(range)]);
grid();

subplot(4,1,2)

%Classifica Periodos de descanso
is_resting = find( Emg_scaled < MIO_thresh3(1));
Rest(is_resting) = 1;


area(Rest(range));
%plot(Emg_s);hold all; plot(MIO_thresh);hold off
xlim([min(range) max(range)]);
title('Estagios de descanso');
xlabel('Epocas de 10s');
ylabel('Estado');
legend('Ativo');
grid();

subplot(4,1,3)


area(SWS_Prob(range));
%plot(Emg_s);hold all; plot(MIO_thresh)	;hold off
xlim([min(range) max(range)]);
title('Estagios de possivel SWS');
xlabel('Epocas de 10s');
ylabel('Estado');
legend('SWS');
grid();



subplot(4,1,4)


SW_SLEEP = SWS_Prob & (~Active);

area(SW_SLEEP(range));
%plot(Emg_s);hold all; plot(MIO_thresh)	;hold off
xlim([min(range) max(range)]);
title('SWS');
xlabel('Epocas de 10s');
ylabel('Estado');
legend('SWS');
grid();

set(gcf,'color','white');