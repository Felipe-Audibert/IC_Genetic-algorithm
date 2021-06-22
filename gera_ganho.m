function[] = gera_ganho(EDFA,Gmax,Psat,Legend)
close all

x = 1e-7:1e-4:1e-3;
xdBm = 10*log10(x*1e3);
figure
yaxis('Gain(dB)')
xaxis('Power(dBm)')
title(strcat('EDFA = ', num2str(EDFA)));
hold on
for i = length(Gmax)
    for j = x
        G(j) = ganho_sym_2020(j,Gmax(i),Psat(i));
    end
    GdB(i) = 10*log10(G);
    plot(xdBm,GdB);
    L_plot(i) = strcat('Pin/EDFA = ',num2str(Lenged(i)),'mW');
end
legend(L_plot(:));
end