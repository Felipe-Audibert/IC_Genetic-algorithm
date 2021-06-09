%% Função de ganho variável%%
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
val                                         = 4;
ind                                         = [15 15 1000 1]

%% Initial pop generation %%

for i=1:popsize
    pop(i,:)                                = [ind(1)*rand()+ind(2) ind(3)*rand()+ind(4)];
end

%% Testing the population %%

while 1

    for i=1:popsize
        [Lambda, Power, Lamb_plot]  = cascateado_dudu(pop(i,:),0);
        Diff(i)                        = sum(abs(abs(Lamb_plot(428:end).') - abs(Power(428:end))));
    end

    storage_pop(:,:,generation)            = pop;
    storage_Diff(:,generation)             = Diff';
    
%% Crossover %%
    Vec_Prop                            = (1./Diff).^val;
    
    for i=1:popsize
        Vec_Sel                            = [Vec_Sel ones(1,round(Vec_Prop(i)*1000))*i];
    end
    for i=1:popsize/2
        Cross                              = [Vec_Sel(ceil(rand()*length(Vec_Sel))) Vec_Sel(ceil(rand()*length(Vec_Sel)));];
        new_pop(i,:)                       = [pop(Cross(1),1) pop(Cross(2),2)];
        new_pop(i+popsize/2,:)             = [pop(Cross(2),1) pop(Cross(1),2)];
    end
    for i=1:popsize
        for j=1:length(pop(1))
            if rand()<mutrate
                if j==1
                    new_pop(i,j)             = ind(1)*rand()+ind(2);
                else
                    new_pop(i,j)             = ind(3)*rand()+ind(4);
                end
            end
        end
    end
    
    if min(Diff)<0.3 || generation>max_generation-1
        min(Diff)
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