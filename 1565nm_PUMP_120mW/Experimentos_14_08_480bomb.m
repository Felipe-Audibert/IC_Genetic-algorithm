clc;format short;format compact; 

%% Loads workspaces
load('Workspace_001.mat');
load('Workspace_032.mat');
load('Workspace_025.mat');
load('Workspace_009.mat');
load('Workspace_016.mat');

%% dBm

Power= 10*log10((Power)/1e-3);
Power32= 10*log10((Power32)/1e-3);
Power25= 10*log10((Power25)/1e-3);
Power9= 10*log10((Power9)/1e-3);
Power16= 10*log10((Power16)/1e-3);

%% Plot

figure,plot(Lambda9,Power9,Lambda16,Power16,Lambda,Power,Lambda25,Power25,Lambda32,Power32);
hold off, grid off
title('Output Spectrum');
xlabel('Wavelength [nm]');
ylabel('Power [dBm]');
axis([1564.8 1567.5 -50 20]);
l = legend ('0.430 ','0.680','1.0','4.01','14.0');
title(l,'Brillouin Pump [mW]');
text(1564.9,15,'Pump = 120 mW');
text(1564.9,12,'Central Wavelength = 1565.8 nm');


