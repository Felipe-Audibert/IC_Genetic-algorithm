function [Vec_Prop, Diff] = fitness(EDFA, Pin, Pop, Popsize, Ctrl)
    
    Diff = zeros(1,Popsize);
    for i=1:Popsize
        [Experimental, Analytical]          = cascateado(EDFA, Pin, Pop(i, :), 0, 0);
        Diff(i)                             = sum(abs(Experimental.' - Analytical));
    end
    
    Vec_Prop                                = (1./Diff).^Ctrl;
end