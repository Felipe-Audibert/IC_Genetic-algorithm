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
Diff                                        = 1:popsize/2;
Vec_Prop                                    = 1:popsize/2;
Vec_Sel                                     = [];
storage_pop                                 = zeros(popsize,2,max_generation);
storage_Diff                                = zeros(length(Diff),max_generation);

%% Initial pop generation %%

for i=1:popsize
    pop(i,:)                                = [15*rand()+15 1000*rand()+1];
end

%% Testing the population %%

while 1

    for i=1:popsize/2
        [Lambda, Power, Lamb_plot]  = cascateado_dudu(pop(i,:),0);
%         if length(findpeaks(real(Lamb_plot(400:800)'),'MinPeakDistance',20)) == 18
%             Diff(i)                 = sum(abs(findpeaks(real(Power(400:800)),'MinPeakDistance',20)-findpeaks(real(Lamb_plot(400:800)'),'MinPeakDistance',20)));
%         else
%             Diff(i)                 = sum(abs(findpeaks(real(Power(400:690)),'MinPeakDistance',20)-findpeaks(real(Lamb_plot(400:690)'),'MinPeakDistance',20)));
        Power_diff                   = abs((Power) - (Lamb_plot'));
        Diff(i)                      = sum(Power_diff)
    end

    storage_pop(:,:,generation)            = pop;
    storage_Diff(:,generation)             = Diff';
    
%% Crossover %%
    Vec_Prop(:)                            = 1 - Diff(:)/sum(Diff);
    
    for i=1:popsize/2
        Vec_Sel                            = [Vec_Sel ones(1,round(Vec_Prop(i)*1000))*i];
    end
    for i=1:popsize/2
        Cross                              = [Vec_Sel(round(rand()*(length(Vec_Sel)))) round(rand()*(popsize/2-1)+popsize/2+1)];
        chance = rand();
        if chance<=0.5
            new_pop(i,:)                     = [pop(Cross(1),1) pop(Cross(2),2)];
            new_pop(i+popsize/2,:)           = [pop(Cross(2),1) pop(Cross(1),2)];
        else
            new_pop(i,:)                     = [pop(Cross(1),1) pop(Cross(1),2)];
            new_pop(i+popsize/2,:)           = [pop(Cross(2),1) pop(Cross(2),2)];
        end
    end
    for i=1:popsize
        for j=1:length(pop(1))
            if rand()<mutrate
                if j==1
                    new_pop(i,j)             = 15*rand()+15;
                else
                    new_pop(i,j)             = 1000*rand()+1;
                end
            end
        end
    end
    
    if min(Diff)<0.3 || generation>max_generation-1
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