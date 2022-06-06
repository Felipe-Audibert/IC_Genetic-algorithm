warning off all
close all
clear all
clc
disp(['             ---------------     Comecando otimizacao do Algoritmo genetico. HORARIO: ' datestr(datetime('now')), '     ---------------']);


for i = 16:10:66
genetic_alg_sensibilidade(20,i,0.04);

end

disp(['             ---------------    Fim otimizacao do Algoritmo genetico. HORARIO: ' datestr(datetime('now')), '     ---------------']);

