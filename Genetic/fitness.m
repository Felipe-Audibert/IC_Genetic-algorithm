function [Vec_Prop, Diff, Pop, erros, vec_erros] = fitness(EDFA, Pin, Pop, Popsize, Ctrl, Lim)
    
    Diff = zeros(1,Popsize);
    erros = 0;
    vec_erros = [];
    loop_count = 1;
    for i=1:Popsize
        while 1
            try
                [Experimental, Analytical]          = cascateado(EDFA, Pin, Pop(i, :), 0, 0);
                Experimental(Experimental < -40)    = -40;
                Analytical(Analytical < -40)        = -40;
                Diff(i)                             = sum(abs(Experimental.' - Analytical));
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
            if loop_count >= 15
                Diff(i) = Inf;
                break;
            end
        end
        loop_count = 1;
    end
    Vec_Prop                                = (1./Diff).^Ctrl;
end