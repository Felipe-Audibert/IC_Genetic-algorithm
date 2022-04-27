function [output] = ganho_simples(Pin, pop)

    Pin = Pin*1e3;
    A = pop(1);
    B = pop(2);
    C = pop(3);
    D = pop(4);
    GdB = A./(sqrt(B + C*Pin.^D));
    output = 10^(GdB/10);

end