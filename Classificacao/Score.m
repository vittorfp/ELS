%%
function [Value] = Score(problem, train_ind, observed_labels)

	%   train_ind: a list of indices into problem.points indicating
	%                    the thus-far observed points
	%
	%
	%   observed_labels: a list of labels corresponding to the
	%                    observations in train_ind


	% Cria um stump usando os samples que ja foram classificados
	S = Stump;
	S.Range = [min(problem.points) max(problem.points)];
	S.BestStump( problem.points(train_ind), observed_labels,...
		ones( size(observed_labels) ) / length(observed_labels) );
	
	Value = S.Value;
	
	% Coloca os resultados nas variaveis apropriadas
	sum(min(abs(problem.points - Value) ) + Value == problem.points )
	m = median( abs(problem.points(~train_ind) - Value ) );
	Value = find( (m + Value) == problem.points )
	if ~Value
		Value = find( (m - Value) == problem.points );
	end
end
 