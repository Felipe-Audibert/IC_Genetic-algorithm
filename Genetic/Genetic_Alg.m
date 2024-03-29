%% Função de ganho variável%%
warning off all
close all
clc
disp(['             ---------------     Começo do Algorítmo genético. HORÁRIO: ' datestr(datetime('now')), '     ---------------']);

%% Variables definition %%
Max_Generation                              = 15;
Vec_EDFA                                    = [120 150 200 250 280]*1e-3;
Vec_Pin                                     = [0.43 0.68 1 4.01]*1e-3;
Popsize                                     = 50;
Mut_Rate                                    = 0.05;
Diff                                        = zeros(1,Popsize);
Vec_Sel                                     = [];
Ctrl                                        = 1;
Lim                                         = [8 20 0.1 5 5e-7 5e-4 1 10];
Storage_Pop                                 = zeros(Popsize,length(Lim)/2,Max_Generation);
Storage_Diff                                = zeros(length(Diff),Max_Generation);
FileName                                    = strcat('A=', num2str(Lim(1)), '-', num2str(Lim(2)), ', B=', num2str(Lim(3)), ...
                                                    '-', num2str(Lim(4)), ', C=', num2str(Lim(5)*1e6), 'e-6 -', num2str(Lim(6)*1e6), ...
                                                    'e-6, D=', num2str(Lim(7)), '-', num2str(Lim(8)));

for EDFA=Vec_EDFA
    mkdir(strcat('./Workspaces/', num2str(EDFA*1e3), 'mw')); 
    for Pin=Vec_Pin
        Generation                                  = 1;
        Storage_Pop                                 = zeros(Popsize,length(Lim)/2,Max_Generation);
        Storage_Diff                                = zeros(length(Diff),Max_Generation);
        
    %% Initial Pop Generation %%
        Pop                                         = pop_gen(Popsize, Lim);
        
        while 1  
    
    %% Testing the Population %%
            [Vec_Prop, Diff, Pop, erros, Vec_Erros] = fitness(EDFA, Pin, Pop, Popsize, Ctrl, Lim);
            
            Storage_Pop(:,:,Generation)  = Pop;
            Storage_Diff(:,Generation)   = Diff;
    
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
        save(strcat('./Workspaces/', num2str(EDFA*1e3), 'mw/', num2str(Pin*1e3), 'mW -- ', FileName),'Storage_Pop','Storage_Diff', 'Vec_Erros', 'EDFA', 'Pin');
    end
    disp(['             ---------------     END OF TESTS FOR EDFA=  ',num2str(EDFA*1e3),'mW. HORÁRIO: ',datestr(datetime('now')), '     ---------------']);
    clear Storage_Pop Storage_Diff Vec_Erros ;
end
    
%% EDFA = 220mW 
% Pin = 0,43mW %
% 14.4762, 1.1661
%15.2761, 1.3089;
% 10.0272, 0.2040
% 15.6578, 1.9774
% 15.1974   1.6889    0.2329    0.1850;
% 11.9291    0.4376    0.1505    0.1550

% Pin = 0,68mW %
% 13.7836, 1.3924
% 14.6948    1.8295    0.2282    0.2058
% 

% Pin = 1mW %
% 15.1963    1.9272    0.2203    0.2475