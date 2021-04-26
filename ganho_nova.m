function [outputArg1] = ganho(inputArg1,pop)
warning off all
%GANHO Summary of this function goes here
%   Detailed explanation goes here
% Pin = inputArg1*1e3;
% A = pop(1);
% B = pop(2);
% C = pop(3);
% D = pop(4);
% GdB = A/(sqrt(B + C*Pin^D));

Gmax = num2str(pop(1));
Psat = num2str(pop(2));
Pin = num2str(double(inputArg1));

syms G;

s = strcat('G=1+(',Psat,'/',Pin,')*log(',Gmax,'/G)');
GdB = solve(s,G);

outputArg1 = 10^(GdB/10);

end