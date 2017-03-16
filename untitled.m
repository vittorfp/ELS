%R42MIO1_1khz
%R42HIPO1_1khz

srate=1000;
WINDOW=10;
NOVERLAP=1;
[S,F,T,P] = spectrogram(R42MIO1_1khz,WINDOW*srate,NOVERLAP*srate,[],srate);


banda_emg = find(F < 500 & F > 300);

EMG_B = sum( P(banda_emg,:),1);


[S,F,T,P] = spectrogram(R42HIPO1_1khz,WINDOW*srate,NOVERLAP*srate,[],srate);


banda_theta = find(F < 12 & F > 6);
banda_delta = find(F < 3 & F > 1);

Theta=sum(P(banda_theta,:),1);
Delta=sum(P(banda_delta,:),1);

%Theta(A) = NaN;
%Delta(A) = NaN;
%EMG_B(A) = NaN;

M = mean(EMG_B);
MT = mean(Theta(1,:));
MD = mean(Delta(1,:));

threshold_T = 1 * std(Theta);
threshold_D = 1 * std(Delta);

t_thresh = ones(1,length(Theta));
d_thresh = ones(1,length(Delta));

%threshold = 3*std(EMG);

idxs=find(EMG_B > M);
movimento = zeros(1,length(EMG_B));
movimento(idxs) = 1;


idxs_T = find(Theta > MT+threshold_T);
idxs_D = find(Delta > MD+threshold_D);

Theta_alto = zeros(1,length(Theta));
Theta_alto(idxs_T) = 1;


Delta_alto = zeros(length(Delta));
Delta_alto(idxs_D) = 1;

REM=find( Theta_alto == 1 & movimento == 0);
SWS=find(Theta_alto == 0 & movimento == 0);
WK=find(movimento == 1);

Color = zeros(1,length(Delta));
Color(REM) = 'r';
Color(SWS) = 'k';
Color(WK) = 'c';

scatter3(Delta,Theta,EMG_B,[],Color,'.');

xlabel('Delta');
ylabel('Theta');
zlabel('EMG');

scatter(Theta ./ Delta,EMG_B,[],Color);
% 
% for i=1:500
%     plot(Epocas(:,i),'DisplayName','R42HIPO1_1khz','YDataSource','R42HIPO1_1khz');figure(gcf)
%     pause
% end

figure(1);
set(1, 'Position', [1 1 1000 500])
subplot(2,1,1)
plot(Delta,'DisplayName','Delta','YDataSource','Delta');hold all;plot(Theta,'DisplayName','Theta','YDataSource','Theta');plot(EMG_B,'DisplayName','EMG_B','YDataSource','EMG_B');hold off;figure(gcf);
legend('Delta','Theta','EMG');
ylabel('Potencia na banda');
xlabel('Tempo (Epocas de 10s)')

subplot(2,1,2)
scatter([],[],Colors);
xlim([0 10000])
ylabel('LFP Cortex pre frontal')



range = 2320:2399;
plot(Delta(:,range));hold all;plot(Theta(:,range) );plot(EMG_B(:,range));hold off;figure(gcf);
legend('Delta','Theta','EMG');


clear F S T P NOVERLAP WINDOW banda_delta banda_emg banda_theta srate idxs idxs_D idxs_T 