


dado = Epocas;  //O script recebe os dados ja separados em epocas
treshold =  //Definido empiricamente
len = length(Epocas);

for i=1:len 

	if ( max(Epocas(i,:)) > treshold )
		Epocas(i,:) = 	NaN;
	end

end

