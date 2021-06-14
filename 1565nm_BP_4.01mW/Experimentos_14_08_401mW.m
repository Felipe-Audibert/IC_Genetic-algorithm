clc;format short;format compact; 

%% Loads workspaces
load('Workspace_025.mat');
load('Workspace_026.mat');
load('Workspace_027.mat');
load('Workspace_028.mat');
load('Workspace_029.mat');
load('Workspace_030.mat');
load('Workspace_031.mat');

%% dBm 
Power25= 10*log10((Power25)/1e-3);
Power26= 10*log10((Power26)/1e-3);
Power27= 10*log10((Power27)/1e-3);
Power28= 10*log10((Power28)/1e-3);
Power29= 10*log10((Power29)/1e-3);
Power30= 10*log10((Power30)/1e-3);
Power31= 10*log10((Power31)/1e-3);

%% Plots spectrums

figure,plot(Lambda25,Power25);
hold off, grid off
title('Output Spectrum');
xlabel('Wavelength [nm]');
ylabel('Power [dBm]');
axis([1565.2 1567 -45 20]);
text(1566.05,18,'Pump = 120 mW');
text(1566.05,15,'Brillouin Pump = 4.01 mW');
text(1566.05,12,'Central Wavelength = 1565.8 nm');

figure,plot(Lambda26,Power26); 
hold off, grid off
title('Output Spectrum');
xlabel('Wavelength [nm]');
ylabel('Power [dBm]');
axis([1565.2 1567 -45 20]);
text(1566.05,18,'Pump = 150 mW');
text(1566.05,15,'Brillouin Pump = 4.01 mW');
text(1566.05,12,'Central Wavelength = 1565.8 nm');

figure, plot(Lambda27,Power27);
hold off, grid off
title('Output Spectrum');
xlabel('Wavelength [nm]');
ylabel('Power [dBm]');
axis([1565.2 1567.5 -45 20]);
text(1566.05,18,'Pump = 170 mW');
text(1566.05,15,'Brillouin Pump = 4.01 mW');
text(1566.05,12,'Central Wavelength = 1565.8 nm');

figure, plot(Lambda28,Power28);
hold off, grid off
title('Output Spectrum');
xlabel('Wavelength [nm]');
ylabel('Power [dBm]');
axis([1565.2 1567.5 -45 20]);
text(1566.05,18,'Pump = 200 mW');
text(1566.05,15,'Brillouin Pump = 4.01 mW');
text(1566.05,12,'Central Wavelength = 1565.8 nm');

figure, plot(Lambda29,Power29); 
hold off, grid off
title('Output Spectrum');
xlabel('Wavelength [nm]');
ylabel('Power [dBm]');
axis([1565.2 1567.5 -45 20]);
text(1566.05,18,'Pump = 220 mW');
text(1566.05,15,'Brillouin Pump = 4.01 mW');
text(1566.05,12,'Central Wavelength = 1565.8 nm');

figure, plot(Lambda30,Power30); 
hold off, grid off
title('Output Spectrum');
xlabel('Wavelength [nm]');
ylabel('Power [dBm]');
axis([1565.2 1567.5 -45 20]);
text(1566.05,18,'Pump = 250 mW');
text(1566.05,15,'Brillouin Pump = 4.01 mW');
text(1566.05,12,'Central Wavelength = 1565.8 nm');

figure,plot(Lambda31,Power31); 
hold off, grid off
title('Output Spectrum');
xlabel('Wavelength [nm]');
ylabel('Power [dBm]');
axis([1565.2 1567.5 -45 20]);
text(1566.05,18,'Pump = 280 mW');
text(1566.05,15,'Brillouin Pump = 4.01 mW');
text(1566.05,12,'Central Wavelength = 1565.8 nm');

figure,plot(Lambda25,Power25,Lambda26,Power26,Lambda27,Power27,Lambda28,Power28,Lambda29,Power29,Lambda30,Power30,Lambda31,Power31);
hold off, grid off
title('Output Spectrum');
xlabel('Wavelength [nm]');
ylabel('Power [dBm]');
axis([1564.8 1567.5 -45 20]);
l = legend ('120','150','170','200','220','250','280');
title(l,'Pump [mW]');
text(1564.9,15,'Brillouin Pump = 4.01 mW');
text(1564.9,12,'Central Wavelength = 1565.8 nm');
