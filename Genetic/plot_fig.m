close all
clear dirs
clear tit fig
warning off all

dirs = struct2cell(dir('plot_fig_Workspaces'));

for folder = dirs(1, :)
    folderName = char(folder);
    if not(contains(folderName, '.'))
        files = struct2cell(dir(strcat('plot_fig_Workspaces/', folderName)));
        
        for file = files(1, :)
            fileName = char(file);
            if (endsWith(fileName, '.mat'))

                load(strcat('./plot_fig_Workspaces/', folderName, '/', fileName));
                Storage_Diff = Storage_Diff(:, :, 1);
                WorkspaceName = erase(fileName, '.mat');
                mkdir(strcat('./Figures/', folderName, '/', WorkspaceName));

                %[pop, gen] = find(Storage_Diff == max(max(Storage_Diff)), 1);
                [pop, gen] = find(Storage_Diff == min(min(Storage_Diff)), 1);
                disp(print_pop(Storage_Pop(pop, :, gen)))
                cascateado(EDFA, Pin, Storage_Pop(pop, :, gen), 0, strcat('.\Figures\', folderName, '\', WorkspaceName));

                %% Plots manuais
                fig(1) = figure('visible',0);
                tit(1) = "Media das populacoes";
                plot(mean(Storage_Diff),'b-o', 'LineWidth', 2)
                xlabel('Geração','FontName','Times New Roman','FontSize',16,'FontWeight','bold')
                ylabel('Número médio de pulsos','FontName','Times New Roman','FontSize',16,'FontWeight','bold')
                %axis([1565.5 1567.5 0 1.1])
                plt = gca;
                plt.YAxis(1).Color = 'k';
                plt.XAxis(1).Color = 'k';
                set(plt.YAxis(1),'FontName','Times New Roman','FontSize',16,'FontWeight','bold');
                set(plt.XAxis(1),'FontName','Times New Roman','FontSize',16,'FontWeight','bold');
                title(tit(1));

                fig(2) = figure('visible',0);
                tit(2) = "Melhores individuos por geracao";
                plot(min(Storage_Diff),'b-o', 'LineWidth', 2)
                xlabel('Geração','FontName','Times New Roman','FontSize',16,'FontWeight','bold')
                ylabel('Número médio de pulsos','FontName','Times New Roman','FontSize',16,'FontWeight','bold')
                %axis([1565.5 1567.5 0 1.1])
                plt = gca;
                plt.YAxis(1).Color = 'k';
                plt.XAxis(1).Color = 'k';
                set(plt.YAxis(1),'FontName','Times New Roman','FontSize',16,'FontWeight','bold');
                set(plt.XAxis(1),'FontName','Times New Roman','FontSize',16,'FontWeight','bold');
                title(tit(2));

                for i = 1:length(fig)
                    saveas(fig(i),strcat('.\Figures\', folderName, '\', WorkspaceName, '\', tit(i), '.jpg'));
                end
                close all
            end
        end
    end
end