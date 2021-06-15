clc;format short;format compact; 

%% Loads workspaces
load('Workspace_002.mat');
load('Workspace_033.mat');
load('Workspace_026.mat');
load('Workspace_010.mat');
load('Workspace_017.mat');

%% dBm
Power1= 10*log10((Power1)/1e-3);
Power33= 10*log10((Power33)/1e-3);
Power26= 10*log10((Power26)/1e-3);
Power10= 10*log10((Power10)/1e-3);
Power17= 10*log10((Power17)/1e-3);

%% Plot

figure,plot(Lambda10,Power10,Lambda17,Power17,Lambda1,Power1,Lambda26,Power26,Lambda33,Power33);
hold off, grid off
title('Output Spectrum');
xlabel('Wavelength [nm]');
ylabel('Power [dBm]');
axis([1564.8 1567.5 -50 20]);
l = legend ('0.430 ','0.680','1.0','4.01','14.0');
title(l,'Brillouin Pump [mW]');
text(1564.9,15,'Pump = 150 mW');
text(1564.9,12,'Central Wavelength = 1565.8 nm');

