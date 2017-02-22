%% Power spectrum 

Data=R42HIPO1_1khz;
%(13783000:13793000)
M=Data(14842000:14852000);

t1=(1:1:length(M))/1000;

params.Fs=1000; % sampling frequency
params.fpass=[1 50]; % band of frequencies to be kept
params. tapers = [5 9]; % taper parameters
params.pad=0; % pad factor for fft
params.err=[0 0.05];
params.trialave = 0;


        [S,t,f]=mtspecgramc(M',[1 0.001],params);
        
        
params2.Fs=1000; % sampling frequency
params2.fpass=[120 180]; % band of frequencies to be kept
params2. tapers=[5 9]; % taper parameters
params2.pad=0; % pad factor for fft
params2.err=[0 0.05];
params2.trialave=0;


        [S2,t2,f2]=mtspecgramc(M',[0.5 0.001],params2);
        
subplot(3,1,1);
plot(t1,M);
xlim([0 t(end)]);
        
subplot(3,1,2);
imagesc(t,f,log( ( S/ mean(S(1,:)) )')      );  
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