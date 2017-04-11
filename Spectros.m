%% Calcula spectro de frequencia dos dados (costuma demorar bastante)
%[41:44 47:50 52 54:60 41:44 47:50 52 54:60] 

folder = '/home/vittorfp/Documentos/Neuro/Dados/ELS_data/'
folder2 = sprintf('%skhz/',folder);
folder3 = sprintf('%sspectrograms/',folder2);

for i = [41:44 47:50 52 54:60 ] 
   for j = 1:4
        srate=1000;
        WINDOW=10;  
        NOVERLAP=5;

        rat_num = 41;
        slice_num = 1;

        load( sprintf('%sR%dHIPO%d_1khz.mat',folder2,rat_num,slice_num), 'HIPO_1khz');

        utreshold =  1.5; %Definido empiricamente
        ltreshold =  -1.5; %Definido empiricamente
        A = find(HIPO_1khz > utreshold | HIPO_1khz < ltreshold);
        
        [S,F,T,P] = spectrogram(HIPO_1khz,WINDOW*srate,NOVERLAP*srate,[],srate);
        A1 = floor( A ./ ( length(HIPO_1khz)/length(T) ) );
        clear HIPO_1khz
        save(sprintf('%sR%d_%d_spectrogram.mat',folder3, rat_num,slice_num ),'S','F','T','P');

        clear S F T P 
        disp('A primeira parte ja foi, ainda falta o miograma ...');
        load( sprintf('%sR%dMIO%d_1khz.mat',folder2,rat_num,slice_num), 'MIO_1khz');

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
        save(sprintf('%sR%d_%d_spectrogram.mat',folder3, rat_num,slice_num ),'S2','F2','T2','P2','A','-append');
        clear S2 F2 T2 P2 A utreshold ltreshold Aq A2

        clear srate WINDOW NOVERLAP

        % %%

        %Faz a suavização dos dados filtrados, aplicando uma media de 6 epocas

        load( sprintf('%sR%d_%d_spectrogram.mat',folder3, rat_num,slice_num ), 'F','F2','P','P2','A');
        
        banda_theta = find(F >5 & F < 12 );
        banda_delta = find(F >1 & F < 4);
        banda_gamma = find(F >33 & F < 55);
        banda_emg = find(F2 > 300 & F2 < 500);

        P(banda_theta,A) = NaN;
        P(banda_delta,A) = NaN;
        P(banda_gamma,A) = NaN;
        P(banda_emg , A) = NaN;

        %Emg   = sum( P2(banda_emg , : ) , 'includenan');
        %Theta = sum( P(banda_theta, : ) , 'includenan');
        %Delta = sum( P(banda_delta, : ) , 'includenan');
        %Gamma = sum( P(banda_gamma, : ) , 'includenan');
        Emg   = nansum( P2(banda_emg , : ) );
        Theta = nansum( P(banda_theta, : ) );
        Delta = nansum( P(banda_delta, : ) );
        Gamma = nansum( P(banda_gamma, : ) );
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
        save(sprintf('%sR%d_%d_spectrogram.mat',folder3, rat_num,slice_num ),'Delta_s','Theta_s','Gamma_s','Emg_s','Delta','Theta','Gamma','Emg','-append');
        clear i z y c A S F P S2 F2 P2 banda_gamma banda_emg banda_delta banda_theta Emg Emg_s Gamma Gamma_s Delta Delta_s Theta Theta_s

        
   end
end
