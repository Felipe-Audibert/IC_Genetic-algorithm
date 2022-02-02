%% cascateado_dudu(EDFA, Gmax, Psat, ifplot, savefig);

cascateado_dudu(20.6796, 8.8125);

%2 inputs: Gmax(dB) e Psat(W) -- EDFA=0.28, Pin=0.43e-3, ifplot=1, savefig=0
%4 inputs: EDFA(W), Pin(W), Gmax(dB), Psat(W) -- ifplot=1, savefig=0
%6 inputs: EDFA(W), Pin(W), Gmax(dB), Psat(W), ifplot(0 ou 1) e savefig(0 ou 1)


%Gmax é o ganho máximo da curva de saturação(Gmax<=10 gera gráficos estranhos)

%Psat é a potência em que o amplificador é considerado como saturado

%ifplot plota ou não as figuras geradas

%savefig salva as figuras como png na pasta respectiva de seu EDFA e Pin