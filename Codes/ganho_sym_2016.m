function [output] = ganho_sym_2016_teste(Pin, Gmax, Psat)
%% Só funciona para versões do MATLAB2018 ou inferior, para versõs superiores utilize ganho_sym_2020
% Não foi testado para todas as versões, mas acreditamos que a mudanã de
% bibliotecas ocorreu em 2019

% Pin em W
% Gmax em dB
% Psat em W

warning off all
syms G;

s = str2sym(strcat('G=1+(',num2str(Psat),'/',num2str(Pin),')*log(',num2str(Gmax),'/G)'));
GdB = double(solve(s,G));
output = 10.^(GdB/10);
end