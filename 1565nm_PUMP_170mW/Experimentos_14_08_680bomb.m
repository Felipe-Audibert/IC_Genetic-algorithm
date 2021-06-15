clc;format short;format compact; 

%% Loads workspaces
load('Workspace_004.mat');
load('Workspace_034.mat');
load('Workspace_027.mat');
load('Workspace_011.mat');
load('Workspace_018.mat');


%% dBm
Power3= 10*log10((Power3)/1e-3);
Power34= 10*log10((Power34)/1e-3);
Power27= 10*log10((Power27)/1e-3);
Power11= 10*log10((Power11)/1e-3);
Power18= 10*log10((Power18)/1e-3);

%% Plot

figure,plot(Lambda11,Power11,Lambda18,Power18,Lambda3,Power3,Lambda27,Power27,Lambda34,Power34);
hold off, grid off
title('Output Spectrum');
xlabel('Wavelength [nm]');
ylabel('Power [dBm]');
axis([1564.8 1567.5 -50 20]);
l = legend ('0.430 ','0.680','1.0','4.01','14.0');
title(l,'Brillouin Pump [mW]');
text(1564.9,15,'Pump = 170 mW');
text(1564.9,12,'Central Wavelength = 1565.8 nm');
