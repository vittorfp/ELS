%% 


MIO_thresh1 = ones(1,length(Emg_scaled)) .* ( nanmean(Emg_scaled) ) ; %- std(Emg_s)/2 );
MIO_thresh2 = ones(1,length(Emg_scaled)) .* ( nanmean(Emg_scaled) - std(Emg_scaled)/4 );
MIO_thresh3 = ones(1,length(Emg_scaled)) .* ( nanmean(Emg_scaled) - std(Emg_scaled)/2 );

REM_threshD = ones(1,length(Delta_scaled)) .* ( nanmean(Delta_scaled) - std(Delta_scaled)*(3/4) );
REM_threshT = ones(1,length(Theta_scaled)) .* ( nanmean(Theta_scaled) + std(Delta_scaled)*(1/4) ); % + std(Theta_s) );

SWS_threshD = ones(1,length(Delta_scaled)) .* ( nanmean(Delta_scaled)  + std(Delta_scaled)/3 );
SWS_threshT = ones(1,length(Theta_scaled)) .* ( nanmean(Theta_scaled) ); % + std(Theta_s) );

Dif =   Theta_scaled./Delta_scaled;
DIF_thresh1 = ones(1,length(Theta_scaled)) .* ( nanmean(Dif) + std(Dif)*(2/4) );
DIF_thresh2 = ones(1,length(Theta_scaled)) .* ( nanmean(Dif) + std(Dif) );
DIF_thresh3 = ones(1,length(Theta_scaled)) .* ( nanmean(Dif)- std(Dif)/4  );


REM_SLEEP = zeros(1,length(Delta_scaled));
REM_Prob = zeros(1,length(Delta_scaled));
SW_SLEEP = zeros(1,length(Delta_scaled));
WAKE = zeros(1,length(Delta_scaled));
Active = zeros(1,length(Delta_scaled));

%Classifica os REMs 
is_rem = find(Delta_scaled < REM_threshD(1) & Theta_scaled < REM_threshT(1)   & Emg_scaled < MIO_thresh2(1));
REM_SLEEP(is_rem) = 1;

%Classifica os SWS
is_sws = find( ( ( Delta_scaled > SWS_threshD(1) ) & ( Theta_scaled > SWS_threshT(1) ) & ( Emg_scaled < MIO_thresh1(1) ) )  & (Dif > DIF_threshS(1)) );
SW_SLEEP(is_sws) = 1;


%Classifica os estados d acordado
is_wake = find( Emg_scaled > MIO_thresh1(1) & (Dif < DIF_thresh1 & Dif > -DIF_thresh1 ) );
WAKE(is_wake) = 1;

range = 1:length(Delta_scaled); 

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

%Classifica Periodos de atividade
is_active = find( Emg_scaled > MIO_thresh1(1));
Active(is_active) = 1;

area(Active(range));
%plot(Emg_s);hold all; plot(MIO_thresh);hold off
xlim([min(range) max(range)]);
title('Estagios de atividade');
xlabel('Epocas de 10s');
ylabel('Estado');
legend('Ativo');
grid();

subplot(4,1,3)

%Classifica os REMs 
is_rem = find(Dif > DIF_thresh1);
REM_Prob(is_rem) = 1;

area(REM_Prob(range));
%plot(Emg_s);hold all; plot(MIO_thresh)	;hold off
xlim([min(range) max(range)]);
title('Estagios de possivel REM');
xlabel('Epocas de 10s');
ylabel('Estado');
legend('REM');
grid();



subplot(4,1,4)


REM_SLEEP = REM_Prob & (~Active);

area(REM_SLEEP(range));
%plot(Emg_s);hold all; plot(MIO_thresh)	;hold off
xlim([min(range) max(range)]);
title('REM');
xlabel('Epocas de 10s');
ylabel('Estado');
legend('REM');
grid();

set(gcf,'color','white');