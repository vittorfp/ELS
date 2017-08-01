
%Detecta artefatos de movimento e os substitui pela média dos dados a seu
%redor

%passa os dados que vao ser analisados para
data = HIPO_1khz;

utreshold =  1.5; %Definido empiricamente
ltreshold =  -1.5; %Definido empiricamente
A = find(data > utreshold || data < ltreshold);

%su bstitui os valores na variável de origem
clear utreshold ltreshold data len i