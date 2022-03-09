function [Vec_Prop, Simu] = fitness(EDFA, Pin, Pop, Popsize, Ctrl)
    
    Simu = zeros(1,Popsize);
    for i=1:Popsize
        Simu(i)          = cascateado(EDFA, Pin, Pop(i, :), 0, 0);
        Peaks(i)         = sum(Simu(i)>1e-3);
    end
    maximo = max(Peaks);
    Vec_Prop                                = (Peaks./maximo).^Ctrl;
end