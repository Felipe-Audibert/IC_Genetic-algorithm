close all
clear dirs
warning off all

dirs = struct2cell(dir('plot_fig_Workspaces'));

for file = dirs(1, :)
    
    fileName = char(file);
    if (endsWith(fileName, '.mat'))

        load(fileName);
        WorkspaceName = erase(fileName, '.mat');

        [pop, gen] = find(Storage_Diff == max(max(Storage_Diff)), 1);
        %[pop gen] = find(Storage_Diff == min(min(Storage_Diff)), 1);

        cascateado(Storage_Pop(pop, :, gen), 0, strcat('.\Figures\', WorkspaceName));
    end
    
end