%% ActiveLearnThreshold
%	Aprende a discernir entre dois estados de EEG/EMG. A rotina utiliza uma
%	SVM como separador e iterativamente pede o usuario para classificar a
%	epoca em que houve menor certeza de classificação. Retorna um vetor de
%	0/1 que distingue entre as classes.

function [CLASS,model] = ActiveLearnThreshold(problem,not)
	flag = 1;
	
	% Carrega dados do rato
	load(['/home/vittorfp/Documentos/Neuro/Dados/khz/R' num2str(problem.rat_num) 'HIPO' num2str(problem.slice_num) '_1khz.mat']);
	load(['/home/vittorfp/Documentos/Neuro/Dados/khz/R' num2str(problem.rat_num) 'MIO' num2str(problem.slice_num) '_1khz.mat']);
	
	while flag == 1
	
		mi = find( problem.points == min(problem.points) );
		ma = find( problem.points == max(problem.points) );
		x = [ mi(1) ; ma(1) ] ;
		y = [0 ; 1];
	
		c = 2;
		
		for i = 1:problem.num_queries

			model = fitcsvm(problem.points(x) , y ,'KernelFunction','rbf','BoxConstraint',Inf,'ClassNames',[0, 1]);
			[label,score] = predict(model,problem.points); 


			a = ones(size(label));
			a(x) = 0;
			a(not == 1) = 0;
			a = logical(a);

			% Escolhe pontos para observar
			in = min( abs(score( a , c) ) );
			
			x_star = find( score(:,c) == in );
			if isempty(x_star)
				x_star = find( score(:,c) == -in );
			end
			x_star = x_star(1);
			%x_star
			% Observa os pontos escolhidos
			y_star = Oracle(problem,MIO_1khz,HIPO_1khz, x_star, x, y);


			% add observation(s) to training set
			x = [x; x_star];
			y = [y; y_star];
			
% 			if c == 1 
% 				c = 2;
% 			elseif c == 2
% 				c = 1;
% 			end
		end

		model = fitcsvm(problem.points(x), y,'KernelFunction','rbf','BoxConstraint',Inf,'ClassNames',[0,1]);
		[CLASS,score] = predict(model,problem.points);

		figure(2)
		subplot(2,1,1)
		area(CLASS)
		subplot(2,1,2)
		plot(problem.points)
		hold on;
		color = y;
		color(color == 0) = 2;
		scatter(x,problem.points(x),30,color,'filled');
		hold off;
		grid on;

		choice = questdlg('A classificação foi satisfatoria?','Classificação','Sim','Não. Bora repetir','Sim');
		if strcmp(choice, 'Sim')
			flag = 0;
			%close(2);
		end
		
	end
end