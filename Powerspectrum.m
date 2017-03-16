%% Power spectrum 

Data=R42HIPO1_1khz;
%(13783000:13793000)(14842000:14852000)(2500000:2510000)(14842000:14852000)(1339*10000:1343*10000)
M=Data(1340*10000:1343*10000);

t1=(1:1:length(M))/1000;

params.Fs=1000; % sampling frequency
params.fpass=[1 50]; % band of frequencies to be kept
params. tapers = [3 5]; % taper parameters
params.pad=2; % pad factor for fft
params.err=[0 0.5];
params.trialave = 0;


        [S,t,f]=mtspecgramc(M',[0.3 0.001],params);
        
        
params2.Fs=1000; % sampling frequency
params2.fpass=[80 200]; % band of frequencies to be kept
params2. tapers=[5 7]; % taper parameters
params2.pad=2; % pad factor for fft
params2.err=[0 0.05];
params2.trialave=0;


        [S2,t2,f2]=mtspecgramc(M',[0.5 0.001],params2);
        
subplot(3,1,1);
plot(t1,M);
xlim([0.25 t(end)]);

xlabel('Time (s)') 
ylabel('Hipocampus LFP (V)' );

subplot(3,1,2);
imagesc(t,f, S' );  

xlabel('Time (s)') 
ylabel('Frequency (Hz)' );
% set(gca,'fontsize',12) 
colorbar off
axis xy
% ylim([80 320])
% xlim([0 0.6]);
set(gcf,'color','white')

subplot(3,1,3);
imagesc(t2,f2,log( ( S2/ mean( S2(1,:)) )'))
% set(gca,'fontsize',12)
xlabel('Time (s)') 
ylabel('Frequency (Hz)' )
colorbar off
axis xy
%ylim([120 300])
% xlim([0 0.6]);
set(gcf,'color','white')
colormap(jet)
