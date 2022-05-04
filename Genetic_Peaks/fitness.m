function [Vec_Prop, Peaks, Pop, erros, vec_erros] = fitness(Pop, Popsize, Ctrl, Lim)
    
    Peaks = zeros(1,Popsize);
    erros = 0;
    vec_erros = [];
    loop_count = 1;
    for i=1:Popsize
        while 1
            try
                Peaks(i)          = sum(cascateado(Pop(i, :), 0, 0)>1e-3);
                if (loop_count > 1)
                    disp("-------------------------------------------------------------------Indivíduo bem sucedido!");
                end
                break
            catch e
                erros = erros + 1;
                fprintf(2,strcat("\n", e.message, "\n"));
                fprintf("Individuo testado: ");
                print_pop(Pop(i,:));

                if (rem(loop_count, 3)==0)
                    Pop(i, :) = pop_gen(1, Lim);
                    fprintf("Novo individuo:    ");
                    print_pop(Pop(i,:));
                else
                    Pop(i,:) = Pop(i,:)*1.01;
                    fprintf("Novo individuo:    ");
                    print_pop(Pop(i,:));
                end
                vec_erros(erros, :) = Pop(i,:);
            end
            loop_count = loop_count + 1;
        end
        loop_count = 0;
    end
    maximo = max(Peaks);
    Vec_Prop                                = (Peaks./maximo).^Ctrl;
end