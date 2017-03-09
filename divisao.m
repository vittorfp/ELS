dado  = R42MIO1_1khz;

m= floor(length(dado)/10000) ; % número de épocas (de 10s)

 n=10000; % dado em volts

 Epocas=zeros(m,n);

 for i=1:m

     a = 1 + ( i - 1 ) * n;

     b = i*n;

     Epocas(i,:)=dado(a:b);

 end

 clear i m n a b dado