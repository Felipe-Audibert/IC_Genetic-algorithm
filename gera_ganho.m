
close all

EDFA = 120e-3;
Gmax = [19.6445,11.0916,11.0513,15.0763];
Psat = [5.3159,99.8428,96.1287,1.0968];
Legend = [0.43,0.68,1,4.01,14];

x = 1e-7:1e-4:1e-3;
xdBm = 10*log10(x*1e3);
G = zeros(1,length(x));
figure
% yaxis('Gain(dB)')
% xaxis('Power(dBm)')
title(strcat('EDFA = ', num2str(EDFA)));
hold on
for i = length(Gmax)
    for j = 1:x
        G(j) = ganho_sym_2020(j,Gmax(i),Psat(i));
    end
    GdB = 10*log10(G);
    plot(xdBm,GdB);
    L_plot(i,:) = strcat('Pin/EDFA = ',num2str(Legend(i)),'mW');
end
legend(L_plot(:));