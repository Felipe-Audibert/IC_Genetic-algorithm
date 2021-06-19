clc
clear all
close all

%% Dimensões da matriz
Lim_G = [8,17];
Lim_Ps = [1,400];
Qt_Pontos = [10,40];
%%

x = linspace(Lim_G(1),Lim_G(2),Qt_Pontos(1));
y = linspace(Lim_Ps(1),Lim_Ps(2),Qt_Pontos(2));
m = zeros(Qt_Pontos(1),Qt_Pontos(2),2);
map = zeros(Qt_Pontos(1),Qt_Pontos(2));
pop = zeros(1,2);
Diff = 0;

for i = 1:Qt_Pontos(1)
   for j = 1:Qt_Pontos(2)
       m(i,j,1) = x(i);
       m(i,j,2)= y(j);
   end
end

disp('primeira parte concluida')

for i = 1:Qt_Pontos(1)
   for j = 1:Qt_Pontos(2)
       pop = [m(i,j,1),m(i,j,2)];
        [Lambda, Power, Lamb_plot]  = cascateado_dudu(0.28,0.43e-3,pop(1),pop(2),0);
        Diff                     = sum(abs(abs(Lamb_plot(428:end).') - abs(Power(428:end))));
        map(i,j) = Diff;
        fprintf("individuo:" + i + "," + j+"\n")
   end
end

surf(map)