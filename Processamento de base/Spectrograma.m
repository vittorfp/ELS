load('/home/vittorfp/Documentos/R42HIPO1.mat')

dado  = R42HIPO1_1khz;

m= floor(length(dado)/10000) ; % número de épocas (de 10s)

 n=10000; % dado em volts

 Epocas=zeros(m,n);

 for i=1:m

     a = 1 + ( i - 1 ) * n;

     b = i*n;

     Epocas(i,:)=dado(a:b);

 end

 clear i m n a b 
 
 
utreshold =  1.5; %Definido empiricamente
ltreshold =  -1.5; %Definido empiricamente
len = size(Epocas);
A = [];

for i=1:len(1)

	if ( min(Epocas(i,:)) < ltreshold ) || ( min(Epocas(i,:)) > utreshold )
		A = [A i];
	end

end
Epocas(A,:) = NaN;
clear utreshold ltreshold dado len i A

%     EPOCAS DE EXEMPLO -> Levando em conta as 6 primeiras horas do LFP do HIPOCAMPO do RATO42
%     
%     REM: 455:480 770:785 1280:1305 1532:1550 1653:1668 2070:2085 2111:2121 2150:2168 2295:2320
%
%     SWS: 350:450 480:530 650:765 1700:1750
%   
%     WAK: 180:330 530:630 1800:2000
%

REM = [455:480 770:785 1280:1305 1532:1550 1653:1668 2070:2085 2111:2121 2150:2168 2295:2320 ];

SWS = [350:450 480:530 650:765 1700:1750];
 
WAK = [180:330 530:630 1800:2000];

srate=1000;
WINDOW=10;
NOVERLAP=5;

banda_emg = 300:500;
banda_theta = 4:9;
banda_delta = 1:4;
banda_gamma = 33:55;


%[s,f,t] = spectrogram(Epocas(400,:),2,1,[],srate)

[S,F,T,P] = spectrogram(R42HIPO1_1khz,WINDOW*srate,NOVERLAP*srate,[],srate);


window = 1000;
noverlap = 990;
epk = 400;

figure(1);
set(1, 'Position', [1 1 1000 300])
subplot(3,1,1)
plot(Epocas(epk,:))
xlim([(window/2)-(noverlap/2) (10000-window/2)+(noverlap/2) ]);
ylabel('Amplitude (Volts)')
xlabel('Time(s)')
title('Hipocampus LFP')

subplot(3,1,2)
colormap(jet)
spectrogram(Epocas(epk,:),window,[],1024,1000,'yaxis');
colorbar off
%ylim([0 50])
title('Frequency spectrum')
set(gcf,'color','white')
   