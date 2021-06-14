clc
clear all
close all

x = linspace(12,22,10);
y = linspace(1,40,40);
m = zeros(10,40,2);
map = zeros(10,40);
pop = zeros(1,2);
Diff = 0;

for i = 1:10
   for j = 1:40
       m(i,j,1) = x(i);
       m(i,j,2)= y(j);
   end
end

disp('primeira parte concluida')

for i = 1:10
   for j = 1:40
       pop = [m(i,j,1),m(i,j,2)];
        [Lambda, Power, Lamb_plot]  = cascateado_dudu(pop,0);
        Diff                     = sum(abs(abs(Lamb_plot(428:end).') - abs(Power(428:end))));
        map(i,j) = Diff;
        fprintf("individuo:" + i + "," + j+"\n")
   end
end

surf(map)