function [outputArg1] = ganho(inputArg1,pop)
%GANHO Summary of this function goes here
%   Detailed explanation goes here
Pin = inputArg1*1e3;
A = pop(1);
B = pop(2);
C = pop(3);
D = pop(4);
GdB = A/(sqrt(B + C*Pin^D));
outputArg1 = 10^(GdB/10);

end