%% Função de ganho variável%%
warning off all
close all
clc
disp(['             ---------------     Começo do Algorítmo genético. HORÁRIO: ' datestr(datetime('now')), '     ---------------']);

%% Variables definition %%
file_counter = 1;
while 1
    if ( not(isfile(sprintf("Workspaces/Simulation_%d", file_counter))) )
        Filepath = sprintf("Workspaces/Simulation_%d", file_counter);
        break
    end
        file_counter = file_counter + 1;
end

EDFA                                        = 220e-3;
Max_Generation                              = 15;
Popsize                                     = 50;
Mut_Rate                                    = 0.05;
Peaks                                        = zeros(1,Popsize);
Vec_Sel                                     = [];
Ctrl                                        = 1;
Lim                                         = [0.6 0.88 0.6 0.88 15e3 30e3 0.3e-3 1e-3]; %[coup_1 coup_2 L Pin]
Storage_Pop                                 = zeros(Popsize,length(Lim)/2,Max_Generation);
Storage_Diff                                = zeros(length(Peaks),Max_Generation);
Generation                                  = 1;
num_erros                                   = 0;
Storage_Erros                               = [];
    
%% Initial Pop Generation %%
Pop                                         = pop_gen(Popsize, Lim);

while 1  

%% Testing the Population %%
    [Vec_Prop, Peaks, Pop, erros, vec_erros] = fitness(Pop, Popsize, Ctrl, Lim);
    
    Storage_Erros                = [Storage_Erros; vec_erros];
    num_erros                    = num_erros + erros;
    Storage_Pop(:,:,Generation)  = Pop;
    Storage_Diff(:,Generation)   = Peaks;

%% Crossover %%
    New_Pop             = crossover(Lim, Pop, Popsize, Mut_Rate, Vec_Prop);

    print = sprintf('End of Generation %.2d Mean_Peaks =  %.2f   Max_Peaks= %.2f', Generation, mean(Peaks), max(Peaks));
    disp(print); 
    if Generation>=Max_Generation
        disp(['             ---------------     END OF TESTS HOR�?RIO: ',datestr(datetime('now')), '     ---------------']);
        break
    end
    Generation                             = Generation+1;
    Vec_Sel                                = [];
    Pop                                    = New_Pop;
end
save(Filepath,'Storage_Pop','Storage_Diff', 'Storage_Erros');

Individual = zeros(length(Pop(1,:)));
[lin, col] = find(Storage_Diff(:,:,i)==min(min(Storage_Diff(:,:,i))));
Individual(i,:) = Storage_Pop(lin(1),:,col(2),i)

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