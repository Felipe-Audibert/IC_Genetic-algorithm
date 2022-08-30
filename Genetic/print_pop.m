function [] = print_pop(Pop)
    for c = 1:length(Pop(:))
        if(Pop(c)>0.001)
            fprintf("%.6f   ", Pop(c));
        else
            fprintf("%e   ", Pop(c))
        end
    end
    fprintf("\n")
end