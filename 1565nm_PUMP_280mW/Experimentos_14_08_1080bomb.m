clc;format short;format compact; 

%% Loads workspaces
load('Workspace_007.mat');
load('Workspace_038.mat');
load('Workspace_031.mat');
load('Workspace_015.mat');
load('Workspace_022.mat');

%% dBm
Power6= 10*log10((Power6)/1e-3);
Power38= 10*log10((Power38)/1e-3);
Power31= 10*log10((Power31)/1e-3);
Power15= 10*log10((Power15)/1e-3);
Power22= 10*log10((Power22)/1e-3);

%% plot

figure,plot(Lambda15,Power15,Lambda22,Power22,Lambda6,Power6,Lambda31,Power31,Lambda38,Power38);
hold off, grid off
title('Output Spectrum');
xlabel('Wavelength [nm]');
ylabel('Power [dBm]');
axis([1564.8 1567.5 -50 20]);
l = legend ('0.430 ','0.680','1.0','4.01','14.0');
title(l,'Brillouin Pump [mW]');
text(1564.9,15,'Pump = 280 mW');
text(1564.9,12,'Central Wavelength = 1565.8 nm');
