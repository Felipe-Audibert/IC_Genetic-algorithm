warning off all
close all
clear all
clc
disp(['             ---------------     Comecando otimizacao do Algoritmo genetico. HORARIO: ' datestr(datetime('now')), '     ---------------']);


for i = 15:5:35
genetic_alg_sensibilidade(i,50,0.04);

end

disp(['             ---------------    Fim otimizacao do Algoritmo genetico. HORARIO: ' datestr(datetime('now')), '     ---------------']);

