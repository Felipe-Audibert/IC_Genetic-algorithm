clc;format short;format compact; 

%% Loads workspaces
load('Workspace_006.mat');
load('Workspace_037.mat');
load('Workspace_030.mat');
load('Workspace_014.mat');
load('Workspace_021.mat');

%% dBm

Power5= 10*log10((Power5)/1e-3);
Power37= 10*log10((Power37)/1e-3);
Power30= 10*log10((Power30)/1e-3);
Power14= 10*log10((Power14)/1e-3);
Power21= 10*log10((Power21)/1e-3);

%% plot

figure,plot(Lambda14,Power14,Lambda21,Power21,Lambda5,Power5,Lambda30,Power30,Lambda37,Power37);
hold off, grid off
title('Output Spectrum');
xlabel('Wavelength [nm]');
ylabel('Power [dBm]');
axis([1564.8 1567.5 -50 20]);
l = legend ('0.430 ','0.680','1.0','4.01','14.0');
title(l,'Brillouin Pump [mW]');
text(1564.9,15,'Pump = 250 mW');
text(1564.9,12,'Central Wavelength = 1565.8 nm');
