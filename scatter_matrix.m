x = [Delta_s' Theta_s' Gamma_s' Emg_s'];
y = [Theta_s(1:3060)'./Delta_s(1:3060)' Emg_s(1:3060)'];

[h,ax,bigax] = gplotmatrix(y,[],Estados(1:3060)',[],'.',5,'on','grpbars');
set(gcf,'color','white');

title(bigax,'Matriz de scatter plots');

ylabel(ax(1,1),'Theta/Delta');
ylabel(ax(2,1),'EMG');
%ylabel(ax(3,1),'Gamma');
%ylabel(ax(4,1),'EMG');

xlabel(ax(2,1),'Theta/Delta');
xlabel(ax(2,2),'EMG');
%xlabel(ax(4,3),'Gamma');
%xlabel(ax(4,4),'EMG');

for i = 1:4
    for j = 1:4
        grid(ax(i,j))
    end
end

%% 
%scatter3(Delta_s./Theta_s,Emg_s,Gamma_s);

x = [Delta_s' Theta_s' Gamma_s' Emg_s'];


[h,ax,bigax] = gplotmatrix(x,[],Estados',[],'.',5,'on','grpbars');
set(gcf,'color','white');

title(bigax,'Matriz de scatter plots');

ylabel(ax(1,1),'Delta');
ylabel(ax(2,1),'Theta');
ylabel(ax(3,1),'Gamma');
ylabel(ax(4,1),'EMG');

xlabel(ax(4,1),'Theta/Delta');
xlabel(ax(4,2),'EMG');
xlabel(ax(4,3),'Gamma');
xlabel(ax(4,4),'EMG');

for i = 1:4
    for j = 1:4
        grid(ax(i,j))
    end
end