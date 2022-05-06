% Esse código é responsável 
%
%
close all 
clear all

load('Simulation_1_broad_space.mat')

    for gen = 1:15
       fig(gen) = figure('visible',1);
        scatter3(Storage_Pop(:,1,gen),Storage_Pop(:,2,gen),Storage_Diff(:,gen),40,Storage_Diff(:,gen),'filled')
        xlabel('acoplador_1')
        ylabel('acoplador_2')
        zlabel('Nº de picos')
        xlim([0.45,0.95])
        ylim([0.45,0.95])
        zlim([5,35])
    end
        
        
        figure('visible',1)
        plot(max(Storage_Diff(:,:)))
        xlabel('Geração')
        ylabel('melhor individuo')
        
        
        figure('visible',1)
        plot(mean(Storage_Diff(:,:)))
        xlabel('Geração')
        ylabel('média individuo')
        
        
    for i = 1:15
       saveas(fig(i),strcat('Geração', num2str(i),'.png'));
    end
        
        
        
        
        
        
