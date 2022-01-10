%% Função de ganho variável%%
warning off all
clear all
close all
clc
disp(['             ---------------     Começo do Algorítmo genético. HORÁRIO: ' datestr(datetime('now')), '     ---------------']);

%% Variable definition %%

Max_Generation                              = 15;
EDFA                                        = 220e-3;
Vec_Pin                                     = [0.43]*1e-3;
Popsize                                     = 50;
Mut_Rate                                    = 0.05;
Pop                                         = zeros(Popsize, 2);
New_Pop                                     = zeros(Popsize,2);
Diff                                        = zeros(1,Popsize);
Vec_Prop                                    = 1:Popsize;
Vec_Sel                                     = [];
Storage_Pop                                 = zeros(Popsize,2,Max_Generation,length(Vec_Pin));
Storage_Diff                                = zeros(length(Diff),Max_Generation,length(Vec_Pin));
Ctrl                                        = 1;
Lim                                         = [10 30 0.2 2 1.5 2.5 1.5 2.5];
filepath                                    = strcat('Data/EDFA_',num2str(EDFA*1e3),'mW/Simulation_1');

%% Initial Pop Generation %%
for Pin=Vec_Pin
    Generation                                  = 1;
    for i=1:Popsize
        Pop(i,:)                                = pop_gen(Lim);
    end
    %% Testing the Population %%
    
    while 1
        
        for i=1:Popsize
            [Lambda, Power, Lamb_plot]          = cascateado(EDFA, Pin, Pop(i,1), Pop(i,2), 0, 0);
            Diff(i)                             = sum(abs(Power - Lamb_plot.'));
        end
        
        Storage_Pop(:,:,Generation,find(Vec_Pin==Pin))            = Pop;
        Storage_Diff(:,Generation,find(Vec_Pin==Pin))             = Diff.';
        
        %% Crossover %%
        Vec_Prop                                = (1./Diff).^Ctrl;
        
        for i=1:Popsize
            Vec_Sel                             = [Vec_Sel ones(1,round(Vec_Prop(i)*1000))*i];
        end
        for i=1:Popsize/2
            Cross                               = [Vec_Sel(ceil(rand()*length(Vec_Sel))) Vec_Sel(ceil(rand()*length(Vec_Sel)))];
            if(max(Diff)==min(Diff))
                disp("No genetic variation");
                disp(strcat("minDiff == " + num2str(min(Diff))));
                break
            end
            while Cross(1)==Cross(2)
                Cross                           = [Vec_Sel(ceil(rand()*length(Vec_Sel))) Vec_Sel(ceil(rand()*length(Vec_Sel)))];
            end
            New_Pop(i,:)                        = [Pop(Cross(1),1) Pop(Cross(2),2)];
            New_Pop(i+Popsize/2,:)              = [Pop(Cross(2),1) Pop(Cross(1),2)];
        end
        for i=1:Popsize
            for j=1:length(Pop(1))
                if rand()<=Mut_Rate
                    if j==1
                        New_Pop(i,j)               = Lim(1)+rand()*(Lim(2)-Lim(1));
                    else
                        New_Pop(i,j)               = Lim(3)+rand()*(Lim(4)-Lim(3));
                    end
                end
            end
        end
        print = sprintf('End of Generation %.2d Mean_Diff =  %.2f   Min_Diff= %.2f', Generation, mean(Diff), min(Diff));
        disp(print); 
        if Generation>=Max_Generation
            disp(['             ---------------     END OF TESTS FOR Pin=  ',num2str(Pin*1e3),'mW. HORÁRIO: ',datestr(datetime('now')), '     ---------------']);
            break
        end
        Generation                             = Generation+1;
        Vec_Sel                                = [];
        Pop                                    = New_Pop;
    end
end
save(filepath,'Storage_Pop','Storage_Diff');

min(min(Storage_Diff))
[lin col] = find(min(min(Storage_Diff)));
cascateado(EDFA, Pin, Storage_Pop(lin, 1, col), Storage_Pop(lin, 2, col));