% Esse c�digo � respons�vel 
%
%

load('Simulation_1.mat')
  

    for gen = 1:15
        figure('visible',1)
        scatter3(Storage_Pop(:,3,gen,1),Storage_Pop(:,4,gen,1),Storage_Diff(:,gen,1),40,Storage_Diff(:,gen,1),'filled')
        xlabel('acoplador_1')
        ylabel('acoplador_2')
        zlabel('N� de picos')
    end
        
        
        figure('visible',1)
        plot(max(Storage_Diff(:,:,3)))
        xlabel('Gera��o')
        ylabel('melhor individuo')
        
        
        figure('visible',1)
        plot(mean(Storage_Diff(:,:,3)))
        xlabel('Gera��o')
        ylabel('m�dia individuo')
        
        
        
        
        
        
        
