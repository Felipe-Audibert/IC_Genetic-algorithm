function [str] = print_pop(Pop)
str = "";
    for c = 1:length(Pop(:))
        if(Pop(c)>0.001)
            str = str + "    " + Pop(c);
        else
            str = str + "    " + Pop(c);
        end
    end
end