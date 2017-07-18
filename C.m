%%
for rat_num =  [41:44 47:50 52 54:60]
	for slice_num = 1:4 
		
		% Loada os dados
		rato = sprintf('%d_%d',rat_num,slice_num);
		file = sprintf('/home/vittorfp/Documentos/Neuro/Dados/scaled/R%s_scaled.mat',rato);
		load(file);
		disp(rato);
		
		MIO_thresh1 = ones(1,length(Emg_scaled)) .* ( mean(Emg_scaled) ) ;
		MIO_thresh3 = ones(1,length(Emg_scaled)) .* ( nanmean(Emg_scaled) + std(Emg_scaled)/2 );
		
		Dif =   Theta_scaled./Delta_scaled;
		
		DIF_thresh1 = ones(1,length(Theta_scaled)) .* ( nanmean(Dif) + std(Dif)*(3/4) );
		DIF_thresh3 = ones(1,length(Theta_scaled)) .* ( nanmean(Dif)  );



		REM_Prob = zeros(1,length(Delta_scaled));
		SWS_Prob = zeros(1,length(Delta_scaled));
		Active = zeros(1,length(Delta_scaled));
		Rest = zeros(1,length(Delta_scaled));

		SW_SLEEP = zeros(1,length(Delta_scaled));
		REM_SLEEP = zeros(1,length(Delta_scaled));
		WAKE_A = zeros(1,length(Delta_scaled));
		WAKE_R = zeros(1,length(Delta_scaled));


		%Classifica Periodos de atividade
		is_active = find( Emg_scaled > MIO_thresh1(1));
		Active(is_active) = 1;

		%Classifica Periodos de descanso
		is_resting = find( Emg_scaled < MIO_thresh3(1));
		Rest(is_resting) = 1;

		%Classifica provaveis REMs 
		is_rem = find(Dif > DIF_thresh1);
		REM_Prob(is_rem) = 1;
		REM_SLEEP = REM_Prob & (~Active);

		%Classifica provaveis SWSs 
		is_sws = find(Dif < DIF_thresh3(1));
		SWS_Prob(is_sws) = 1;
		SW_SLEEP = SWS_Prob & (~Active);
		SW_SLEEP = SW_SLEEP & (~REM_SLEEP);

		%Classifica estados WAKE
		WAKE_A = Active | ( (~WAKE_A) & (~SW_SLEEP) & (~REM_SLEEP) );
		WAKE_R = (WAKE_A) & (Rest);
		WAKE_A = WAKE_A & (~WAKE_R);

		%
		superposicao = find(REM_SLEEP + SW_SLEEP + WAKE_R + WAKE_A > 1);
		if(length(superposicao) == 0)
			%disp('Nao houveram superposições entre os estados');
		else
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
		wr = find(WAKE_R == 1);
		wa = find(WAKE_A == 1);
		% 0 = nao classificado
		% 1 = REM
		% 2 = SWS
		% 3 = WAKE_R
		% 4 = WAKE_A

		Estados = zeros(1,length(REM_SLEEP));
		Estados(r) = 1;
		Estados(s) = 2;
		Estados(wr) = 3;
		Estados(wa) = 4;

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
		wr = find(Estados == 3);
		wa = find(Estados == 4);

		REM_SLEEP = zeros(1,length(Delta_scaled));
		SW_SLEEP = zeros(1,length(Delta_scaled));
		WAKE_R = zeros(1,length(Delta_scaled));
		WAKE_A = zeros(1,length(Delta_scaled));

		REM_SLEEP(r) = 1;
		SW_SLEEP(s) = 1;
		WAKE_R(wr) = 1;
		WAKE_A(wa) = 1;
		
		% Vê qual o percentual de tempo o Ratovsky fica em cada estado

		total_time = length(REM_SLEEP);
		REM_time = sum(REM_SLEEP);
		SWS_time = sum(SW_SLEEP);
		WAKE_time = sum(WAKE_R);
		WAKEA_time = sum(WAKE_A);

		save(sprintf('/home/vittorfp/Documentos/Neuro/Dados/percentuals/R%d_%d_times.mat', rat_num,slice_num ),'total_time','REM_time','SWS_time','WAKE_time','WAKEA_time','Estados');

	end 
end

clear Active Classes Estados Delta_scaled Theta_scaled Gamma_scaled Emg_scaled Delta_s Theta_s Gamma_s folder folder2 file p_total Gamma Theta Delta rat_num slice_num Thteta Emg Emg_s
%% Plota a figura bonitona com os estados ja corrigidos em Area e patamares
r = find(Estados == 1);
s = find(Estados == 2);
wr = find(Estados == 3);
wa = find(Estados == 4);

REM_SLEEP = zeros(1,length(Delta_scaled));
SW_SLEEP = zeros(1,length(Delta_scaled));
WAKE_R = zeros(1,length(Delta_scaled));
WAKE_A = zeros(1,length(Delta_scaled));
%%

range = 1:length(Delta_scaled); 
%range = 1:1000;
figure(2)
subplot(4,1,1)
plot(Delta_scaled(range));hold all;plot(Theta_scaled(range) );plot(Emg_scaled(range) );
%plot(REM_threshD(range) );plot(REM_threshT(range) );plot(MIO_thresh(range) );
hold off;
figure(gcf);
legend('Delta','Theta','EMG');%,'REM Delta Treshold','REM Theta Treshold','MIO Treshold'
title('Arquitetura do sono');
%xlabel('Epocas de 10s');
ylabel('Potencia');
%ylim([-0.3 1.3]);
xlim([min(range) max(range)]);
grid();


subplot(4,1,2)
h = area(REM_SLEEP(range));
h.LineWidth = 0.001;
%h.EdgeColor = 'none';
h.FaceColor = [85/255 20/255 201/255];
hold on;


h = area(SW_SLEEP(range));	
h.FaceColor = [85/255 151/255 221/255];
h.LineWidth = 0.01;
h.EdgeAlpha = 0.5;

h = area(WAKE_A(range));
h.FaceColor = [200/255 240/255 200/255];
%h.EdgeColor = 'none';
h.LineWidth = 0.0001;
%h.EdgeAlpha = 0.5;

h = area(WAKE_R(range));
h.FaceColor = [85/255 220/255 200/255];
%h.EdgeColor = 'none';
h.LineWidth = 0.0001;
%h.EdgeAlpha = 0.5;

hold off;
%plot(Emg_s);hold all; plot(MIO_thresh);hold off
xlim([min(range) max(range)]);
set(gca,'YTick',[]);
%title('REM Stages');
%xlabel('Epocas de 10s');
%ylabel('Estado');
legend('REM','SWS','WAKE_A','WAKE_R');
ylim([0 1]);
grid();

subplot(4,1,[3 4]);

stairs(Estados(range));
ylim([0.5 4.5]);
xlim([min(range) max(range)]);
%yticks([1 2 3]);
%yticklabels({'REM','SWS','WAKE'});
set(gca,'YTick',[1:4]);
set(gca,'YTickLabel',{'REM' 'SWS' 'WAKE R' 'WAKE A'});
%title('Arquitetura do sono');
xlabel('Epocas de 5s');
ylabel('Estado');
grid();

set(gcf,'color','white');

clear h res a i j z next last r w s superposicao


