clc;format short;format compact; 

%% Loads workspaces
load('Workspace_003.mat');
load('Workspace_035.mat');
load('Workspace_028.mat');
load('Workspace_012.mat');
load('Workspace_019.mat');


%% dBm
Power2= 10*log10((Power2)/1e-3);
Power35= 10*log10((Power35)/1e-3);
Power28= 10*log10((Power28)/1e-3);
Power12= 10*log10((Power12)/1e-3);
Power19= 10*log10((Power19)/1e-3);


%% Plot

figure,plot(Lambda12,Power12,Lambda19,Power19,Lambda2,Power2,Lambda28,Power28,Lambda35,Power35);
hold off, grid off
title('Output Spectrum');
xlabel('Wavelength [nm]');
ylabel('Power [dBm]');
axis([1564.8 1567.5 -50 20]);
l = legend ('0.430 ','0.680','1.0','4.01','14.0');
title(l,'Brillouin Pump [mW]');
text(1564.9,15,'Pump = 200 mW');
text(1564.9,12,'Central Wavelength = 1565.8 nm');

