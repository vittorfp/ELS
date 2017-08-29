%% Algorítmo Delta-PFC  Theta-Hipo

slice_num = 2;
rat_num = 55;



rato = sprintf('%d_%d',rat_num,slice_num);

% Carrega dados do HIPOCAMPO
file = sprintf('/home/vittorfp/Documentos/Neuro/Dados/Welch/welch_%s.mat',rato);
load(file);

thip = find(f > 4 & f < 12);
ThetaHIPO = sum(psd(:,thip)');

clear psd f thip file

% Carrega dados do CORTEX PRE-FRONTAL
file = sprintf('/home/vittorfp/Documentos/Neuro/Dados/WelchPFC/welch_PFC_%s.mat',rato);
load(file);

dpfc = find(f > 0.5 & f < 4);
DeltaPFC = sum(psd(:,dpfc)');

clear psd f dpfc file
%
window_size = 15;
%tf = tsmovavg(ThetaHIPO,'s',window_size,1);
TH = movmean(ThetaHIPO,window_size);
DP = movmean(DeltaPFC,window_size);

TD = TH ./ DP;


[f,xi] = ksdensity(TD);

total = sum(f);

for x = fliplr(xi)
	idx = find(xi > x);
	if sum( f(idx) ) > (total*0.06)
		th = x;
		break;
	end
end

r = find(TD > th);

REM = zeros(1,length(TD));
REM(r) = 1;


figure(1);
subplot(4,2,[1 2]);
area(REM);
grid on;
title('Periodos de REM');

subplot(4,2,[3 4]);
plot(TD);
hold on;
plot([0 4300],[th th]);
hold off;
grid on;
title('Theta/Delta');
legend('Density','5% threshold');

subplot(4,2,[5 7]);
ksdensity(TD);
hold on;
plot([th th ],[0 max(f)]);
hold off;
grid on;
title('Density Estimation');
legend('Density','5% threshold');

set(gcf,'color','white');

