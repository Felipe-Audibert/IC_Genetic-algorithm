% ----------------------------------------------------------------------- %
% ---- Analytical solution for multiwavelength brillouin fiber lasers --- %
% -------------------------- Date: 30/03/2020 --------------------------- %
% ------------------ Author: Felipe de Rossi Audibert ------------------- %
% ----------- Implementation of the code on the Matlab R2016a ----------- %
% ------------------------------------------------------------------------%

% Notes: Esse programa testa para diferentes potencias os valores simulados 
%pela função cascateado_saturado(pop,ifplot) e compara com os valores
%medidos.
clc,clear all, close all;

v_aux = [6 1.0;15 0.43;22 0.68;31 4.01;38 14.0];

for i = 1:5
   cascateado_saturado_teste([13.004,0.98959,9.7705e-07,3.8531],1,v_aux(i,1),v_aux(i,2));
   
end
   