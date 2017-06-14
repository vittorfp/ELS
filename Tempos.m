%% Processa o tempo de cada rato em cada estágio

for rat_num = [41:44 47:50 52 54:60] 
	REM = 0;
	SWS = 0;
	WAKEA = 0;
	WAKER = 0;
	total = 0;
	for slice_num = [1:4]
		
		rato = sprintf('%d_%d',rat_num,slice_num);
		file = sprintf('/home/vittorfp/Documentos/Neuro/Dados/percentuals/R%s_times.mat',rato);

		load(file);
		REM = REM + REM_time;
		SWS = SWS + SWS_time;
		WAKEA = WAKEA + WAKEA_time;
		WAKER = WAKER + WAKE_time;
		total = total + total_time;
		
		if(sum([REM SWS WAKEA WAKER]) ~= total)
			disp(slice_num)
		end
		
	end
	file = sprintf('/home/vittorfp/Documentos/Neuro/Dados/percentuals/R%d_percents.mat',rat_num);
	rem_p = REM*100/total;
	sws_p = SWS*100/total;
	wr_p = WAKER*100/total;
	wa_p = WAKEA*100/total;
	save(file,'rem_p','sws_p','wr_p','wa_p' );
	d = sprintf('%d\nState percentual:\n\n\t REM: %.1f\n\t SWS: %.1f\n\tWAKE_R: %.1f\n\tWAKE_A: %.1f',rat_num,rem_p,sws_p,wr_p,wa_p);
	%disp(d);

end
	