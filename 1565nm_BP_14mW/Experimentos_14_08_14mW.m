clc;format short;format compact; 

%% Loads workspaces
load('Workspace_032.mat');
load('Workspace_033.mat');
load('Workspace_034.mat');
load('Workspace_035.mat');
load('Workspace_036.mat');
load('Workspace_037.mat');
load('Workspace_038.mat');
load('Workspace_039.mat');

%% dBm 
Power32= 10*log10((Power32)/1e-3);
Power33= 10*log10((Power33)/1e-3);
Power34= 10*log10((Power34)/1e-3);
Power35= 10*log10((Power35)/1e-3);
Power36= 10*log10((Power36)/1e-3);
Power37= 10*log10((Power37)/1e-3);
Power38= 10*log10((Power38)/1e-3);
Power39= 10*log10((Power39)/1e-3);

%% Plots spectrums

figure,plot(Lambda32,Power32);
hold off, grid off
title('Output Spectrum');
xlabel('Wavelength [nm]');
ylabel('Power [dBm]');
axis([1565.2 1566.8 -45 20]);
text(1566.05,18,'Pump = 120 mW');
text(1566.05,15,'Brillouin Pump = 14 mW');
text(1566.05,12,'Central Wavelength = 1565.8 nm');

figure,plot(Lambda33,Power33); 
hold off, grid off
title('Output Spectrum');
xlabel('Wavelength [nm]');
ylabel('Power [dBm]');
axis([1565.2 1567 -45 20]);
text(1566.05,18,'Pump = 150 mW');
text(1566.05,15,'Brillouin Pump = 14 mW');
text(1566.05,12,'Central Wavelength = 1565.8 nm');

figure, plot(Lambda34,Power34);
hold off, grid off
title('Output Spectrum');
xlabel('Wavelength [nm]');
ylabel('Power [dBm]');
axis([1565.2 1567 -45 20]);
text(1566.05,18,'Pump = 170 mW');
text(1566.05,15,'Brillouin Pump = 14 mW');
text(1566.05,12,'Central Wavelength = 1565.8 nm');

figure,plot(Lambda35,Power35);
hold off, grid off
title('Output Spectrum');
xlabel('Wavelength [nm]');
ylabel('Power [dBm]');
axis([1565.2 1567 -45 20]);
text(1566.05,18,'Pump = 200 mW');
text(1566.05,15,'Brillouin Pump = 14 mW');
text(1566.05,12,'Central Wavelength = 1565.8 nm');

figure, plot(Lambda36,Power36); 
hold off, grid off
title('Output Spectrum');
xlabel('Wavelength [nm]');
ylabel('Power [dBm]');
axis([1565.2 1567 -45 20]);
text(1566.05,18,'Pump = 220 mW');
text(1566.05,15,'Brillouin Pump = 14 mW');
text(1566.05,12,'Central Wavelength = 1565.8 nm');

figure,plot(Lambda37,Power37); 
hold off, grid off
title('Output Spectrum');
xlabel('Wavelength [nm]');
ylabel('Power [dBm]');
axis([1565.2 1567 -45 20]);
text(1566.05,18,'Pump = 250 mW');
text(1566.05,15,'Brillouin Pump = 14 mW');
text(1566.05,12,'Central Wavelength = 1565.8 nm');

figure,plot(Lambda38,Power38); 
hold off, grid off
title('Output Spectrum');
xlabel('Wavelength [nm]');
ylabel('Power [dBm]');
axis([1565 1567.6 -45 20]);
text(1566.05,18,'Pump = 280 mW');
text(1566.05,15,'Brillouin Pump = 14 mW');
text(1566.05,12,'Central Wavelength = 1565.8 nm');
 
figure, plot(Lambda39,Power39); 
hold off, grid off
title('Output Spectrum');
xlabel('Wavelength [nm]');
ylabel('Power [dBm]');
axis([1565.2 1566.6 -45 20]);
text(1566.05,18,'Pump = 90 mW');
text(1566.05,15,'Brillouin Pump = 14 mW');
text(1566.05,12,'Central Wavelength = 1565.8 nm');

figure,plot(Lambda39,Power39,Lambda32,Power32,Lambda33,Power33,Lambda34,Power34,Lambda35,Power35,Lambda36,Power36,Lambda37,Power38,Lambda38,Power38);
hold off, grid off
title('Output Spectrum');
xlabel('Wavelength [nm]');
ylabel('Power [dBm]');
axis([1564.5 1568 -45 20]);
l = legend ('90','120','150','170','200','220','250','280');
title(l,'Pump [mW]');
text(1564.55,15,'Brillouin Pump = 14 mW');
text(1564.55,12,'Central Wavelength = 1565.8 nm');
