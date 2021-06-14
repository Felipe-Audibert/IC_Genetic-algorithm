clc;format short;format compact; 

%% Loads workspaces
load('Workspace_005.mat');
load('Workspace_036.mat');
load('Workspace_029.mat');
load('Workspace_013.mat');
load('Workspace_020.mat');

%% dBm
Power4= 10*log10((Power4)/1e-3);
Power36= 10*log10((Power36)/1e-3);
Power29= 10*log10((Power29)/1e-3);
Power13= 10*log10((Power13)/1e-3);
Power20= 10*log10((Power20)/1e-3);

%% Plot

figure,plot(Lambda13,Power13,Lambda20,Power20,Lambda4,Power4,Lambda29,Power29,Lambda36,Power36);
hold off, grid off
title('Output Spectrum');
xlabel('Wavelength [nm]');
ylabel('Power [dBm]');
axis([1564.8 1567.5 -50 20]);
l = legend ('0.430 ','0.680','1.0','4.01','14.0');
title(l,'Brillouin Pump [mW]');
text(1564.9,15,'Pump = 220 mW');
text(1564.9,12,'Central Wavelength = 1565.8 nm');

