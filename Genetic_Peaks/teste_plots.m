% Esse c�digo � respons�vel 
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
        zlabel('N� de picos')
        xlim([0.45,0.95])
        ylim([0.45,0.95])
        zlim([5,35])
    end
        
        
        figure('visible',1)
        plot(max(Storage_Diff(:,:)))
        xlabel('Gera��o')
        ylabel('melhor individuo')
        
        
        figure('visible',1)
        plot(mean(Storage_Diff(:,:)))
        xlabel('Gera��o')
        ylabel('m�dia individuo')
        
        
    for i = 1:15
       saveas(fig(i),strcat('Gera��o', num2str(i),'.png'));
    end
        
        
        
        
        
        
