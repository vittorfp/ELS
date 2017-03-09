


utreshold =  1.5; %Definido empiricamente
ltreshold =  -1.5; %Definido empiricamente
len = size(Epocas);
%A = [];
for i=1:len(1)

	if ( min(Epocas(i,:)) < ltreshold ) || ( min(Epocas(i,:)) > utreshold )
		A = [A i];
	end

end

clear utreshold ltreshold dado len i