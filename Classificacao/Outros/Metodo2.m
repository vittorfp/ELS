%% Metodo do artigo

load('/home/vittorfp/Documentos/Neuro/Dados/Welch/welch_42_1.mat')

% PC1
p = find(f <25);
PC1 = psd(:,p);
PC1 = sum(PC1,2);

figure(1);
ksdensity(PC1);
hold on;
plot([0.031 0.031] , [0 40]);
hold off

title('Potencia (f < 25hz)' );
grid();
legend('Densidade estimada','Threshold');
set(gcf,'color','white');


s = find(PC1 > 0.029);
color = ones(size(PC1));
color(s) = 2;

% Narrow band theta power ratio (5–10 Hz/2–16 Hz)

t1 = find(f > 5 & f < 10);
t2 = find(f > 2 & f < 16);

num = sum(psd(:,t1),2);
den = sum(psd(:,t2),2);

theta = num./den;

figure(2);
ksdensity(theta);

grid();
title('Narrow band theta power ratio (5–10 Hz/2–16 Hz)' );
set(gcf,'color','white');

% EMG

load('/home/vittorfp/Documentos/Neuro/Dados/scaled/R42_1_scaled.mat', 'Emg_scaled');

figure(3);
ksdensity(Emg_scaled);
hold on;
plot([0.1 0.1] , [0 18]);
hold off
grid();
title('EMG');
set(gcf,'color','white');

color( find(Emg_scaled > 0.1) ) = 3;

figure(4)
scatter3(PC1,theta,Emg_scaled,5,color,'filled');
xlabel('PC1');
ylabel('NB-Theta');
zlabel('EMG');

