%% Converte de volta para o vetor com os estados em 

Estados_M = zeros(1,length(Theta_s)); 
% 0 = nao classificado
% 1 = REM
% 2 = SWS
% 3 = WAKE_R
% 4 = WAKE_A

Estados_M(1:65) = 2;
Estados_M(66:130) = 1;
Estados_M(131:475) = 2;
Estados_M(476:540) = 1;
Estados_M(541:640) = 2; 
Estados_M(641:650) = 3; 
Estados_M(651:825) = 2 ; 
Estados_M(826:865) = 1; 
Estados_M(866:900) = 2; 
Estados_M(901:940) = 3; 
Estados_M(940:1060) = 4; 
Estados_M(1061:1170) = 2; 
Estados_M(1171:1230) = 1; 
Estados_M(1231:1360) = 2; 
Estados_M(1361:1400) = 1; 
Estados_M(1401:1450) = 2; 
Estados_M(1451:1510) = 1; 
Estados_M(1511:1580) = 2; 
Estados_M(1581:1660) = 1; 
Estados_M(1661:1700) = 2; 
Estados_M(1701:1715) = 4; 
Estados_M(1716:1740) = 3; 
Estados_M(1741:1920) = 2; 
Estados_M(1921:1940) = 3; 
Estados_M(1941:1965) = 4; 
Estados_M(1966:1990) = 3; 
Estados_M(1991:2070) = 4; 
Estados_M(2071:2100) = 3; 
Estados_M(2101:2130) = 4; 
Estados_M(2131:2225) = 2; 
Estados_M(2226:2410) = 4; 
Estados_M(2411:2530) = 2; 
Estados_M(2531:2555) = 3; 
Estados_M(2556:2580) = 2; 
Estados_M(2581:2640) = 1; 
Estados_M(2641:2650) = 2; 
Estados_M(2651:2670) = 4; 
Estados_M(2671:2860) = 2; 
Estados_M(2861:2910) = 1; 
Estados_M(2911:2965) = 3; 
Estados_M(2966:3020) = 4; 
Estados_M(3021:3045) = 3; 
Estados_M(3046:3060) = 4; 
%Estados_M() = ; 
%Estados_M() = ; 
%Estados_M() = ; 
%Estados_M() = ; 
%Estados_M() = ; 
%Estados_M() = ; 
%Estados_M() = ; 
%Estados_M() = ; 
%Estados_M() = ; 
%Estados_M() = ; 
%Estados_M() = ; 
%Estados_M() = ; 
%Estados_M() = ; 

r = find(Estados_M == 1);
s = find(Estados_M == 2);
w = find(Estados_M == 3);
wa = find(Estados_M == 4);

REM_SLEEP = zeros(1,length(Delta_s));
SW_SLEEP = zeros(1,length(Delta_s));
WAKE = zeros(1,length(Delta_s));
WAKE_A = zeros(1,length(Delta_s));

REM_SLEEP(r) = 1;
SW_SLEEP(s) = 1;
WAKE(w) = 1;
WAKE_A(wa) = 1;


%Plota a figura bonitona com os estados ja corrigidos em Area e patamares
range = 1:4213; 
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

stairs(Estados_M(range));
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