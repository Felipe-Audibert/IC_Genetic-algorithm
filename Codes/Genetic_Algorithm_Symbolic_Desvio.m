%% Fun��o de ganho vari�vel%%
warning off all
clear all
close all
clc
disp(['             ---------------     Come�o do Algor�tmo gen�tico. HOR�RIO: ' datestr(datetime('now')), '     ---------------']);

%% Variable definition %%

EDFA                                        = 250e-3;
Vec_Pin                                     = [0.43 0.68 1 4.01 14]*1e-3;
Lim                                         = [11 20 0.9e-3 1.1e-3]; %Limits of individuals Generation

Max_Generation                              = 20;
Popsize                                     = 20;

Ctrl                                        = 1; %Control of the valorization of the best individual
Mut_Rate                                    = 0.02;
Mut_Variation                               = 0.2;

Ctrl_Std                                    = 2.5;
Mut_Rate_Std                                = 0.15;
Mut_Variation_Std                           = 0.1;

Pop                                         = zeros(Popsize, 2);
New_Pop                                     = zeros(Popsize,2);
Diff                                        = zeros(1,Popsize);
Vec_Prop                                    = 1:Popsize;
Vec_Sel                                     = [];
Storage_Pop                                 = zeros(Popsize,2,Max_Generation,length(Vec_Pin));
Storage_Diff                                = zeros(length(Diff),Max_Generation,length(Vec_Pin));
Mean                                        = zeros(1,Max_Generation);
Std                                         = zeros(1,Max_Generation);
Save_Variables                              = [Ctrl Mut_Rate Mut_Variation];
filepath                                    = strcat('Data/EDFA_',num2str(EDFA*1e3),'mW/Simulation_1');

%% Initial Pop Generation %%
for Pin=Vec_Pin
    Generation                                  = 1;
    for i=1:Popsize
        Pop(i,:)                                = [Lim(1)+rand()*(Lim(2)-Lim(1)) Lim(3)+rand()*(Lim(4)-Lim(3))];
    end
%     while not(isempty(find(Pop==[20.6795669933805,8.81247327576556]))) %O c�digo n�o funciona para estes valores
%         Pop(i,:)                                = [Lim(1)+rand()*(Lim(2)-Lim(1)) Lim(3)+rand()*(Lim(4)-Lim(3))];
%     end
    %% Testing the Population %%
    
    while 1
        
        for i=1:Popsize
            [Lambda, Power, Lamb_plot]          = cascateado_dudu(EDFA, Pin, Pop(i,1), Pop(i,2), 0, 0);
            Diff(i)                             = sum(abs(abs(Lamb_plot.') - abs(Power)));
            Mean(Generation)                    = mean(Diff);
            Std(Generation)                     = std(Diff);
        end
        
        Storage_Pop(:,:,Generation,find(Vec_Pin==Pin))            = Pop;
        Storage_Diff(:,Generation,find(Vec_Pin==Pin))             = Diff';
        
        %% Crossover %%
        if Generation>=2
           if  abs((Mean(Generation)-Mean(Generation-1)))<2 && abs((Std(Generation)-Std(Generation-1)))<0.001
               Ctrl                             = Ctrl_Std;
               Mut_Variation                    = Mut_Variation_Std;
               Mut_Rate                         = Mut_Rate_Std;
           else
               Ctrl=Save_Variables(1); Mut_Rate=Save_Variables(2); Mut_Variation=Save_Variables(3);
           end
        end
        
        Vec_Prop                            = (1./Diff).^Ctrl;
        
        for i=1:Popsize
            Vec_Sel                            = [Vec_Sel ones(1,round(Vec_Prop(i)*10000000))*i];
        end
        for i=1:Popsize/2
            Cross                              = [Vec_Sel(ceil(rand()*length(Vec_Sel))) Vec_Sel(ceil(rand()*length(Vec_Sel)))];
            New_Pop(i,:)                       = [Pop(Cross(1),1) Pop(Cross(2),2)];
            New_Pop(i+Popsize/2,:)             = [Pop(Cross(2),1) Pop(Cross(1),2)];
        end
        for i=1:Popsize
            for j=1:length(Pop(1))
                if rand()<Mut_Rate
                    if rand()<0.5
                        New_Pop(i,j)             = New_Pop(i,j)*(1+Mut_Variation*rand());
                    else
                        New_Pop(i,j)             = New_Pop(i,j)*(1-Mut_Variation*rand());
                    end
                end
            end
        end
        if Generation<=9
            disp(['End of Generation 0' ,num2str(Generation), '. Mean_Diff =  ',num2str(mean(Diff))]);
        else
            disp(['End of Generation ' ,num2str(Generation), '. Mean_Diff =  ',num2str(mean(Diff))]);
        end    
        if min(Diff)<0.3 || Generation>=Max_Generation
            disp(['             ---------------     END OF TESTS FOR Pin=  ',num2str(Pin*1e3),'mW. HOR�RIO: ',datestr(datetime('now')), '     ---------------']);
            break
        end
        Generation                             = Generation+1;
        Vec_Sel                                = [];
        Pop                                    = New_Pop;
    end
end
save(filepath,'Storage_Pop','Storage_Diff');