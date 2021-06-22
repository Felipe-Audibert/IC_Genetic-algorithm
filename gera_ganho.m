clear all
close all

EDFA = 170e-3;
Gmax = [16.8347,38.1839,33.2899];
Psat = [12.1662,30.7807,15.2253];
Legend = [0.43,0.68,1,4.01,14];

x = 1e-6:1e-2:1e-0;
xdBm = 10*log10(x*1e3);
G = zeros(1,length(x));
figure
% yaxis('Gain(dB)')
% xaxis('Power(dBm)')
title(strcat('EDFA = ', num2str(EDFA),'W'));
hold on
for i = 1:length(Gmax)
    for j = x
        G(find(x==j)) = ganho_sym_2020(j,Gmax(i),Psat(i));
    end
    GdB = 10*log10(G);
    plot(xdBm,GdB);
    L_plot(i) = convertCharsToStrings(strcat("Pin/EDFA = ",num2str(Legend(i)),"mW"));
end
legend(L_plot(:));