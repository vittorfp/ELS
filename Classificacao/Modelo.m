%%
function [probabilities,Value] = Modelo(problem, train_ind, observed_labels)

	%   train_ind: a list of indices into problem.points indicating
	%                    the thus-far observed points
	%   observed_labels: a list of labels corresponding to the
	%                    observations in train_ind


	% Cria um stump usando os samples que ja foram classificados
	S = Stump;
	S.Range = [max(problem.points) min(problem.points)];
	S.BestStump( problem.points(train_ind), observed_labels, ones( size(observed_labels) ) / length(observed_labels) );
	
	% Coloca os resultados nas variaveis apropriadas
	probabilities = S.Apply(problem.points);
	Value = S.Value;
end
 