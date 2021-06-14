clc;format short;format compact; 

%% Loads workspaces
load('Workspace_016.mat');
load('Workspace_017.mat');
load('Workspace_018.mat');
load('Workspace_019.mat');
load('Workspace_020.mat');
load('Workspace_021.mat');
load('Workspace_022.mat');

%% dBm 
Power16= 10*log10((Power16)/1e-3);
Power17= 10*log10((Power17)/1e-3);
Power18= 10*log10((Power18)/1e-3);
Power19= 10*log10((Power19)/1e-3);
Power20= 10*log10((Power20)/1e-3);
Power21= 10*log10((Power21)/1e-3);
Power22= 10*log10((Power22)/1e-3);

%% Plots spectrums

figure,plot(Lambda16,Power16);
hold off, grid off
title('Output Spectrum');
xlabel('Wavelength [nm]');
ylabel('Power [dBm]');
axis([1565.2 1567.6 -45 20]);
text(1565.25,18,'Pump = 120 mW');
text(1565.25,15,'Brillouin Pump = 0.680 mW');
text(1565.25,12,'Central Wavelength = 1565.8 nm');

figure,plot(Lambda17,Power17); 
hold off, grid off
title('Output Spectrum');
xlabel('Wavelength [nm]');
ylabel('Power [dBm]');
axis([1565.2 1567.6 -45 20]);
text(1565.25,18,'Pump = 150 mW');
text(1565.25,15,'Brillouin Pump = 0.680 mW');
text(1565.25,12,'Central Wavelength = 1565.8 nm');

figure, plot(Lambda18,Power18);
hold off, grid off
title('Output Spectrum');
xlabel('Wavelength [nm]');
ylabel('Power [dBm]');
axis([1565.2 1567.6 -45 20]);
text(1565.25,18,'Pump = 180 mW');
text(1565.25,15,'Brillouin Pump = 0.680 mW');
text(1565.25,12,'Central Wavelength = 1565.8 nm');

figure, plot(Lambda19,Power19);
hold off, grid off
title('Output Spectrum');
xlabel('Wavelength [nm]');
ylabel('Power [dBm]');
axis([1565.2 1567.6 -30 20]);
text(1565.25,18,'Pump = 200 mW');
text(1565.25,15,'Brillouin Pump = 0.680 mW');
text(1565.25,12,'Central Wavelength = 1565.8 nm');

figure,plot(Lambda20,Power20); 
hold off, grid off
title('Output Spectrum');
xlabel('Wavelength [nm]');
ylabel('Power [dBm]');
axis([1565.2 1567.6 -30 20]);
text(1565.25,18,'Pump = 220 mW');
text(1565.25,15,'Brillouin Pump = 0.680 mW');
text(1565.25,12,'Central Wavelength = 1565.8 nm');

figure, plot(Lambda21,Power21); 
hold off, grid off
title('Output Spectrum');
xlabel('Wavelength [nm]');
ylabel('Power [dBm]');
axis([1565.2 1567.6 -30 20]);
text(1565.25,18,'Pump = 250 mW');
text(1565.25,15,'Brillouin Pump = 0.680 mW');
text(1565.25,12,'Central Wavelength = 1565.8 nm');

figure, plot(Lambda22,Power22); 
hold off, grid off
title('Output Spectrum');
xlabel('Wavelength [nm]');
ylabel('Power [dBm]');
axis([1565.2 1567.6 -30 20]);
text(1565.25,18,'Pump = 280 mW');
text(1565.25,15,'Brillouin Pump = 0.680 mW');
text(1565.25,12,'Central Wavelength = 1565.8 nm');

figure,plot(Lambda16,Power16,Lambda17,Power17,Lambda18,Power18,Lambda19,Power19,Lambda20,Power20,Lambda21,Power21,Lambda22,Power22);
hold off, grid off
title('Output Spectrum');
xlabel('Wavelength [nm]');
ylabel('Power [dBm]');
axis([1565.2 1567.6 -45 20]);
l = legend ('120','150','170','200','220','250','280');
title(l,'Pump [mW]');
text(1565.25,15,'Brillouin Pump = 0.680 mW');
text(1565.25,12,'Central Wavelength = 1565.8 nm');


