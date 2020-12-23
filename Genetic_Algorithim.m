%% Função de ganho variável%%
tic
clear all
close all
clc
format shortg
clock

%% Variable definition %%

Pin                                         = 280e-3;
popsize                                     = 40;
mutrate                                     = 0.01;
pop                                         = zeros(popsize, 4);
new_pop                                     = zeros(popsize,4);
generation                                  = 0;
Diff                                        = [1:popsize/2];
Vec_Prop                                    = [1:popsize/2];
Vec_Sel                                     = [];
storage_power                               = [];

%% Initial pop generation %%

for i=1:popsize
    pop(i,:)                                = [rand()+12.5 rand()+0.5 (1e-6)*rand()+0.1e-6 rand()+3.5];
end

%% Testing the population %%

while 1

    for i=1:popsize/2
        [Lambda, Power, Lamb_plot]         = cascateado_saturado(pop(i,:),0);
        Power_diff                         = abs((Lamb_plot) - (Power));
        Diff(i)                            = sum(Power_diff);
        storage_pop                        = [storage_pop;pop];
    end

%% Crossover %%
    Vec_Prop(:)                            = 1 - Diff(:)/sum(Diff);
    
    for i=1:popsize/2
        Vec_Sel                            = [Vec_Sel ones(1,round(Vec_Prop(i)*1000))*i];
    end
    for i=1:popsize/2
        Cross                              = [Vec_Sel(round(rand()*(length(Vec_Sel)))) round(rand()*(popsize/2-1)+popsize/2+1)];
        chance = rand();
        if chance<=0.25
            new_pop(i,:)                   = [pop(Cross(1),1) pop(Cross(1),2) pop(Cross(2),3) pop(Cross(2),4)];
            new_pop(i+popsize/2,:)         = [pop(Cross(2),1) pop(Cross(2),2) pop(Cross(1),3) pop(Cross(1),4)];
        elseif chance>0.25 && chance<=0.5
            new_pop(i,:)                   = [pop(Cross(1),1) pop(Cross(2),2) pop(Cross(1),3) pop(Cross(2),4)];
            new_pop(i+popsize/2,:)         = [pop(Cross(2),1) pop(Cross(1),2) pop(Cross(2),3) pop(Cross(1),4)];            
        elseif chance>0.5 && chance<=0.75
            new_pop(i,:)                   = [pop(Cross(1),1) pop(Cross(2),2) pop(Cross(2),3) pop(Cross(1),4)];
            new_pop(i+popsize/2,:)         = [pop(Cross(2),1) pop(Cross(1),2) pop(Cross(1),3) pop(Cross(2),4)];
        else
            new_pop(i,:)                   = [pop(Cross(1),1) pop(Cross(1),2) pop(Cross(2),3) pop(Cross(2),4)];
            new_pop(i+popsize/2,:)         = [pop(Cross(2),1) pop(Cross(2),2) pop(Cross(1),3) pop(Cross(1),4)];
        end
    end
    for i=1:popsize
        for j=1:length(pop(1))
            if rand()<mutrate
                if j==1
                    new_pop(i,j)           = 10*rand()+5;
                elseif j==2
                    new_pop(i,j)           = rand()+0.5;
                elseif j==3
                    new_pop(i,j)           = (1e-5)*rand()+1e-4;
                else
                    new_pop(i,j)           = 3*rand()+4;
                end
            end
        end
    end
    
    if min(Diff)<0.3 || generation>20
        min(Diff)
        plot(Lambda,Power,Lambda,Lamb_plot,'r');
        toc
        break
    end
    
    format shortg
    clock
    Vec_Sel                                = [];
    pop                                    = new_pop;
    generation                             = generation+1;
    disp(min(Diff));
end