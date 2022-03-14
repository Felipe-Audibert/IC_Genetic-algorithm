function [output] = ganho_sym_2020(Pin, Gmax, Psat)
% Pin em W
% Gmax
% Psat em W

warning off all
syms G;

s = str2sym(strcat('G=1+(',num2str(Psat),'/',num2str(Pin),')*log(',num2str(Gmax),'/G)'));
GdB = double(solve(s,G));
output = 10.^(GdB/10);
end