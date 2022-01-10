function [Pop] = pop_gen(Popsize, Lim)
    Pop = zeros(Popsize, length(Lim)/2);
    for i = 1:Popsize
        for j = 1:2:length(Lim)
            Pop(i, j/2+0.5) = [Lim(j)+rand()*((Lim(j+1)-Lim(j)))];
        end
    end
end