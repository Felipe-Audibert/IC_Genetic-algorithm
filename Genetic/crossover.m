function [New_Pop] = crossover(Lim, Pop, Popsize, Mut_Rate, Vec_Prop)

    Vec_Sel                                     = [];
    New_Pop                                     = zeros(Popsize,length(Lim)/2);

    for i=1:Popsize
            Vec_Sel                             = [Vec_Sel, ones(1,round(Vec_Prop(i)*1000))*i];
    end
    for i=1:Popsize/2
        Cross                               = [Vec_Sel(ceil(rand()*length(Vec_Sel))) Vec_Sel(ceil(rand()*length(Vec_Sel)))];
        while Cross(1)==Cross(2)
            Cross                           = [Vec_Sel(ceil(rand()*length(Vec_Sel))) Vec_Sel(ceil(rand()*length(Vec_Sel)))];
        end
        
        for j=1:length(Lim)/2
            if rand()<=0.5
                New_Pop(i,j)                        = Pop(Cross(1), j);
                New_Pop(i+Popsize/2,j)              = Pop(Cross(2), j);
            else
                New_Pop(i,j)                        = Pop(Cross(2), j);
                New_Pop(i+Popsize/2,j)              = Pop(Cross(1), j);
            end
        end
    end
    
    for i=1:Popsize
        for j=1:2:length(Lim)
            if rand()<=Mut_Rate
                New_Pop(i, j/2+0.5) = [Lim(j)+rand()*((Lim(j+1)-Lim(j)))];
            end
        end
    end
end