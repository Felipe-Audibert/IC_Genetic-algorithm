%% Fun��o de ganho vari�vel%%
warning off all
tic
clear all
close all
clc
format shortg
clock

%% Variable definition %%

max_generation                              = 20;
EDFA                                        = 280e-3;
Pin                                         = 0.43e-3;
popsize                                     = 20;
mutrate                                     = 0.02;
pop                                         = zeros(popsize, 2);
new_pop                                     = zeros(popsize,2);
generation                                  = 1;
Diff                                        = zeros(1,popsize);
Vec_Prop                                    = 1:popsize;
Vec_Sel                                     = [];
storage_pop                                 = zeros(popsize,2,max_generation);
storage_Diff                                = zeros(length(Diff),max_generation);
ctrl                                        = 1;
lim                                         = [13 30 1 1000]; %Limits of individuals generation

%% Initial pop generation %%

for i=1:popsize
    pop(i,:)                                = [lim(1)+rand()*(lim(2)-lim(1)) lim(3)+rand()*(lim(4)-lim(3))];
end

%% Testing the population %%

while 1

    for i=1:popsize
        [Lambda, Power, Lamb_plot]  = cascateado_dudu(EDFA, Pin, pop(i,1), pop(i,2), 0);
        Diff(i)                        = sum(abs(abs(Lamb_plot(426:end).') - abs(Power(426:end))));
    end

    storage_pop(:,:,generation)            = pop;
    storage_Diff(:,generation)             = Diff';
    
%% Crossover %%
    Vec_Prop                            = (1./Diff).^ctrl;
    
    for i=1:popsize
        Vec_Sel                            = [Vec_Sel ones(1,round(Vec_Prop(i)*1000))*i];
    end
    for i=1:popsize/2
        Cross                              = [Vec_Sel(ceil(rand()*length(Vec_Sel))) Vec_Sel(ceil(rand()*length(Vec_Sel)))];
        new_pop(i,:)                       = [pop(Cross(1),1) pop(Cross(2),2)];
        new_pop(i+popsize/2,:)             = [pop(Cross(2),1) pop(Cross(1),2)];
    end
    for i=1:popsize
        for j=1:length(pop(1))
            if rand()<mutrate
                if j==1
                    new_pop(i,j)             = lim(1)+rand()*(lim(2)-lim(1));
                else
                    new_pop(i,j)             = lim(3)+rand()*(lim(4)-lim(3));
                end
            end
        end
    end
    
    if min(Diff)<0.3 || generation>=max_generation
        [line column]                       = find(min(min(storage_Diff)));
        best_individual                     = storage_pop(line,:,column)
        best_individual_Diff                = min(storage_Diff)
        toc
        break
    end
    
    format shortg
    clock
    Vec_Sel                                = [];
    pop                                    = new_pop;
    generation                             = generation+1;
    disp(mean(Diff));
end