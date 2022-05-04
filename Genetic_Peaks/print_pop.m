function [] = print_pop(Pop)
    for c = 1:length(Pop(:))
        fprintf("%.6f   ", Pop(c));
    end
    fprintf("\n")
end