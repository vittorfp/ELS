%% Calcula spectro de frequencia dos dados (costuma demorar bastante)
% 47:50 52 54:60
for i = 42
   for j = 1:4
        srate=1000;
        WINDOW=10;  
        NOVERLAP=5;

        rat_num = 42;
        slice_num = 1;

        load( sprintf('/home/vittorfp/Documentos/Neuro/Dados/ELS_data/khz/R%dHIPO%d_1khz.mat',rat_num,slice_num), 'HIPO_1khz');

        utreshold =  1.5; %Definido empiricamente
        ltreshold =  -1.5; %Definido empiricamente
        A = find(HIPO_1khz > utreshold | HIPO_1khz < ltreshold);
        
        [S,F,T,P] = spectrogram(HIPO_1khz,WINDOW*srate,NOVERLAP*srate,[],srate);
        A1 = floor( A ./ ( length(HIPO_1khz)/length(T) ) );
        clear HIPO_1khz
        save(sprintf('/home/vittorfp/Documentos/Neuro/Dados/ELS_data/khz/spectrograms/R%d_%d_spectrogram.mat', rat_num,slice_num ),'S','F','T','P');

        clear S F T P 
        disp('A primeira parte ja foi, ainda falta o miograma ...');
        load( sprintf('/home/vittorfp/Documentos/Neuro/Dados/ELS_data/khz/R%dMIO%d_1khz.mat',rat_num,slice_num), 'MIO_1khz');

        %Calcula o envelope do EMG, isso faz com que o dado seja mais suave
        y = hilbert(MIO_1khz);
        MIO_1khz = abs(y);
        clear y

        [S2,F2,T2,P2] = spectrogram(MIO_1khz,WINDOW*srate,NOVERLAP*srate,[],srate); 

        utreshold =  1.5; %Definido empiricamente
        ltreshold =  -1.5; %Definido empiricamente
        A = find(MIO_1khz > utreshold | MIO_1khz < ltreshold);
        A2 = floor( A ./ ( length(MIO_1khz)/length(T2) ) );
        A = [A1' A2'];

        clear MIO_1khz A1 A2
        save(sprintf('/home/vittorfp/Documentos/Neuro/Dados/ELS_data/khz/spectrograms/R%d_%d_spectrogram.mat', rat_num,slice_num ),'S2','F2','T2','P2','A','-append');
        clear S2 F2 T2 P2 A utreshold ltreshold Aq A2

        clear srate WINDOW NOVERLAP

        % %%

        %Faz a suavização dos dados filtrados, aplicando uma media de 6 epocas

        load( sprintf('/home/vittorfp/Documentos/Neuro/Dados/ELS_data/khz/spectrograms/R%d_%d_spectrogram.mat', rat_num,slice_num ), 'F','F2','P','P2','A');
        
        banda_theta = find(F >5 & F < 12 );
        banda_delta = find(F >1 & F < 4);
        banda_gamma = find(F >33 & F < 55);
        banda_emg = find(F2 > 300 & F2 < 500);

        P(banda_theta,A) = NaN;
        P(banda_delta,A) = NaN;
        P(banda_gamma,A) = NaN;
        P(banda_emg , A) = NaN;


        Emg   = sum( P2(banda_emg , : ) , 'includenan');
        Theta = sum( P(banda_theta, : ) , 'includenan');
        Delta = sum( P(banda_delta, : ) , 'includenan');
        Gamma = sum( P(banda_gamma, : ) , 'includenan');
        clear P P2 F F2

        Theta_s = [];
        Delta_s = [];
        Gamma_s = [];
        Emg_s = [];

        c = length(Delta)-3;

        for i = 4:c

            y = i-3;
            z = i+3;

            Theta_s = [Theta_s nanmean( Theta(y:z) ) ];
            Delta_s = [Delta_s nanmean( Delta(y:z) ) ];
            Gamma_s = [Gamma_s nanmean( Gamma(y:z) ) ];
            Emg_s   = [Emg_s   nanmean(  Emg(y:z)  ) ];

        end

        %save('spectrogram.mat','Delta','Theta','Gamma','Delta_s','Theta_s','Gamma_s');
        save(sprintf('/home/vittorfp/Documentos/Neuro/Dados/ELS_data/khz/spectrograms/R%d_%d_spectrogram.mat', rat_num,slice_num ),'Delta_s','Theta_s','Gamma_s','Emg_s','Delta','Theta','Gamma','Emg','-append');
        clear i z y c A S F P S2 F2 P2 banda_gamma banda_emg banda_delta banda_theta Emg Emg_s Gamma Gamma_s Delta Delta_s Theta Theta_s

        
   end
end

%% Grafico para visualizar os limiares

MIO_thresh1 = ones(1,length(Emg_s)) .* ( nanmean(Emg_s) ); %- std(Emg_s)/2 );
MIO_thresh2 = ones(1,length(Emg_s)) .* ( nanmean(Emg_s) - std(Emg_s)/4 );
MIO_thresh3 = ones(1,length(Emg_s)) .* ( nanmean(Emg_s) - std(Emg_s)/2 );

REM_threshD = ones(1,length(Delta_s)) .* ( nanmean(Delta_s) - std(Delta_s)/2 );
REM_threshT = ones(1,length(Theta_s)) .* ( nanmean(Theta_s) ); % + std(Theta_s) );

SWS_threshD = ones(1,length(Delta_s)) .* ( nanmean(Delta_s) );%- std(Delta_s)/2 );
SWS_threshT = ones(1,length(Theta_s)) .* ( nanmean(Theta_s) ); % + std(Theta_s) );

range = 1:2000; 
figure(1)
subplot(2,1,1)
plot(Emg_s(:,range) );hold all;plot(MIO_thresh1(range) );plot(MIO_thresh2(range) );plot(MIO_thresh3(range) );hold off;figure(gcf);
legend('Miograma','Threshold 1','Threshold 2','Threshold 3');
title('Thresholds do EMG');
xlabel('Epocas de 5s');
ylabel('Potência média');
xlim([min(range) max(range)]);
subplot(2,1,2)
plot(Delta_s(:,range));hold all;plot(Theta_s(:,range) );plot(REM_threshD(range) );plot(REM_threshT(range) );hold off;figure(gcf);
legend('Delta','Theta','REM Delta Treshold','REM Theta Treshold');
title('Thresholds do EEG');
xlabel('Épocas de 5s');
ylabel('Potência média');
xlim([min(range) max(range)]);
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

range = 2500:4000; 
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


%%
%Classifica todos os estados (preliminar)


MIO_thresh1 = ones(1,length(Emg_s)) .* ( nanmean(Emg_s) ); %- std(Emg_s)/2 );
MIO_thresh2 = ones(1,length(Emg_s)) .* ( nanmean(Emg_s) - std(Emg_s)/4 );
MIO_thresh3 = ones(1,length(Emg_s)) .* ( nanmean(Emg_s) - std(Emg_s)/2 );

REM_threshD = ones(1,length(Delta_s)) .* ( nanmean(Delta_s) - std(Delta_s)/2 );
REM_threshT = ones(1,length(Theta_s)) .* ( nanmean(Theta_s) ); % + std(Theta_s) );

SWS_threshD = ones(1,length(Delta_s)) .* ( nanmean(Delta_s)  + std(Delta_s)/2 );
SWS_threshT = ones(1,length(Theta_s)) .* ( nanmean(Theta_s) ); % + std(Theta_s) );

REM_SLEEP = zeros(1,length(Delta_s));
SW_SLEEP = zeros(1,length(Delta_s));
WAKE = zeros(1,length(Delta_s));

%Classifica os REMs 
is_rem = find(Delta_s < REM_threshD(1) & Theta_s < REM_threshT(1) & Emg_s < MIO_thresh(1));
REM_SLEEP(is_rem) = 1;

%Classifica os SWS
is_sws = find(Delta_s > REM_threshT(1) & Theta_s > REM_threshT(1) & Emg_s(1:length(Delta_s)) < MIO_thresh(1));
SW_SLEEP(is_sws) = 1;


%Classifica os estados d acordado
is_wake = find( Emg_s(1:length(Delta_s)) > MIO_thresh(1));
WAKE(is_wake) = 1;

%% Plota o grafico com os estados
range = 1:4000; 
figure(1)
subplot(4,1,1)
plot(Delta_s(:,range));hold all;plot(Theta_s(:,range) );plot(Emg_s(:,range) );
%plot(REM_threshD(range) );plot(REM_threshT(range) );plot(MIO_thresh(range) );
hold off;figure(gcf);
legend('Delta','Theta','EMG');%,'REM Delta Treshold','REM Theta Treshold','MIO Treshold'
title('Potencias nas bandas (Suavizado)');
xlabel('Epocas de 10s');
ylabel('Potencia');
xlim([min(range) max(range)]);
grid();

subplot(4,1,2)
area(REM_SLEEP(range));
%plot(Emg_s);hold all; plot(MIO_thresh);hold off
xlim([min(range) max(range)]);
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

clear h MIO_thresh is_rem is_wake is_sws range F S T P NOVERLAP WINDOW banda_delta banda_emg banda_theta banda_gamma srate idxs idxs_D idxs_T 

%% Observa a existencia de incoerencias nas classificações geradas e as corrige.

superposicao = find(REM_SLEEP + SW_SLEEP + WAKE > 1);
if(length(superposicao) == 0)
   disp('Nao houveram superposições entre os estados');
end

% 0 = nao classificado
% 1 = REM
% 2 = SWS
% 3 = WAKE

r = find(REM_SLEEP == 1);
s = find(SW_SLEEP == 1);
w = find(WAKE == 1);

Estados = zeros(1,length(REM_SLEEP));
Estados(r) = 1;
Estados(s) = 2;
Estados(w) = 3;
%stairs(Estados);

z = find(Estados == 0);

%Classifica as epocas que nao foram classificadas anteriormente

for i = z
   if(Estados(i) == 0)
       last = Estados(i - 1);
       j = 0;
       while(Estados(i + j) == 0)
          j = j + 1;
       end
       next = Estados( i + j );
       
       if(last == next) 
           Estados(i:i + j) = next;
       else
           Estados(i : i + j) = min([last next]);
       end
   end
end


%Elimina classificações incoerentes, como REMs no meio de periodos WAKE

for i = 1:(length(Estados) -1 )
    res = Estados(i) - Estados(i+1);
    
    if( res == 2  )
        last = Estados( i );
        j = 0;
        while(Estados(i + j) == Estados(i) )
            j = j + 1;
        end

        Estados( i: i + j ) = last;
   
    elseif(res == -2 )
        
        next = Estados( i+1 );
        j = 0;
        while(Estados(i - j) ~= next )
            j = j + 1;
        end

        Estados( i - j : i  ) = next;
   
    end
end

%Converte de volta para o vetor com os estados em 
r = find(Estados == 1);
s = find(Estados == 2);
w = find(Estados == 3);

REM_SLEEP = zeros(1,length(Delta_s));
SW_SLEEP = zeros(1,length(Delta_s));
WAKE = zeros(1,length(Delta_s));

REM_SLEEP(r) = 1;
SW_SLEEP(s) = 1;
WAKE(w) = 1;


%Plota a figura bonitona com os estados ja corrigidos em Area e patamares
range = 1:4000; 
figure(1)
subplot(4,1,1)
plot(Delta_s(:,range));hold all;plot(Theta_s(:,range) );plot(Emg_s(:,range) );
%plot(REM_threshD(range) );plot(REM_threshT(range) );plot(MIO_thresh(range) );
hold off;figure(gcf);
legend('Delta','Theta','EMG');%,'REM Delta Treshold','REM Theta Treshold','MIO Treshold'
title('Arquitetura do sono');
%xlabel('Epocas de 10s');
ylabel('Potencia');
xlim([0 length(Delta_s(range))]);
grid();


subplot(4,1,2)
h = area(REM_SLEEP(range));

h.LineWidth = 0.001;
%h.EdgeColor = 'none';
h.FaceColor = [85/255 20/255 201/255];
hold on;


h = area(WAKE(range));
h.FaceColor = [85/255 220/255 200/255];
%h.EdgeColor = 'none';
h.LineWidth = 0.0001;
%h.EdgeAlpha = 0.5;

h = area(SW_SLEEP(range));
h.FaceColor = [85/255 151/255 221/255];
h.LineWidth = 0.01;
h.EdgeAlpha = 0.5;

hold off;
%plot(Emg_s);hold all; plot(MIO_thresh);hold off
xlim([0 length(Emg_s(range))]);
set(gca,'YTick',[]);
%title('REM Stages');
%xlabel('Epocas de 10s');
%ylabel('Estado');
legend('REM','WAKE','SWS');
grid();

subplot(4,1,[3 4]);

stairs(Estados(range));
ylim([0.5 3.5]);
xlim([0 length(Emg_s(range))]);
%yticks([1 2 3]);
%yticklabels({'REM','SWS','WAKE'});
set(gca,'YTick',[1:3]);
set(gca,'YTickLabel',{'REM' 'SWS' 'WAKE'});
%title('Arquitetura do sono');
xlabel('Epocas de 10s');
ylabel('Estado');
grid();

set(gcf,'color','white');

clear h res a i j z next last r w s superposicao


%% Treina SVM
% Tentativa de treinar uma SVM paraa classificar o esquema 
% rolou medio, ta rolando undersampling na class REM, ai ele nao ta
% classificando direito, ta lançando como WAKE em todos.

T = table;
T.Delta = Delta_s';
T.Theta = Theta_s';
T.Gamma = Gamma_s';
T.Emg = Emg_s(1:4307)';
T.Estados = Estados';


Mdl = fitcecoc(T,'Estados');
label = predict(Mdl,T(:, 1:4 ) );
stairs(label)
ylim([0 4]);
xlim([0 4000]);
set(gca,'YTick',[1:3]);
set(gca,'YTickLabel',{'REM' 'SWS' 'WAKE'});

%% Percentual em cada estado

%Vê qual o percentual de tempo o Ratovsky fica em cada estado

total_time = length(REM_SLEEP);
REM_time = sum(REM_SLEEP);
SWS_time = sum(SW_SLEEP);
WAKE_time = sum(WAKE);

save(sprintf('/home/vittorfp/Documentos/Neuro/Dados/ELS_data/khz/percentuals/R%d_%d_times.mat', rat_num,slice_num ),'total_time','REM_time','SWS_time','WAKE_time');


d = sprintf('State percentual:\n\n\t REM: %.1f\n\t SWS: %.1f\n\tWAKE: %.1f',REM_time*100/total_time,SWS_time*100/total_time,WAKE_time*100/total_time);
disp(d);

clear d total_time REM_time SWS_time WAKE_time

