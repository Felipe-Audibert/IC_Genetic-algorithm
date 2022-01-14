%% Função de ganho variável%%
warning off all
close all
clc
disp(['             ---------------     Começo do Algorítmo genético. HORÁRIO: ' datestr(datetime('now')), '     ---------------']);

%% Variables definition %%
Max_Generation                              = 15;
EDFA                                        = 220e-3;
Vec_Pin                                     = [0.43]*1e-3;
Popsize                                     = 50;
Mut_Rate                                    = 0.05;
Diff                                        = zeros(1,Popsize);
Vec_Sel                                     = [];
Ctrl                                        = 1;
Lim                                         = [10 30 0.2 2 0.15 0.25 0.15 0.25];
Storage_Pop                                 = zeros(Popsize,length(Lim)/2,Max_Generation,length(Vec_Pin));
Storage_Diff                                = zeros(length(Diff),Max_Generation,length(Vec_Pin));
Filepath                                    = strcat('Data/EDFA_',num2str(EDFA*1e3),'mW/Simulation_1');

for Pin=Vec_Pin
    Generation                                  = 1;
    Pin_Pos                                     = find(Vec_Pin==Pin);
    
%% Initial Pop Generation %%
    Pop                                         = pop_gen(Popsize, Lim);
    
    while 1  

%% Testing the Population %%
        [Vec_Prop, Diff] = fitness(EDFA, Pin, Pop, Popsize, Ctrl);
        
        Storage_Pop(:,:,Generation,Pin_Pos)  = Pop;
        Storage_Diff(:,Generation,Pin_Pos)   = Diff;
        if(max(Diff)==min(Diff))
            disp("No genetic variation");
            disp(strcat("minDiff == " + num2str(min(Diff))));
            break
        end

%% Crossover %%
        New_Pop             = crossover(Lim, Pop, Popsize, Mut_Rate, Vec_Prop);
        
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
save(Filepath,'Storage_Pop','Storage_Diff');

[lin col] = find(Storage_Diff==min(min(Storage_Diff)));
Individual = Storage_Pop(lin, :, col, end);
cascateado(EDFA, Pin, Individual);

%% EDFA = 220mW 
% Pin = 0,43mW %
% 14.4762, 1.1661; 15.2761, 1.3089;
% 10.0272, 0.2040
% 15.6578, 1.9774

% 15.1974, 1.6889, 0.2329, 0.1850;


%Pin = 0,68mW
% 13.7836, 1.3924
