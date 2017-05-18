%% Processa o tempo de cada rato em cada estágio

rat_num = 41;

REM = 0;
SWS = 0;
WAKEA = 0;
WAKER = 0;
total = 0;

for slice_num = [1:4]
	rato = sprintf('%d_%d',rat_num,slice_num);
	file = sprintf('/home/vittorfp/Documentos/Neuro/Dados/ELS_data/khz/percentuals/R%s_times.mat',rato);
	
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
sum([REM SWS WAKEA WAKER])
total

d = sprintf('State percentual:\n\n\t REM: %.1f\n\t SWS: %.1f\n\tWAKE_R: %.1f\n\tWAKE_A: %.1f',REM*100/total,SWS*100/total,WAKER*100/total,WAKEA*100/total);
disp(d);
	