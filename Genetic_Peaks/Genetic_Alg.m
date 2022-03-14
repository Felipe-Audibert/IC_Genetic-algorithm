%% Função de ganho variável%%
warning off all
close all
clc
disp(['             ---------------     Começo do Algorítmo genético. HORÁRIO: ' datestr(datetime('now')), '     ---------------']);

%% Variables definition %%
Max_Generation                              = 15;
EDFA                                        = 120e-3;
Vec_Pin                                     = [0.43 0.68 1 4.01 14]*1e-3;
Popsize                                     = 50;
Mut_Rate                                    = 0.05;
Peaks                                        = zeros(1,Popsize);
Vec_Sel                                     = [];
Ctrl                                        = 1;
Lim                                         = [10 30 0.2 2 0.15 0.25 0.15 0.25];
Storage_Pop                                 = zeros(Popsize,length(Lim)/2,Max_Generation,length(Vec_Pin));
Storage_Diff                                = zeros(length(Peaks),Max_Generation,length(Vec_Pin));
Filepath                                    = strcat('Data/EDFA_',num2str(EDFA*1e3),'mW/Simulation_1');

for Pin=Vec_Pin
    Generation                                  = 1;
    Pin_Pos                                     = find(Vec_Pin==Pin);
    
%% Initial Pop Generation %%
    Pop                                         = pop_gen(Popsize, Lim);
    
    while 1  

%% Testing the Population %%
        [Vec_Prop, Peaks] = fitness(EDFA, Pin, Pop, Popsize, Ctrl);
        
        Storage_Pop(:,:,Generation,Pin_Pos)  = Pop;
        Storage_Diff(:,Generation,Pin_Pos)   = Peaks;
        end

%% Crossover %%
        New_Pop             = crossover(Lim, Pop, Popsize, Mut_Rate, Vec_Prop);
        
        print = sprintf('End of Generation %.2d Mean_Diff =  %.2f   Min_Diff= %.2f', Generation, mean(Peaks), min(Peaks));
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

Individual = zeros(length(Vec_Pin),length(Pop(1,:)));
for i=1:length(Vec_Pin)
    [lin, col] = find(Storage_Diff(:,:,i)==min(min(Storage_Diff(:,:,i))));
    Individual(i,:) = Storage_Pop(lin(1),:,col(2),i)
end
    
%% EDFA = 220mW 
% Pin = 0,43mW %
% 14.4762, 1.1661
%15.2761, 1.3089;
% 10.0272, 0.2040
% 15.6578, 1.9774
% 15.1974   1.6889    0.2329    0.1850;

% Pin = 0,68mW %
% 13.7836, 1.3924
% 14.6948    1.8295    0.2282    0.2058

% Pin = 1mW %
% 15.1963    1.9272    0.2203    0.2475