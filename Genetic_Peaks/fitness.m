function [Vec_Prop, Peaks] = fitness(EDFA, Pin, Pop, Popsize, Ctrl)
    
    Peaks = zeros(1,Popsize);
    for i=1:Popsize
        Peaks(i)          = sum(cascateado(EDFA, Pin, Pop(i, :), 0, 0)>1e-3);
    end
    maximo = max(Peaks);
    Vec_Prop                                = (Peaks./maximo).^Ctrl;
end