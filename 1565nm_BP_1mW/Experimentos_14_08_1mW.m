clc;format short;format compact; 

%% Loads workspaces
load('Workspace_001.mat');
load('Workspace_002.mat');
load('Workspace_003.mat');
load('Workspace_004.mat');
load('Workspace_005.mat');
load('Workspace_006.mat');
load('Workspace_007.mat');

%% dBm 
Power= 10*log10((Power)/1e-3);
Power1= 10*log10((Power1)/1e-3);
Power2= 10*log10((Power2)/1e-3);
Power3= 10*log10((Power3)/1e-3);
Power4= 10*log10((Power4)/1e-3);
Power5= 10*log10((Power5)/1e-3);
Power6= 10*log10((Power6)/1e-3);

%% Plots spectrums

figure,plot(Lambda,Power);
hold off, grid off
title('Output Spectrum');
xlabel('Wavelength [nm]');
ylabel('Power [dBm]');
axis([1564.5 1567.5 -40 20]);
text(1564.55,18,'Pump = 120 mW');
text(1564.55,15,'Brillouin Pump = 1 mW');
text(1564.55,12,'Central Wavelength = 1565.8 nm');

figure,plot(Lambda1,Power1); 
hold off, grid off
title('Output Spectrum');
xlabel('Wavelength [nm]');
ylabel('Power [dBm]');
axis([1564.5 1567.5 -40 20]);
text(1564.55,18,'Pump = 150 mW');
text(1564.55,15,'Brillouin Pump = 1 mW');
text(1564.55,12,'Central Wavelength = 1565.8 nm');

figure,plot(Lambda2,Power2);
hold off, grid off
title('Output Spectrum');
xlabel('Wavelength [nm]');
ylabel('Power [dBm]');
axis([1564.5 1567.5 -40 20]);
text(1564.55,18,'Pump = 200 mW');
text(1564.55,15,'Brillouin Pump = 1 mW');
text(1564.55,12,'Central Wavelength = 1565.8 nm');

figure,plot(Lambda3,Power3);
hold off, grid off
title('Output Spectrum');
xlabel('Wavelength [nm]');
ylabel('Power [dBm]');
axis([1564.5 1567.5 -40 20]);
text(1564.55,18,'Pump = 170 mW');
text(1564.55,15,'Brillouin Pump = 1 mW');
text(1564.55,12,'Central Wavelength = 1565.8 nm');

figure,plot(Lambda4,Power4); 
hold off, grid off
title('Output Spectrum');
xlabel('Wavelength [nm]');
ylabel('Power [dBm]');
axis([1564.5 1567.5 -40 20]);
text(1564.55,18,'Pump = 220 mW');
text(1564.55,15,'Brillouin Pump = 1 mW');
text(1564.55,12,'Central Wavelength = 1565.8 nm');

figure,plot(Lambda5,Power5); 
hold off, grid off
title('Output Spectrum');
xlabel('Wavelength [nm]');
ylabel('Power [dBm]');
axis([1564.5 1567.5 -40 20]);
text(1564.55,18,'Pump = 250 mW');
text(1564.55,15,'Brillouin Pump = 1 mW');
text(1564.55,12,'Central Wavelength = 1565.8 nm');

figure,plot(Lambda6,Power6); 
hold off, grid off
title('Output Spectrum');
xlabel('Wavelength [nm]');
ylabel('Power [dBm]');
axis([1564.5 1568 -40 20]);
text(1564.55,18,'Pump = 280 mW');
text(1564.55,15,'Brillouin Pump = 1 mW');
text(1564.55,12,'Central Wavelength = 1565.8 nm');

figure,plot(Lambda,Power,Lambda1,Power1,Lambda3,Power3,Lambda2,Power2,Lambda4,Power4,Lambda5,Power5,Lambda6,Power6);
hold off, grid off
title('Output Spectrum');
xlabel('Wavelength [nm]');
ylabel('Power [dBm]');
axis([1564.5 1568 -40 20]);
l = legend ('120','150','170','200','220','250','280');
title(l,'Pump [mW]');
text(1564.55,15,'Brillouin Pump = 1 mW');
text(1564.55,12,'Central Wavelength = 1565.8 nm');

