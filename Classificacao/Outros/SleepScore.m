 %% Sleep Score

slice_num = 1;
rat_num = 42;

rato = sprintf('%d_%d',rat_num,slice_num);

file = sprintf('/home/vittorfp/Documentos/Neuro/Dados/Welch/welch_%s.mat',rato);
load(file);
file = sprintf('/home/vittorfp/Documentos/Neuro/Dados/cassificacao_manual/labels-%s.mat',rato);
load(file);
file = sprintf('/home/vittorfp/Documentos/Neuro/Dados/scaled/R%s_scaled.mat',rato);
load(file);


den_r1 = find( f < 55 & f > 2);
num_r1 = find( f < 20 & f > 2);

den_r2 = find( f < 9 & f > 2);
num_r2 = find( f < 4.5 & f > 2);

ratio1 = sum( psd(:,num_r1)' ) ./ sum( psd(:,den_r1)' );
ratio2 = sum( psd(:,num_r2)' ) ./ sum( psd(:,den_r2)' );
%%

rat_num = 42;
slice_num = 1;

rato = sprintf('%d_%d',rat_num,slice_num);

file = sprintf('/home/vittorfp/Documentos/Neuro/Dados/percentuals/R%s_times.mat',rato);
load(file);


Estados(Estados == 4) = 3;

sum(Estados == idx')/length(Estados)
%%
X = [ratio1' ratio2'];


k = 3;
Sigma = {'diagonal','full'};
nSigma = numel(Sigma);
SharedCovariance = {true,false};
SCtext = {'true','false'};
nSC = numel(SharedCovariance);

n1 = 2;
n2 = 1;

options = statset('MaxIter',1000); % Increase number of EM iterations

x1 = linspace(min(X(:,1)) - 2,max(X(:,1)) + 2,d);
x2 = linspace(min(X(:,2)) - 2,max(X(:,2)) + 2,d);
[x1grid,x2grid] = meshgrid(x1,x2);
X0 = [x1grid(:) x2grid(:)];d

gmfit = fitgmdist(X,k,'CovarianceType',Sigma{n1},'SharedCovariance',SharedCovariance{n2},'Options',options);
clusterX = cluster(gmfit,X);
mahalDist = mahal(gmfit,X0);
h1 = gscatter(X(:,1),X(:,2),clusterX);
hold on;
		
idx = mahalDist(:,m)<=threshold;
Color = h1(m).Color*0.75 + -0.5*(h1(m).Color - 1);
h2 = plot(X0(idx,1),X0(idx,2),'.','Color',Color,'MarkerSize',1);
uistack(h2,'bottom');
plot(gmfit.mu(:,1),gmfit.mu(:,2),'kx','LineWidth',2,'MarkerSize',10)

title(sprintf('Sigma is %s, SharedCovariance = %s',Sigma{n1},SCtext{n2}),'FontSize',8)
legend(h1,{'1','2','3'});
hold off
%% MOdelo de mistura gaussiana

X = [ratio2' ratio1'];



Sigma = {'diagonal','full'};
nSigma = numel(Sigma);
SharedCovariance = {true,false};
SCtext = {'true','false'};
nSC = numel(SharedCovariance);

n1 = 1;
n2 = 2;

options = statset('Display','final','MaxIter',1000);
gm = fitgmdist(X,3,'CovarianceType',Sigma{n1}, 'SharedCovariance',SharedCovariance{n2},'Options',options);
idx = cluster(gm,X);

figure(1);
gscatter(X(:,1),X(:,2),idx,'rby','+o*');
legend('Cluster 1','Cluster 2','Cluster 3','Location','NorthWest');
grid on

%%

idx(idx == 1) = 21;
idx(idx == 2) = 22;
idx(idx == 3) = 23;

idx(idx == 21 ) = 2;
idx(idx == 22 ) = 3;
idx(idx == 23 ) = 1;

rat_num = 42;
slice_num = 1;

rato = sprintf('%d_%d',rat_num,slice_num);

file = sprintf('/home/vittorfp/Documentos/Neuro/Dados/percentuals/R%s_times.mat',rato);
load(file);

Estados(Estados == 4) = 3;

sum(idx == Estados')/length(Estados)

%% Clusterização

Estados(find(Estados == 3)) = 4;

figure(1)
subplot(1,2,2);
scatter(ratio2,ratio1,40,Estados(1:length(ratio1)),'filled');
%legend('REM','SWS','WAKE_R','WAKE_A')
ylabel('Ratio 1');
xlabel('Ratio 2');
title('State map - Exemplo');
grid();

subplot(1,2,1);
scatter(ratio2,ratio1,10,'filled');
%legend('REM','SWS','WAKE_R','WAKE_A')
ylabel('Ratio 1');
xlabel('Ratio 2');
title('State map - Classificação manual');
grid();

set(gcf,'color','white');

h = msgbox('Selecione area de SWS');
[vx,vy] = getline(gca,'close');
hold on;
plot(vx,vy,'r','linewidth',3);

SWS = inpolygon(ratio2,ratio1,vx,vy);

h = msgbox('Selecione area de REM');
[vx,vy] = getline(gca,'close');
hold on;
plot(vx,vy,'r','linewidth',3);

REM = inpolygon(ratio2,ratio1,vx,vy);

h = msgbox('Selecione area de WAKE');
[vx,vy] = getline(gca,'close');
hold on;
plot(vx,vy,'r','linewidth',3);

WAKE = inpolygon(ratio2,ratio1,vx,vy);
hold off

E = zeros(size(REM));
E(REM) = 1;
E(SWS) = 2;
E(WAKE) = 3;

n_z = find(E ~= 0);

rat_num = 42;
slice_num = 1;

rato = sprintf('%d_%d',rat_num,slice_num);

file = sprintf('/home/vittorfp/Documentos/Neuro/Dados/percentuals/R%s_times.mat',rato);
load(file);

Estados(Estados == 4) = 3;

p = sum( Estados(n_z) == E(n_z) ) / length(n_z);

p


