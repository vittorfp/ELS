%R42MIO1_1khz
%R42HIPO1_1khz

srate=1000;
WINDOW=10;  
NOVERLAP=0.01;

%banda_emg = find(F < 500 & F > 300);

%EMG_B = sum( P(banda_emg,:),1);


%[S,F,T,P] = spectrogram(R42HIPO1_1khz,WINDOW*srate,NOVERLAP*srate,[],srate);
save('spectrogram.mat','S','F','T','P');


banda_emg = find(F > 300 & F < 500);
banda_theta = (F >4 & F < 9);
banda_delta = (F >1 & F < 4);
banda_gamma = (F >33 & F < 55);

Theta = sum(P(banda_theta,:),1);
Delta = sum(P(banda_delta,:),1);
Gamma = sum(P(banda_gamma,:),1);

Theta_s = [];
Delta_s = [];
Gamma_s = [];
c = length(Delta)-10;
for i = 1:c
    z = i+10;
    Theta_s = [Theta_s sum(Theta(i:z))/10];
    Delta_s = [Delta_s sum(Delta(i:z))/10];
    Gamma_s = [Gamma_s sum(Gamma(i:z))/10];
    
end

save('spectrogram_hipo.mat','Delta','Theta','Gamma','Delta_s','Theta_s','Gamma_s');


range = 2000:3000; 
figure(1)
subplot(2,1,1)
plot(Delta_s(:,range));hold all;plot(Theta_s(:,range) );hold off;figure(gcf);
legend('Delta','Theta');
subplot(2,1,2)
plot(Delta(:,range));hold all;plot(Theta(:,range) );hold off;figure(gcf);
legend('Delta','Theta');


REM = [ 815:855 1375:1415 ];

SWS = [600:810 860:950 1150:1360];
 
WAK = [1:150 310:590 960:1130 1530:1780 ];



%Theta(A) = NaN;
%Delta(A) = NaN;
%EMG_B(A) = NaN;

% M = mean(EMG_B);
% MT = mean(Theta(1,:));
% MD = mean(Delta(1,:));
% 
% threshold_T = 1 * std(Theta);
% threshold_D = 1 * std(Delta);
% 
% t_thresh = ones(1,length(Theta));
% d_thresh = ones(1,length(Delta));
% 
% %threshold = 3*std(EMG);
% 
% idxs=find(EMG_B > M);
% movimento = zeros(1,length(EMG_B));
% movimento(idxs) = 1;
% 
% 
% idxs_T = find(Theta > MT+threshold_T);
% idxs_D = find(Delta > MD+threshold_D);
% 
% Theta_alto = zeros(1,length(Theta));
% Theta_alto(idxs_T) = 1;
% 
% 
% Delta_alto = zeros(length(Delta));
% Delta_alto(idxs_D) = 1;
% 
% REM=find( Theta_alto == 1 & movimento == 0);
% SWS=find(Theta_alto == 0 & movimento == 0);
% WK=find(movimento == 1);
% 
% Color = zeros(1,length(Delta));
% Color(REM) = 'r';
% Color(SWS) = 'k';
% Color(WK) = 'c';
% 
% scatter3(Delta,Theta,EMG_B,[],Color,'.');
% 
% xlabel('Delta');
% ylabel('Theta');
% zlabel('EMG');
% 
% scatter(Theta ./ Delta,EMG_B,[],Color);
% % 
% % for i=1:500
% %     plot(Epocas(:,i),'DisplayName','R42HIPO1_1khz','YDataSource','R42HIPO1_1khz');figure(gcf)
% %     pause
% % end
% 
% figure(1);
% set(1, 'Position', [1 1 1000 500])
% subplot(2,1,1)
% plot(Delta,'DisplayName','Delta','YDataSource','Delta');hold all;plot(Theta,'DisplayName','Theta','YDataSource','Theta');plot(EMG_B,'DisplayName','EMG_B','YDataSource','EMG_B');hold off;figure(gcf);
% legend('Delta','Theta','EMG');
% ylabel('Potencia na banda');
% xlabel('Tempo (Epocas de 10s)')
% 
% subplot(2,1,2)
% scatter([],[],Colors);
% xlim([0 10000])
% ylabel('LFP Cortex pre frontal')
% 

REM = [  ];

SWS = [ ];
 
WAK = [];

REM_delta = mean(Delta(:,REM)) * ones(1,length(Delta));
REM_theta = mean(Theta(:,REM)) * on es(1,length(Theta));

SWS_delta = mean(Delta(:,SWS)) * ones(1,length(Delta));
SWS_theta = mean(Theta(:,SWS)) * ones(1,length(Theta));

SD_REM_delta = std( Delta(:,REM));

Delta_baixo = find(Delta < 0.04);

REM_SLEEP = zeros(1,length(Delta));
REM_SLEEP(Delta_baixo) = 1;

range = 820:1000;
figure(1)
subplot(2,1,1)
plot(Delta(:,range));hold all;plot(Theta(:,range) );plot(REM_delta(:,range));plot(REM_theta(:,range));plot(SWS_delta(:,range));plot(SWS_theta(:,range));hold off;figure(gcf);
legend('Delta','Theta','REM Delta','REM Theta','SWS Delta','SWS Theta');

xlim([0 500])
subplot(2,1,2)
area(REM_SLEEP)
xlim([0 500])

clear F S T P NOVERLAP WINDOW banda_delta banda_emg banda_theta banda_gamma srate idxs idxs_D idxs_T 


