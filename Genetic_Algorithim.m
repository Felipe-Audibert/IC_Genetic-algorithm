%% Função de ganho variável%%
tic
clear all
close all
clc
load 'Workspace_015.mat'

%% Variable definition %%

Power15                                     = 10.^(real(Power15)/10);
Pin                                         = 280e-3;
popsize                                     = 40;
mutrate                                     = 0.01;
pop                                         = zeros(popsize, 4);
new_pop                                     = zeros(popsize,4);
generation                                  = 0;
Diff                                        = [1:popsize];
Vec_Prop                                    = [1:popsize];
Vec_Sel                                     = [];

%% Initial pop generation %%

for i=1:popsize
    pop(i,:)                                = [10*rand()+5 3.75*rand()+0.25 (1e-5)*rand()+1e-4 3*rand()+4];
end

%% Testing the population %%

while 1

    for i=1:popsize/2
        [Lambda, Power, Lamb_plot]         = cascateado(Pin, pop(i,:));
        Test_Power15                       = [Lamb_plot(420) Lamb_plot(430) Lamb_plot(440) Lamb_plot(450) Lamb_plot(460) Lamb_plot(470) Lamb_plot(480) Lamb_plot(490) Lamb_plot(500) Lamb_plot(510)];
        Test_Power                         = [Power(420) Power(430) Power(440) Power(450) Power(460) Power(470) Power(480) Power(490) Power(500) Power(510)];
        Power_diff(:)                      = abs((Test_Power(:)) - (Test_Power15(:)));
        Diff(i)                            = sum(Power_diff);
    end

%% Crossover %%
    Vec_Prop(:)                            = 1 - Diff(:)/sum(Diff);
    
    for i=1:popsize/2
        Vec_Sel                            = [Vec_Sel ones(1,round(Vec_Prop(i)*1000))*i];
    end
    for i=1:popsize/2
        Cross = [0 0];
        c = 0;
        while Cross(1)==Cross(2) && c<=7
            Cross                          = [Vec_Sel(round(rand()*(length(Vec_Sel)/2-1)+1)) round(rand()*(popsize/2-1)+popsize/2+1)];
            c = c+1;
        end
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
                    new_pop(i,j)           = 3.75*rand()+0.25;
                elseif j==3
                    new_pop                = (1e-5)*rand()+1e-4;
                else
                    new_pop                = 3*rand()+4;
                end
            end
        end
    end
    
    if sum(Diff)<0.5 || generation>20
        disp(min(Diff))
        disp(pop(min(Diff)));
        plot(Lambda,Power,'r',Lambda,Lamb_plot);
        toc
        break
    end
    
    Vec_Sel                                = [];
    pop                                    = new_pop;
    generation                             = generation+1;
    disp(sum(Diff));
end