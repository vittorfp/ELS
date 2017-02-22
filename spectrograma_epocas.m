%% Power spectrum

len = length( Epocas);

t1=(1:1:len)/1000;

params.Fs=1000; % sampling frequency
params.fpass=[1 50]; % band of frequencies to be kept
params. tapers = [10 10]; % taper parameters
params.pad=0; % pad factor for fft
params.err=[0 0.05];
params.trialave = 0;


params2.Fs=1000; % sampling frequency
params2.fpass=[90 140]; % band of frequencies to be kept
params2. tapers=[5 9]; % taper parameters
params2.pad=0; % pad factor for fft
params2.err=[0 0.05];
params2.trialave=0;

for m = 1:len 
    Dado = Epocas(m,:)
    [S2,t2,f2]=mtspecgramc(Dado(m)',[1.5 0.001],params2);

    [S,t,f]=mtspecgramc(Dado(m)',[1.5 0.001],params);

                
    subplot(3,1,1);
    plot(t1,Dado(m));
    xlim([0 10]);

    subplot(3,1,2);
    imagesc(t,f,log( ( S/ mean( S(1,:)) )')      );  
    % set(gca,'fontsize',12) 
    xlabel('Time (s)') 
    ylabel('Frequency (Hz)' )
    colorbar off
    axis xy
    % ylim([80 320])
    % xlim([0 0.6]);
    set(gcf,'color','white')

    subplot(3,1,3);
    imagesc(t2,f2,S2')
    % set(gca,'fontsize',12)
    xlabel('Time (s)') 
    ylabel('Frequency (Hz)' )
    colorbar off
    axis xy
    %ylim([120 300])
    % xlim([0 0.6]);
    set(gcf,'color','white')
    pause
end