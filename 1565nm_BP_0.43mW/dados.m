%Referente a potencia de bombeio de brillouin de 430 mW e lambda 1565 nm

Pbomb_edfa = [120 150 170 200 220 250 280];         % mW
Psaida_medida = [1.1215 1.4731 1.7373 1.9822 2.1612 2.3675 2.5985];         % mW
Ganho_edfa = [11.66 11.67 11.7 11.71 11.71 11.7 11.71];            % dB
Psaida_sim = [0.5841 0.5908 0.6298 0.6401 0.6401 0.6298 0.6401];            % mW
Pent_edfa = [1.245 1.12593 1.3425 1.3645 1.3645 1.3425 1.3645];             % mW

figure(1)
yyaxis left
plot(Pbomb_edfa,Ganho_edfa,'*-')
xlabel('Potencia de bombeio EDFA [mW]')
ylabel('Ganho do EDFA [dB]')
yyaxis right
plot(Pbomb_edfa,Pent_edfa,'o-')
ylabel('Potencia de entrada no EDFA')
grid on

figure(2)
plot(Pbomb_edfa,Psaida_medida,'*-',Pbomb_edfa,Psaida_sim,'-*')
xlabel('Potencia de bombeio EDFA [mW]')
ylabel('Potencia de saida [mW]')
legend('Medido','Simulado')
grid on
