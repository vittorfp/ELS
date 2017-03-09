s = size(Epocas);
pot = zeros(s(1),2);      %Constroi uma matriz para abrigar a potencia do theta e do delta

for i=1:s(1)
   [delta] = eegfilt(Epocas(i,:),1000,1,4);
   [theta] = eegfilt(Epocas(i,:),1000,5,12);
    
    
   pot(i,1) = ( norm(delta) ^ 2 ) / s(2);
   pot(i,2) = ( norm(theta) ^ 2 ) / s(2);

end