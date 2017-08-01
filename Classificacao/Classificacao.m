

for rat_num =  [41:44 47:50 52 54:60]

	for slice_num = 1:4 
		
		% Loada os dados
		rato = sprintf('%d_%d',rat_num,slice_num);
		file = sprintf('/home/vittorfp/Documentos/Neuro/Dados/light/R%s_spectrogram.mat',rato);
		load(file);
		disp(rato);
		
		% Classifica todos os estados

		MIO_thresh1 = ones(1,length(Emg_s)) .* ( nanmean(Emg_s) ) ; %- std(Emg_s)/2 );
		MIO_thresh2 = ones(1,length(Emg_s)) .* ( nanmean(Emg_s) - std(Emg_s)/4 );
		MIO_thresh3 = ones(1,length(Emg_s)) .* ( nanmean(Emg_s) - std(Emg_s)/2 );

		REM_threshD = ones(1,length(Delta_s)) .* ( nanmean(Delta_s) - std(Delta_s)*(3/4) );
		REM_threshT = ones(1,length(Theta_s)) .* ( nanmean(Theta_s) + std(Delta_s)*(1/4) ); % + std(Theta_s) );

		SWS_threshD = ones(1,length(Delta_s)) .* ( nanmean(Delta_s)  + std(Delta_s)/3 );
		SWS_threshT = ones(1,length(Theta_s)) .* ( nanmean(Theta_s) ); % + std(Theta_s) );

		Dif =   Delta_s-Theta_s;
		DIF_threshS = ones(1,length(Theta_s)) .* ( nanmean(Dif) + std(Dif)*(2/4) );
		DIF_threshW = ones(1,length(Theta_s)) .* ( nanmean(Dif) + std(Dif) );
		DIF_threshWA = ones(1,length(Theta_s)) .* ( nanmean(Dif)- std(Dif)/4  );


		REM_SLEEP = zeros(1,length(Delta_s));
		SW_SLEEP = zeros(1,length(Delta_s));
		WAKE = zeros(1,length(Delta_s));

		%Classifica os REMs 
		is_rem = find(Delta_s < REM_threshD(1) & Theta_s < REM_threshT(1)   & Emg_s < MIO_thresh2(1));
		REM_SLEEP(is_rem) = 1;

		%Classifica os SWS
		is_sws = find( ( ( Delta_s > SWS_threshD(1) ) & ( Theta_s > SWS_threshT(1) ) & ( Emg_s < MIO_thresh1(1) ) )  & (Dif > DIF_threshS(1)) );
		SW_SLEEP(is_sws) = 1;


		%Classifica os estados d acordado
		is_wake = find( Emg_s > MIO_thresh1(1) & (Dif < DIF_threshS & Dif > -DIF_threshS ) );
		WAKE(is_wake) = 1;

		% Observa a existencia de incoerencias nas classificações geradas e as corrige.
			
		superposicao = find(REM_SLEEP + SW_SLEEP + WAKE > 1);
		if(length(superposicao) ~= 0)
			for i = superposicao
				if REM_SLEEP(i) == 1 
					WAKE(i) = 0;
					SW_SLEEP(i) = 0;
				elseif SW_SLEEP(i) == 1
					WAKE(i) = 0;
				end
			end
		end

		r = find(REM_SLEEP == 1);
		s = find(SW_SLEEP == 1);
		w = find(WAKE == 1);
		% 0 = nao classificado
		% 1 = REM
		% 2 = SWS
		% 3 = WAKE
		Estados = zeros(1,length(REM_SLEEP));
		Estados(r) = 1;
		Estados(s) = 2;
		Estados(w) = 3;



		% Classifica as epocas que nao foram classificadas anteriormente

		%stairs(Estados);

		z = find(Estados == 0);

		for i = z
		   if(Estados(i) == 0)
			   if(i == 1)
					last = Estados(i);
			   else
				   last = Estados(i - 1);
			   end

			   j = 0;
			   while( Estados(i + j) == 0)
				  j = j + 1;
				  if( (i+j) > length(Estados))
					 j = j-1;
					 Estados( i + j ) = last;
					 break;
				  end
			   end
			   next = Estados( i + j );

			   if(last == next) 
				   Estados(i:i + j) = next;
			   else
				   Estados(i : i + j) = max([last next]);
			   end
		   end
		end


		% Elimina classificações incoerentes, como REMs no meio de periodos WAKE

		for i = 1:(length(Estados) -1 )
			res = Estados(i) - Estados(i+1);

			if( res == 2  )
				last = Estados( i );
				j = 0;
				while(Estados(i + j) == Estados(i) )
					j = j + 1;
				end

				Estados( i: i + j ) = last;

			elseif(res == -2 )
				next = Estados( i );
				j = 0;
				while(Estados(i - j) == next )
					j = j + 1;
				end
				Estados( i - j : i ) = max([next Estados(i - j)]);

			end
		end
		% Elimina Estados com menos de 1 minuto

		nEpocas = 12; % 12 epocas equivalem a 1 minuto

		i=2;
		n = 1;
		while i >= 1 && i < length(Estados)
			if Estados(i) == Estados(i+1)
				n = n + 1;
			else
				if n < nEpocas
					Estados(i-n:i) = max([Estados(i-n-1) Estados(i+1)]);
				end
				n = 1;
			end
			i = i + 1;
		end
		% Classifica subestados de WAKE (ativo/repouso)


		w = find(Estados == 3);

		for i = w
			if(Emg_s(i) > MIO_thresh2(1)  )
				Estados(i) = 4;
			end
		end
		% Elimina Estados com menos de 1 minuto

		nEpocas = 12; % 12 epocas equivalem a 1 minuto

		i=2;
		n = 1;
		while i >= 1 && i < length(Estados)
			%disp(i);
			if Estados(i) == Estados(i+1)
				n = n + 1;
			else
				if n <= nEpocas
					Estados(i-n:i) = max([Estados(i-n) Estados(i+1)]);
				end
				n = 1;
			end
			i = i + 1;
		end
		% Converte de volta para o vetor com os estados em 
		r = find(Estados == 1);
		s = find(Estados == 2);
		w = find(Estados == 3);
		wa = find(Estados == 4);

		REM_SLEEP = zeros(1,length(Delta_s));
		SW_SLEEP = zeros(1,length(Delta_s));
		WAKE = zeros(1,length(Delta_s));
		WAKE_A = zeros(1,length(Delta_s));

		REM_SLEEP(r) = 1;
		SW_SLEEP(s) = 1;
		WAKE(w) = 1;
		WAKE_A(wa) = 1;
		
		
		% Percentual em cada estado

		%Vê qual o percentual de tempo o Ratovsky fica em cada estado

		total_time = length(REM_SLEEP);
		REM_time = sum(REM_SLEEP);
		SWS_time = sum(SW_SLEEP);
		WAKE_time = sum(WAKE);
		WAKEA_time = sum(WAKE_A);

		save(sprintf('/home/vittorfp/Documentos/Neuro/Dados/ELS_data/khz/percentuals/R%d_%d_times.mat', rat_num,slice_num ),'total_time','REM_time','SWS_time','WAKE_time','WAKEA_time');


		d = sprintf('State percentual:\n\n\t REM: %.1f\n\t SWS: %.1f\n\tWAKE_R: %.1f\n\tWAKE_A: %.1f',REM_time*100/total_time,SWS_time*100/total_time,WAKE_time*100/total_time,WAKEA_time*100/total_time);
		%disp(d);

		clear d total_time REM_time SWS_time WAKE_time WAKEA_time
	end
end
