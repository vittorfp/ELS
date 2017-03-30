
%Detecta artefatos de movimento e os substitui pela média dos dados a seu
%redor

%passa os dados que vao ser analisados para
data = ;

utreshold =  1.5; %Definido empiricamente
ltreshold =  -1.5; %Definido empiricamente
len = size(data);
A = [];
for i=1:len(1)

	if ( min(data(i)) < ltreshold ) || ( min(data(i)) > utreshold )
		A = [A i];
	end

end

for i = A
   data(i) = ( data(i+1) + data(i+1) ) / 2;
end

%substitui os valores na variável de origem
= data;

clear utreshold ltreshold dado len i