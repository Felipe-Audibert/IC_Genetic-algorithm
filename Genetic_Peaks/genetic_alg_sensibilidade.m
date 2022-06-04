function [] = genetic_alg_sensibilidade(in_gen,in_pop_size,in_mut_rate)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here


%% Função de ganho variável%%
warning off all
close all
clc
disp(['             ---------------     Começo do Algorítmo genético. HOR�?RIO: ' datestr(datetime('now')), '     ---------------']);

%% Variables definition %%

File_name = sprintf("Simulation_gen_%d_pop_%d_mut_%.3f.mat",in_gen,in_pop_size,in_mut_rate);


EDFA                                        = 220e-3;
Max_Generation                              = in_gen;
Popsize                                     = in_pop_size;
Mut_Rate                                    = in_mut_rate;
Peaks                                        = zeros(1,Popsize);
Vec_Sel                                     = [];
Ctrl                                        = 1;
Lim                                         = [0.25 0.95 0.25 0.95 15e3 25e3 0.3e-3 1e-3]; %[coup_1 coup_2 L Pin]
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
save(File_name,'Storage_Pop','Storage_Diff', 'Storage_Erros');





end

