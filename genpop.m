function [pop] = genpop(N, x)
    pop = zeros(N, 4);
    for c = [1:N]
        pop(c,:) = [100*rand()-50, 100*rand()-50, 100*rand()-50, 100*rand()-50];
    end
end