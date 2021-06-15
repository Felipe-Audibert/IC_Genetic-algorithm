clc;format short;format compact; 

%% Loads workspaces
load('Workspace_009.mat')
load('Workspace_010.mat')
load('Workspace_011.mat')
load('Workspace_012.mat')
load('Workspace_013.mat')
load('Workspace_014.mat')
load('Workspace_015.mat')

%% dBm 
Power9= 10*log10((Power9)/1e-3);
Power10= 10*log10((Power10)/1e-3);
Power11= 10*log10((Power11)/1e-3);
Power12= 10*log10((Power12)/1e-3);
Power13= 10*log10((Power13)/1e-3);
Power14= 10*log10((Power14)/1e-3);
Power15= 10*log10((Power15)/1e-3);

%% Plots spectrums

figure,plot(Lambda9,Power9);
hold off, grid off
title('Output Spectrum');
xlabel('Wavelength [nm]');
ylabel('Power [dBm]');
axis([1565.5 1567.2 -30 20]);
text(1565.55,18,'Pump = 120 mW');
text(1565.55,15,'Brillouin Pump = 0.430 mW');
text(1565.55,12,'Central Wavelength = 1565.8 nm');

figure, plot(Lambda10,Power10); 
hold off, grid off
title('Output Spectrum');
xlabel('Wavelength [nm]');
ylabel('Power [dBm]');
axis([1565.5 1567.2 -30 20]);
text(1565.55,18,'Pump = 150 mW');
text(1565.55,15,'Brillouin Pump = 0.430 mW');
text(1565.55,12,'Central Wavelength = 1565.8 nm');

figure, plot(Lambda11,Power11);
hold off, grid off
title('Output Spectrum');
xlabel('Wavelength [nm]');
ylabel('Power [dBm]');
axis([1565.5 1567.2 -30 20]);
text(1565.55,18,'Pump = 170 mW');
text(1565.55,15,'Brillouin Pump = 0.430 mW');
text(1565.55,12,'Central Wavelength = 1565.8 nm');

figure,plot(Lambda12,Power12);
hold off, grid off
title('Output Spectrum');
xlabel('Wavelength [nm]');
ylabel('Power [dBm]');
axis([1565.5 1567.2 -17 20]);
text(1565.55,18,'Pump = 200 mW');
text(1565.55,15,'Brillouin Pump = 0.430 mW');
text(1565.55,12,'Central Wavelength = 1565.8 nm');

figure, plot(Lambda13,Power13); 
hold off, grid off
title('Output Spectrum');
xlabel('Wavelength [nm]');
ylabel('Power [dBm]');
axis([1565.5 1567.2 -17 20]);
text(1565.55,18,'Pump = 220 mW');
text(1565.55,15,'Brillouin Pump = 0.430 mW');
text(1565.55,12,'Central Wavelength = 1565.8 nm');

figure, plot(Lambda14,Power14); 
hold off, grid off
title('Output Spectrum');
xlabel('Wavelength [nm]');
ylabel('Power [dBm]');
axis([1565.5 1567.2 -17 20]);
text(1565.55,18,'Pump = 250 mW');
text(1565.55,15,'Brillouin Pump = 0.430 mW');
text(1565.55,12,'Central Wavelength = 1565.8 nm');

figure, plot(Lambda15,Power15); 
hold off, grid off
title('Output Spectrum');
xlabel('Wavelength [nm]');
ylabel('Power [dBm]');
axis([1565.5 1567.2 -17 20]);
text(1565.55,18,'Pump = 280 mW');
text(1565.55,15,'Brillouin Pump = 0.430 mW');
text(1565.55,12,'Central Wavelength = 1565.8 nm');

figure,plot(Lambda9,Power9,Lambda10,Power10,Lambda11,Power11,Lambda12,Power12,Lambda13,Power13,Lambda14,Power14,Lambda15,Power15);
hold off, grid off
title('Output Spectrum');
xlabel('Wavelength [nm]');
ylabel('Power [dBm]');
axis([1565.5 1567.2 -30 20]);
l = legend ('120','150','170','200','220','250','280');
title(l,'Pump [mW]');
text(1565.55,15,'Brillouin Pump = 0.430 mW');
text(1565.55,12,'Central Wavelength = 1565.8 nm');
