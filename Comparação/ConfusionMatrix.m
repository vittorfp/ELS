%% Plota uma matriz de confusão
% Essa matriz pode ajudar a ver como os classificadores estão discordando e
% talvez já adiantar algo no calculo do criterio Kappa de Cohen

% Carrega os dados
load('/home/vittorfp/Documentos/Neuro/Dados/cassificacao_manual/labels-42_1.mat','Estados')
E = Estados;
load('/home/vittorfp/Documentos/Neuro/Dados/percentuals/R42_1_times.mat','Estados')


% Gera a matriz inicial
ConfusionMatrix = zeros(4);

len = min(length(E),length(Estados));
for i = 1:len
		ConfusionMatrix(E(i),Estados(i))  = ConfusionMatrix(E(i),Estados(i)) + 1;
end

figure(1);
colormap jet;
imagesc(ConfusionMatrix);
h = gca;
h.XTick = [ 1 2 3 4 ];
h.YTick = [ 1 2 3 4 ];
h.XTickLabels = {'REM', 'SWS', 'WAKE_R' , 'WAKE_A'};
h.YTickLabels = {'REM', 'SWS', 'WAKE_R' , 'WAKE_A'};
title('Matriz de confusão');

for i = 1:4
	for j = 1:4
		text(i,j,num2str(ConfusionMatrix(j,i)),'HorizontalAlignment','center','Color','white','FontSize',14);
	end
end
ylabel('Manual');
xlabel('Automática');
box off;
set(gcf,'color','w');


% Conclusões da figura qualitativa:
%
%	CLASSIFICADOR ANTIGO
%	O 1o classificador está errando bastante com relação aos estados
%	acordados. Os estados que eram para ser Wake Active ele está
%	classificando muitas vezes como Wake Resting e algumas como SWS.
%	Os estados acordado ativo ele está classificando na maioria das vezes
%	como SWS. O sono REM ele está classificando bem e os periodos que eram
%	pra se SWS também estão bons.
%
%	CLASSIFICADOR NOVO
%	


