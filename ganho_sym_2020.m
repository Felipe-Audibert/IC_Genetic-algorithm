function [outputArg1] = ganho_sym_2020(Pin_in, Gmax_in, Psat_in)
warning off all
%GANHO Summary of this function goes here
%   Detailed explanation goes here
% Pin = inputArg1*1e3;
% A = pop(1);
% B = pop(2);
% C = pop(3);
% D = pop(4);
% GdB = A/(sqrt(B + C*Pin^D));

%Pinf = 10*log10(Pinf*1e3);  %Tá em dBm
syms G Psat Pin Gmax; 
s = str2sym('G=1+(Psat/Pin)*log(Gmax/G)');
s = subs(s,{Psat, Pin, Gmax},{Psat_in, Pin_in, Gmax_in});

GdB = double(solve(s,G));
outputArg1 = 10.^(GdB/10);

end