% ----------------------------------------------------------------------- %
% ---- Analytical solution for multiwavelength brillouin fiber lasers --- %
% -------------------------- Date: 30/03/2020 --------------------------- %
% ---------------------- Author: Lu�s C. B. Silva ----------------------- %
% ----------- Implementation of the code on the Matlab R2019a ----------- %
% ------------------------------------------------------------------------%

%% Notes:
% This code implements the analytical solution presented in the paper: 
%''Analytical approach to calculate the gain of Brillouin fiber amplifiers 
% in the regime of pump depletion (https://doi.org/10.1364/AO.58.007628)"
% Moreover, the laser cavity is constructed and the pump power is scanned 
% to compare the laser output with the NZDSF fiber experimental data.

close all
clear all
format short
clc  

%% Load MWBFL experimental results:
% load('Lambda')
% load('Lambda3')
% %load('Lambda4')
% %load('Lambda5')
% %load('Lambda6')
% load('Power')
% load('Power3')
% %load('Power4')
% %load('Power5')
% %load('Power6')
% clearvars -except Lambda Lambda3 Lambda4 Lambda5 Lambda6 Power Power3 Power4 Power5 Power6
%% Load new data (Dudu)
%load('Workspace_009.mat')
%load('Workspace_010.mat')
%load('Workspace_011.mat')
%load('Workspace_012.mat')
%load('Workspace_013.mat')
%load('Workspace_014.mat')
load('Workspace_015.mat')

Lambda = Lambda15;
Power = Power15;

%% Variables definition: 
PsL                                    = 1*10^(-8);                             % wave Stokes inital value
y                                      = 0.2261;                                 % peak SBS efficiency (called gamma)
Alfa                                   = 0.23026*0.201e-3;                       % optical loss coefficient of the fiber 
L                                      = 25e3;                                   % fiber length
position_step                          = 100;                                    % position step
z                                      = 0:position_step:L;                      % propagation position in the fiber in meters
A                                      = -log(y*L*PsL);                          % auxiliary parameter 
Pcr                                    = real((A+sqrt((A^2+4*A)))./(2*y*L));     % critical pump power
Psc                                    = 1/(y*L);                                % critical Stokes power
turns                                  = 10;                                     % number of cavity turns in the fiber
round_trips                            = (1:turns)';                             % round trips inside of the cavity   
gain_dB                                = 12.2;                                     % EDFA gain in dBs 
amplification                          = 10^(gain_dB/10);                        % EDF amplification factor in the second cavity
stokes_lines_number                    = 18;                                     % number of output sotkes channels
Pp0 = 0.43e-3;                              % Potencia bombeio inicial [W]

%% Markers for loops:
pos                                    = 1;                                      % position marker along the fiber
cav_pos                                = 1;                                      % cavity turns marker
pump_pos                               = 1;                                      % pump power marker
stokes_pos                             = 1;                                      % multiwavelength stokes lines marker

%% Couplers:
coupler_output_1                       = 0.2;                                    % output coupling percentage of the first cavity  
coupler_cavity_1                       = 0.8;                                    % cavity coupling percentage of the first cavity
coupler_output_2                       = 0.19;                                    % output coupling percentage of the second cavity  
coupler_cavity_2                       = 0.81;                                    % cavity coupling percentage of the second cavity

%% Counters:
count_weak                             = 0;
count_high                             = 0;
count_satu                             = 0;

%% Warnings:
if position_step ~= 100
   disp('error: position step should not be altered');
   disp('correction: Make position_step = 100');
   return
end

%% Variable initialization:
Ppz                                    = zeros(turns,length(z));
Psz                                    = zeros(turns,length(z));
fiber                                  = zeros(1,length(z));
Pp_cav                                 = zeros(turns,1);
Pstokes                                = zeros(turns,1);
output_1                               = zeros(turns,1);
PsL_cav_1                              = zeros(turns,1); 
PsL_cav_2                              = zeros(turns,1); 
output_pump                            = zeros(15,1);
output_2                               = zeros(turns,1);
new_input_1                            = zeros(turns,1);
stokes_lines                           = zeros(turns,stokes_lines_number);
Pp0_vector                             = zeros(1,stokes_lines_number);

%%%%%%%%%%%% A partir daqui testes do dudu 14-04-20 %%%%%%%%%%%%
Pp0 = Pp0*amplification/2
fim = 0;

for comp_onda = 1:stokes_lines_number
    comp_onda
    if comp_onda ~= 1
        y = 0.2261/2;
    end
%% First cavity:
        for cavity                     = 1:turns
                    
            %% Changes the boundary condition PsL throughout turns:
            if cav_pos                 > 1
                PsL                    = PsL_cav_1(cav_pos-1,1);
            end      

            %% Weak regime:  
            if Pp0 < Pcr && PsL < Psc
                count_weak             = count_weak + 1;
                for z                  = 0:position_step:L       
                    a1                 = vpa(exp((y*PsL*Alfa*vpa(exp(((y*Pp0-y*Pp0*exp((-Alfa*L))-(Alfa^2)*L)/Alfa)))-y*PsL*Alfa*vpa(exp(((-y*Pp0*exp((-Alfa*L))+y*Pp0*exp((-Alfa*z))-(Alfa^2)*(L-z))/Alfa))))/Alfa^2));  
                    a2                 = exp((-y^2*Pp0*PsL*(vpa(expint(((-y*Pp0*vpa(exp((-Alfa*z)))/Alfa))))+vpa(-expint((-Pp0*y/Alfa))))*vpa(exp(((-y*Pp0*exp((-Alfa*L))-L*Alfa^2)/Alfa)))-z*(Alfa^3))/Alfa^2);
                    Ppz(cav_pos,pos)   = vpa((Pp0*a1*a2));
                    b1                 = vpa(exp((y*Alfa*Pp0*vpa(exp(((-y*PsL*exp((-Alfa*(L-z)))+y*PsL*vpa(exp((-Alfa*L)))-(Alfa^2)*(z))/Alfa)))-y*Alfa*Pp0*vpa(exp(((y*PsL*vpa(exp((-Alfa*L)))-y*PsL-(Alfa^2)*L)/Alfa))))/Alfa^2));
                    b2                 = vpa(exp(((-y^2*Pp0*PsL*(vpa(expint((y*PsL*vpa(exp((-Alfa*(L-z))))/Alfa)))-vpa(expint((PsL*y/Alfa))))*vpa(exp(((y*PsL*exp((-Alfa*L))-L*Alfa^2)/Alfa)))-(L-z)*(Alfa^3))/(Alfa^2))));
                    Psz(cav_pos,pos)   = vpa((PsL*b1*b2));
                    fiber(:,pos)       = z;
                    pos                = pos + 1;    
                end
                P_Stokes               = double(real(10*log10(Psz)));            % evolution of pump power Pp(z) in dB
                P_pump                 = double(real(10*log10(Ppz)));            % evolution of Stokes power Ps(z) in dB
            end

            %% High regime:
            if Pp0 > Pcr && PsL < Psc
                E                      = PsL/Pp0;                                % auxiliary parameter    
                k                      = y*Pp0*L;                                % auxiliary parameter 
                A_high                 = -log(k*E);                              % auxiliary parameter 
                fi                     = 0.1*log10(PsL)+1.7;                     % auxiliary parameter 
                count_high             = count_high + 1;
                for z                  = 0:position_step:L
                    c1                 = (Pp0/k)*(A_high+log(A_high*(1-A_high/k))-log(1-(1/exp(A_high)))-log(1+A_high/(k*(exp(A_high)-1))));
                    Pp_c1              = c1*Pp0/(Pp0+(c1-Pp0)*exp(-c1*y*z));
                    Ps_c1              = c1*(Pp0-c1)/(Pp0*exp(c1*y*z)+(c1-Pp0));
                    p1                 = 1-exp(Alfa*(c1*y+Alfa)*z/(c1*y-Alfa))*(-(Pp0*Alfa*exp(c1*y*z*fi)-(c1*y-Alfa)*(c1-Pp0))/(c1*((c1-Pp0)*y-Alfa)))^(-(2*Alfa/(fi*(c1*y-Alfa))));
                    u1                 = 1-exp((Alfa*(z-L)*(c1*y-Alfa))/(c1*y+Alfa));
                    Ppz(cav_pos,pos)   = Pp_c1*(1-p1);
                    Psz(cav_pos,pos)   = Ps_c1*(1-u1);
                    fiber(:,pos)       = z;
                    pos                = pos + 1;    
                end
                P_Stokes               = double(real(10*log10(Psz)));            % evolution of pump power Pp(z) in dB
                P_pump                 = double(real(10*log10(Ppz)));            % evolution of Stokes power Ps(z) in dB
            end

            %% Saturated regime:
            if PsL > Psc 
                count_satu             = count_satu + 1;
                for z                  = 0:position_step:L
                    c2                 = (-0.99*y*L*PsL-lambertw(-y*L*PsL*exp(-0.99*y*L*PsL)))/(y*L);
                    Pp_c2              = (c2*Pp0)/(Pp0+(c2-Pp0)*(exp((-c2*y*z))));
                    Ps_c2              = c2*(Pp0-c2)/(Pp0*exp(c2*y*z)+(c2-Pp0));
                    p2                 = 1-exp((2*Alfa*log((Pp0*exp(c2*y*L)-Pp0+c2)/(Pp0*exp(c2*y*L/2)-Pp0+c2))-c2*y-Alfa)*z+(c2*y*exp(-Alfa*L)*(exp(Alfa*z)-1))/Alfa);
                    u2                 = (exp(Alfa*(z-L))-1+(2*Alfa/c2*y)*log((Pp0*exp(c2*y*z/2)-Pp0+c2)/(Pp0*exp(c2*y*z)-Pp0+c2)))/((Pp0-c2)/(Pp0*exp(c2*y*z)-Pp0+c2));
                    Ppz(cav_pos,pos)   = Pp_c2*(1-p2);
                    Psz(cav_pos,pos)   = Ps_c2*(1-u2);
                    fiber(:,pos)       = z;
                    pos                = pos + 1;    
                end
                P_Stokes               = double(real(10*log10(Psz)));            % evolution of pump power Pp(z) in dB
                P_pump                 = double(real(10*log10(Ppz)));            % evolution of Stokes power Ps(z) in dB
            end
            Alpha_cav_dB               = 2;                                      % power loss due to cavity in dB
            Alpha_cav_linear           = 10^(Alpha_cav_dB/10);                   % power loss due to cavity in a linear scale     
            Pstokes(cav_pos,1)         = Psz(cav_pos,1)/Alpha_cav_linear;        % stokes power before output coupler
            output_1(cav_pos,1)        = Pstokes(cav_pos,1)*coupler_output_1;    % output from the first cavity to the second one
            PsL_cav_1(cav_pos,1)       = Pstokes(cav_pos,1)*coupler_cavity_1;    % stokes power that returns to the cavity
            %% Second cavity:
             output_2(cav_pos,1)        = output_1(cav_pos,1)*coupler_output_2;   % output of the second cavity (laser output)
             PsL_cav_2(cav_pos,1)       = output_1(cav_pos,1)*coupler_cavity_2;   % stokes power that returns to the cavity
%             PsL_cav_2(cav_pos,1)       = PsL_cav_2(cav_pos,1);
%             new_input_1(cav_pos,1)     = PsL_cav_2(cav_pos,1);                   % new input in the first cavity
              cav_pos                    = cav_pos + 1;                        
              pos                        = 1;
        end
        Pot_saida(comp_onda) =  output_2(cav_pos-1,1);
        Pot_saida_dBm(comp_onda) = 10*log10((Pot_saida(comp_onda)+1e-8)./1e-3);
        Pot_saida_dB(comp_onda) = 10*log10(Pot_saida(comp_onda));
        bombeio(comp_onda) = Pp0;
        Pp0 = PsL_cav_2(cav_pos-1,1)*amplification/2;
        bombeio_pre_edfa(comp_onda) = Pp0/amplification;
        
end
% figure(1)
% plot(1:comp_onda,Pot_saida*1e3,'o')
% ylabel('Pot�ncia na sa�da do laser [mW]')
% figure(2)
% plot(1:comp_onda,bombeio*1e3,'o')
% ylabel('Pot�ncia entrando na cavidade Brillouin [mW]')
% figure(3)
% plot(1:comp_onda,Pot_saida_dBm,'o')
% ylabel('Pot�ncia na sa�da do laser [dBm]')
% figure(5)
% plot(1:comp_onda,real(bombeio_pre_edfa)*1e3,'o')
% ylabel('Pot�ncia entrando no EDFA [mW]')

%%%%%%% Potencias totais em mW %%%%%%%
Pot_saida_total = sum(real(Pot_saida))*1e3
Pot_antes_edfa_total = sum(real(bombeio_pre_edfa))*1e3
Pot_depois_edfa_total = sum(real(bombeio))*1e3

%% Find peaks (envelope) in experimental data:
%[pks480,locs480]                       = findpeaks(real(Power(405:end-270)),Lambda(405:end-270),'MinPeakDistance',(Lambda(2)-Lambda(1))*19);
%[pks680,locs680]                       = findpeaks(real(Power3(405:end-160)),Lambda3(405:end-160),'MinPeakDistance',(Lambda3(2)-Lambda3(1))*20);
%[pks880,locs880]                       = findpeaks(real(Power4(405:end-160)),Lambda4(405:end-160),'MinPeakDistance',(Lambda4(2)-Lambda4(1))*20);
%[pks980,locs980]                       = findpeaks(real(Power5(405:end-160)),Lambda5(405:end-160),'MinPeakDistance',(Lambda5(2)-Lambda5(1))*20);
% [pks1080,locs1080]                     = findpeaks(real(Power6(405:end-150)),Lambda6(405:end-150),'MinPeakDistance',(Lambda6(2)-Lambda6(1))*20);
%[pks1080,locs1080]                     = findpeaks(real(Power6(405:end-270)),Lambda6(405:end-270),'MinPeakDistance',(Lambda6(2)-Lambda6(1))*20);
Power= 10*log10((Power)/1e-3);
[pks480,locs480]                       = findpeaks(real(Power(405:end-200)),Lambda(405:end-200),'MinPeakDistance',(Lambda(2)-Lambda(1))*19);


figure(4)
subplot(1,2,1)
plot(pks480-max(pks480),'-o')
hold on
subplot(1,2,1)
plot(1:comp_onda,real(Pot_saida_dBm)-max(real(Pot_saida_dBm)),'-o')
hold off
xlabel('Comprimentos de onda gerados')
ylabel('Intensity [a. u. dB]')
% plot(1:comp_onda,Pot_saida_dBm,'o')
% ylabel('Pot�ncia na sa�da do laser [dBm]')
L1 = 10.^(real(pks480-max(pks480))/10);
aux = real(Pot_saida_dBm)-max(real(Pot_saida_dBm));
aux = aux.';
L2 = 10.^(aux/10);
%figure(4)
subplot(1,2,2)
plot(L1,'-o')
hold on
subplot(1,2,2)
plot(1:comp_onda,L2,'-xr')
hold off
ylabel('Intensity [a. u. linear]')
xlabel('Comprimentos de onda gerados')

%%%%% Calculo de R^2 do ajuste da curva linear %%%%%%%%
SSr = sum(abs(L2-L1));
SSt = sum(abs(L1-mean(L1)));
R2 = 1 - SSr/SSt

%%%%% Calculos de potencias a partir dos dados experimentais do OSA %%%%%

P1 = 10.^(real(Power)/10);
P2 = 10.^(real(Power)/10);
Pot1 = trapz(Lambda,P1);
Pot2 = trapz(Lambda,P2)

% %%%%% Integrador manual %%%%%%   
% Est� comentado aqui pois est� dando os mesmos resultados da fun��o trapz
% area_tot = 0;
% for a = 1:length(Lambda)-1
%     area = (Lambda(a+1)-Lambda(a))*(P1(a)+(P1(a+1)-P1(a))/2);
%     area_tot = area_tot+area;
% end
% %%%%%%%%%%%% Graficos reconstru�dos com sech^2 %%%%%%%%%%
 num = length(Lambda);
 delta_lambda = Lambda(num)-Lambda(1);
 eixo_x = linspace(-37*pi,37*pi,num);
 osa_simulado = zeros(1,num);
%  ajuste = (mean(Lambda)-locs480(1))*74*pi/delta_lambda;
%  eixo_y = sech(eixo_x + ajuste).^2;
%  eixo_y = eixo_y*max(P1);
%  figure(8)
%  plot(Lambda,eixo_y,'r',Lambda,P1)
 
 for tt=1:stokes_lines_number
        ajuste = (mean(Lambda)-locs480(tt))*74*pi/delta_lambda;
        eixo_y(tt,:) = sech(eixo_x + ajuste).^2;
        eixo_y(tt,:) = eixo_y(tt,:)*L2(tt);     
        osa_simulado = eixo_y(tt,:) + osa_simulado;
 end
 
 
figure(8)
%plot(Lambda,eixo_y(6,:),'r',Lambda,P1/max(P1))
plot(Lambda,osa_simulado,'r',Lambda,P1/max(P1))
% axis([1565.5 1567 0 1.1])
xlabel('Wavelength (nm)','FontName','Times New Roman','FontSize',16,'FontWeight','bold')
ylabel('Optical spectrum (u.a.)','FontName','Times New Roman','FontSize',16,'FontWeight','bold')
%legend('Experimental','Analytical solution','FontName','Times New Roman','FontSize',16,'FontWeight','bold')
 axis([1565.5 1567.5 -0.02 1.1])
% plt = gca;
% plt.YAxis(1).Color = 'k';
% plt.XAxis(1).Color = 'k';
% set(plt.YAxis(1),'FontName','Times New Roman','FontSize',16,'FontWeight','bold');
% set(plt.XAxis(1),'FontName','Times New Roman','FontSize',16,'FontWeight','bold');


%%%%%%%%%%%%%
% figure(6)
% plot(Lambda,P1)
% figure(7)
% plot(Lambda6,P2)

erro = (1-Pot_saida_total/Pot1)*100             % erro percentual entre valor de pot�ncia na saida "medido" e simualdo

%%%%%%%%% Os testes v�o at� aqui %%%%%%%%%%%%



% 
% %% Pump power sweep:  
% pump_axis_x                            = (1:1:15)*1e-3;                          % pump power for the x-axis of the analytical solution
% 
% for pump                               = ((1/1)*1e-3)*amplification              % this division by 2 is due to coupler 1 (50/50)
%         Pp0                            = pump;                                   % pump power
%         
%     for multi_stokes                   = 1:stokes_lines_number         
%         Pp0                            = Pp0*amplification;                      % pump power amplified by EDFA
%         
%         %% First cavity:
%         for cavity                     = 1:turns
%                     
%             %% Changes the boundary condition PsL throughout turns:
%             if cav_pos                 > 1
%                 PsL                    = PsL_cav_1(cav_pos-1,1);
%             end      
% 
%             %% Weak regime:  
%             if Pp0 < Pcr && PsL < Psc
%                 count_weak             = count_weak + 1;
%                 for z                  = 0:position_step:L       
%                     a1                 = vpa(exp((y*PsL*Alfa*vpa(exp(((y*Pp0-y*Pp0*exp((-Alfa*L))-(Alfa^2)*L)/Alfa)))-y*PsL*Alfa*vpa(exp(((-y*Pp0*exp((-Alfa*L))+y*Pp0*exp((-Alfa*z))-(Alfa^2)*(L-z))/Alfa))))/Alfa^2));  
%                     a2                 = exp((-y^2*Pp0*PsL*(vpa(expint(((-y*Pp0*vpa(exp((-Alfa*z)))/Alfa))))+vpa(-expint((-Pp0*y/Alfa))))*vpa(exp(((-y*Pp0*exp((-Alfa*L))-L*Alfa^2)/Alfa)))-z*(Alfa^3))/Alfa^2);
%                     Ppz(cav_pos,pos)   = vpa((Pp0*a1*a2));
%                     b1                 = vpa(exp((y*Alfa*Pp0*vpa(exp(((-y*PsL*exp((-Alfa*(L-z)))+y*PsL*vpa(exp((-Alfa*L)))-(Alfa^2)*(z))/Alfa)))-y*Alfa*Pp0*vpa(exp(((y*PsL*vpa(exp((-Alfa*L)))-y*PsL-(Alfa^2)*L)/Alfa))))/Alfa^2));
%                     b2                 = vpa(exp(((-y^2*Pp0*PsL*(vpa(expint((y*PsL*vpa(exp((-Alfa*(L-z))))/Alfa)))-vpa(expint((PsL*y/Alfa))))*vpa(exp(((y*PsL*exp((-Alfa*L))-L*Alfa^2)/Alfa)))-(L-z)*(Alfa^3))/(Alfa^2))));
%                     Psz(cav_pos,pos)   = vpa((PsL*b1*b2));
%                     fiber(:,pos)       = z;
%                     pos                = pos + 1;    
%                 end
%                 P_Stokes               = double(real(10*log10(Psz)));            % evolution of pump power Pp(z) in dB
%                 P_pump                 = double(real(10*log10(Ppz)));            % evolution of Stokes power Ps(z) in dB
%             end
% 
%             %% High regime:
%             if Pp0 > Pcr && PsL < Psc
%                 E                      = PsL/Pp0;                                % auxiliary parameter    
%                 k                      = y*Pp0*L;                                % auxiliary parameter 
%                 A_high                 = -log(k*E);                              % auxiliary parameter 
%                 fi                     = 0.1*log10(PsL)+1.7;                     % auxiliary parameter 
%                 count_high             = count_high + 1;
%                 for z                  = 0:position_step:L
%                     c1                 = (Pp0/k)*(A_high+log(A_high*(1-A_high/k))-log(1-(1/exp(A_high)))-log(1+A_high/(k*(exp(A_high)-1))));
%                     Pp_c1              = c1*Pp0/(Pp0+(c1-Pp0)*exp(-c1*y*z));
%                     Ps_c1              = c1*(Pp0-c1)/(Pp0*exp(c1*y*z)+(c1-Pp0));
%                     p1                 = 1-exp(Alfa*(c1*y+Alfa)*z/(c1*y-Alfa))*(-(Pp0*Alfa*exp(c1*y*z*fi)-(c1*y-Alfa)*(c1-Pp0))/(c1*((c1-Pp0)*y-Alfa)))^(-(2*Alfa/(fi*(c1*y-Alfa))));
%                     u1                 = 1-exp((Alfa*(z-L)*(c1*y-Alfa))/(c1*y+Alfa));
%                     Ppz(cav_pos,pos)   = Pp_c1*(1-p1);
%                     Psz(cav_pos,pos)   = Ps_c1*(1-u1);
%                     fiber(:,pos)       = z;
%                     pos                = pos + 1;    
%                 end
%                 P_Stokes               = double(real(10*log10(Psz)));            % evolution of pump power Pp(z) in dB
%                 P_pump                 = double(real(10*log10(Ppz)));            % evolution of Stokes power Ps(z) in dB
%             end
% 
%             %% Saturated regime:
%             if PsL > Psc 
%                 count_satu             = count_satu + 1;
%                 for z                  = 0:position_step:L
%                     c2                 = (-0.99*y*L*PsL-lambertw(-y*L*PsL*exp(-0.99*y*L*PsL)))/(y*L);
%                     Pp_c2              = (c2*Pp0)/(Pp0+(c2-Pp0)*(exp((-c2*y*z))));
%                     Ps_c2              = c2*(Pp0-c2)/(Pp0*exp(c2*y*z)+(c2-Pp0));
%                     p2                 = 1-exp((2*Alfa*log((Pp0*exp(c2*y*L)-Pp0+c2)/(Pp0*exp(c2*y*L/2)-Pp0+c2))-c2*y-Alfa)*z+(c2*y*exp(-Alfa*L)*(exp(Alfa*z)-1))/Alfa);
%                     u2                 = (exp(Alfa*(z-L))-1+(2*Alfa/c2*y)*log((Pp0*exp(c2*y*z/2)-Pp0+c2)/(Pp0*exp(c2*y*z)-Pp0+c2)))/((Pp0-c2)/(Pp0*exp(c2*y*z)-Pp0+c2));
%                     Ppz(cav_pos,pos)   = Pp_c2*(1-p2);
%                     Psz(cav_pos,pos)   = Ps_c2*(1-u2);
%                     fiber(:,pos)       = z;
%                     pos                = pos + 1;    
%                 end
%                 P_Stokes               = double(real(10*log10(Psz)));            % evolution of pump power Pp(z) in dB
%                 P_pump                 = double(real(10*log10(Ppz)));            % evolution of Stokes power Ps(z) in dB
%             end
%             Alpha_cav_dB               = 2;                                      % power loss due to cavity in dB
%             Alpha_cav_linear           = 10^(Alpha_cav_dB/10);                   % power loss due to cavity in a linear scale     
%             Pstokes(cav_pos,1)         = Psz(cav_pos,1)/Alpha_cav_linear;        % stokes power before output coupler
%             output_1(cav_pos,1)        = Pstokes(cav_pos,1)*coupler_output_1;    % output from the first cavity to the second one
%             PsL_cav_1(cav_pos,1)       = Pstokes(cav_pos,1)*coupler_cavity_1;    % stokes power that returns to the cavity
%             
%             %% Second cavity:
%             output_2(cav_pos,1)        = output_1(cav_pos,1)*coupler_output_2;   % output of the second cavity (laser output)
%             PsL_cav_2(cav_pos,1)       = output_1(cav_pos,1)*coupler_cavity_2;   % stokes power that returns to the cavity
%             PsL_cav_2(cav_pos,1)       = PsL_cav_2(cav_pos,1);
%             new_input_1(cav_pos,1)     = PsL_cav_2(cav_pos,1);                   % new input in the first cavity
%             cav_pos                    = cav_pos + 1;                        
%             pos                        = 1;
%         end
%         Alpha_cav_dB_2                 = 2;                                      % power loss due to second cavity in dB
%         Alpha_cav_linear_2             = 10^(Alpha_cav_dB_2/10);                 % power loss due to second cavity in a linear scale  
%         new_input_1                    = new_input_1/Alpha_cav_linear_2;
%         Pp0                            = ((new_input_1(end,1))/2);               % this division by 2 is due to coupler 1 (50/50) 
%         Pp0_vector(:,stokes_pos)       = real(Pp0); 
%         stokes_lines(:,stokes_pos)     = output_2;
%         stokes_pos                     = stokes_pos + 1; 
%         cav_pos                        = 1;        
%     end
%     output_pump(pump_pos,:)            = output_1(end);
%     pump_pos                           = pump_pos + 1;    
% end
% stokes_lines_dBm                       = real(10*log10(((real(stokes_lines(end,:))))/1E-3)); 
% 
% %% Find peaks (envelope) in experimental data:
% [pks480,locs480]                       = findpeaks(real(Power(405:end-270)),Lambda(405:end-270),'MinPeakDistance',(Lambda(2)-Lambda(1))*19);
% [pks1080,locs1080]                     = findpeaks(real(Power6(405:end-270)),Lambda6(405:end-270),'MinPeakDistance',(Lambda6(2)-Lambda6(1))*20);
% 
% %% Figure
% figure()
% close all
% plot(locs480,pks480,'b','LineWidth',1.5,'Marker','o')
% hold all
% plot(Lambda(405:end-270),real(Power(405:end-270)),'m','LineWidth',1.5)
% hold all
% plot(locs1080,pks1080,'b','LineWidth',1.5,'Marker','o')
% hold all
% plot(Lambda6(405:end-270),real(Power6(405:end-270)),'r','LineWidth',1.5)
% 
% %% Figure
% close all
% figure()
% plot(Lambda(405:end-270),real(Power(405:end-270)),'r','LineWidth',1.5)
% hold all
% plot(locs480,stokes_lines_dBm(1:end-0),'b','LineWidth',1.5,'Marker','square')
% xlabel('Wavelength (nm)','FontName','Times New Roman','FontSize',16,'FontWeight','bold')
% ylabel('Laser output (dB)','FontName','Times New Roman','FontSize',16,'FontWeight','bold')
% legend('Experimental','Analytical solution','FontName','Times New Roman','FontSize',16,'FontWeight','bold')
% axis([1565.73 1567.15 -44 18])
% plt = gca;
% plt.YAxis(1).Color = 'k';
% plt.XAxis(1).Color = 'k';
% set(plt.YAxis(1),'FontName','Times New Roman','FontSize',16,'FontWeight','bold');
% set(plt.XAxis(1),'FontName','Times New Roman','FontSize',16,'FontWeight','bold');
% 
% %% End 