


dado = Epocas;  % O script recebe os dados ja separados em epocas
utreshold =  1.5; %Definido empiricamente
ltreshold =  -1.5; %Definido empiricamente
len = size(Epocas);

for i=1:len(1)

	if ( min(Epocas(i,:)) < ltreshold ) || ( min(Epocas(i,:)) > utreshold )
		Epocas(i,:) = NaN;
	end

end

clear utreshold ltreshold dado len i