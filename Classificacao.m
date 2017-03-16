dado  = R42MIO1_1khz;

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

SWS = [350:450 480:530 650:765 1700:1750]
 
WAK = [180:330 530:630 1800:2000]

pwelch(R42MIO1_1khz(455:480 .* 1000));

spectrum(R42MIO1_1khz(455:480 .* 1000))
hold on
spectrum(R42MIO1_1khz(1700:1750 .* 1000))
spectrum(R42MIO1_1khz(1800:2000 .* 1000))
xlim([0 0.2])
hold off

Fs = 1000;
[pxx,f] = pwelch(R42MIO1_1khz(455:480 .* 1000),500,300,500,fs);
plot(f,pxx)
hold on
[pxx,f] = pwelch(R42MIO1_1khz(1700:1750 .* 1000),500,300,500,fs);
plot(f,pxx)

[pxx,f] = pwelch(R42MIO1_1khz(1800:2000 .* 1000),500,300,500,fs);
plot(f,pxx)

hold off

xlim([0 20])
xlabel('Frequency (Hz)')
ylabel('PSD (dB/Hz)')
legend('REM','SWS','WK')
grid








