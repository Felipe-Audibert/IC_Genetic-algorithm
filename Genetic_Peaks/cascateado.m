function [simu] = cascateado(varargin)  
if      nargin==1
   EDFA = 0.28;
   Pin = 0.43e-3;
   Pop = varargin{1};
   ifplot = 1;
   savefig = 0;
   
elseif  nargin==3
   EDFA = varargin{1};
   Pin = varargin{2};
   Pop = varargin{3};
   ifplot = 1;
   savefig = 0;
   
elseif  nargin==5
   EDFA = varargin{1};
   Pin = varargin{2};
   Pop = varargin{3};
   ifplot = varargin{4};
   savefig = varargin{5};
   
else
    error('Wrong number of input variables');
end

if length(Pop)==2
    Gmax = Pop(1);
    Psat = Pop(2);
    Coup_1 = 0.2;
    Coup_2 = 0.19;
elseif length(Pop)==4
    Gmax = Pop(1);
    Psat = Pop(2);
    Coup_1 = Pop(3);
    Coup_2 = Pop(4);
else
    error('Wrong Pop vector length');
end

%% Variables definition: 
PsL                                    = 1e-8;                                   % wave Stokes inital value
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
stokes_lines_number                    = 40;                                     % number of output sotkes channels
Pp0                                    = Pin;                                    % Potencia bombeio inicial [W]
Lambda                                 = [1564.18:0.004:1568.18];

%% Markers for loops:
pos                                    = 1;                                      % position marker along the fiber
cav_pos                                = 1;                                      % cavity turns marker
pump_pos                               = 1;                                      % pump power marker
stokes_pos                             = 1;                                      % multiwavelength stokes lines marker

%% Couplers:
coupler_output_1                       = Coup_1;                                    % output coupling percentage of the first cavity  
coupler_cavity_1                       = 1-Coup_1;                                  % cavity coupling percentage of the first cavity
coupler_output_2                       = Coup_2;                                    % output coupling percentage of the second cavity  
coupler_cavity_2                       = 1-Coup_2;                                  % cavity coupling percentage of the second cavity

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
Pstokes                                = zeros(turns,1);
output_1                               = zeros(turns,1);
PsL_cav_1                              = zeros(turns,1); 
PsL_cav_2                              = zeros(turns,1); 
output_2                               = zeros(turns,1);
Pp0_vector                             = zeros(1,stokes_lines_number);
Pp0 = Pp0*ganho_sym_2020(Pp0/2,Gmax, Psat)/2;
Pp0in= Pp0;
fim = 0;

for comp_onda = 1:stokes_lines_number
    if comp_onda == 2
        y = y/2;
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
                a1                 = (exp((y*PsL*Alfa*(exp(((y*Pp0-y*Pp0*exp((-Alfa*L))-(Alfa^2)*L)/Alfa)))-y*PsL*Alfa*(exp(((-y*Pp0*exp((-Alfa*L))+y*Pp0*exp((-Alfa*z))-(Alfa^2)*(L-z))/Alfa))))/Alfa^2));
                a2                 = exp((-y^2*Pp0*PsL*((expint(((-y*Pp0*(exp((-Alfa*z)))/Alfa))))+(-expint((-Pp0*y/Alfa))))*(exp(((-y*Pp0*exp((-Alfa*L))-L*Alfa^2)/Alfa)))-z*(Alfa^3))/Alfa^2);
                Ppz(cav_pos,pos)   = ((Pp0*a1*a2));
                b1                 = (exp((y*Alfa*Pp0*(exp(((-y*PsL*exp((-Alfa*(L-z)))+y*PsL*(exp((-Alfa*L)))-(Alfa^2)*(z))/Alfa)))-y*Alfa*Pp0*(exp(((y*PsL*(exp((-Alfa*L)))-y*PsL-(Alfa^2)*L)/Alfa))))/Alfa^2));
                b2                 = (exp(((-y^2*Pp0*PsL*((expint((y*PsL*(exp((-Alfa*(L-z))))/Alfa)))-(expint((PsL*y/Alfa))))*(exp(((y*PsL*exp((-Alfa*L))-L*Alfa^2)/Alfa)))-(L-z)*(Alfa^3))/(Alfa^2))));
                Psz(cav_pos,pos)   = ((PsL*b1*b2));
                fiber(:,pos)       = z;
                pos                = pos + 1;
            end
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
        end
        

        P_Stokes                   = double(real(10*log10(Psz)));            % evolution of pump power Pp(z) in dB
        P_pump                     = double(real(10*log10(Ppz)));            % evolution of Stokes power Ps(z) in dB
        Alpha_cav_dB               = 2;                                      % power loss due to cavity in dB
        Alpha_cav_linear           = 10^(Alpha_cav_dB/10);                   % power loss due to cavity in a linear scale
        Pstokes(cav_pos,1)         = Psz(cav_pos,1)/Alpha_cav_linear;        % stokes power before output coupler
        output_1(cav_pos,1)        = Pstokes(cav_pos,1)*coupler_output_1;    % output from the first cavity to the second one
        PsL_cav_1(cav_pos,1)       = Pstokes(cav_pos,1)*coupler_cavity_1;    % stokes power that returns to the cavity
        %% Second cavity:
        output_2(cav_pos,1)        = output_1(cav_pos,1)*coupler_output_2;   % output of the second cavity (laser output)
        PsL_cav_2(cav_pos,1)       = output_1(cav_pos,1)*coupler_cavity_2;   % stokes power that returns to the cavity
        %           PsL_cav_2(cav_pos,1)       = PsL_cav_2(cav_pos,1);
        %           new_input_1(cav_pos,1)     = PsL_cav_2(cav_pos,1);                   % new input in the first cavity
        cav_pos                    = cav_pos + 1;
        pos                        = 1;
    end
%     if comp_onda==1
%         output_2(cav_pos-1,1) = output_2(cav_pos-1,1)*3;
%     end
%     if comp_onda==2
%         output_2(cav_pos-1,1) = output_2(cav_pos-1,1)/1.28;
%     end
    Pot_saida(comp_onda) =  output_2(cav_pos-1,1); 
    Pot_saida_dBm(comp_onda) = 10*log10((Pot_saida(comp_onda)+1e-8)./1e-3);
    Pot_saida_dB(comp_onda) = 10*log10(Pot_saida(comp_onda));
    bombeio(comp_onda) = Pp0;
    pot_atual_bom = real(sum(bombeio)+Pp0in);
    Pp0 = PsL_cav_2(cav_pos-1,1)*ganho_sym_2020(PsL_cav_2(cav_pos-1,1)/2 + pot_atual_bom/2,Gmax, Psat)/2;
    bombeio_pre_edfa(comp_onda) = Pp0/ganho_sym_2020(PsL_cav_2(cav_pos-1,1)/2 + + pot_atual_bom/2,Gmax, Psat)+pot_atual_bom/2;
    ganho_EDFA(comp_onda) = ganho_sym_2020(PsL_cav_2(cav_pos-1,1)/2 + + pot_atual_bom/2,Gmax, Psat);    
end

if ifplot || savefig
    tit(1) = "Potência na saída do laser [mW]";
    fig(1) = figure('visible',ifplot);
    plot(1:comp_onda,Pot_saida*1e3,'o')
    ylabel(tit(1));
    
    fig(2) = figure('visible',ifplot);
    plot(1:comp_onda,bombeio*1e3,'o')
    tit(2) = "Potência entrando na cavidade Brillouin [mW]";
    ylabel(tit(2));
    
    fig(3) = figure('visible',ifplot);
    plot(1:comp_onda,Pot_saida_dBm,'o')
    tit(3) = "Potência na saída do laser [dBm]";
    ylabel(tit(3));
    
    fig(4) = figure('visible',ifplot);
    plot(1:comp_onda,real(bombeio_pre_edfa)*1e3,'o')
    tit(4) = "Potência entrando no EDFA [mW]";
    ylabel(tit(4));
    
    fig(5) = figure('visible',ifplot);
    plot(1:comp_onda,real(10.*log10(ganho_EDFA)))
    tit(5) = "ganho do EDFA [dB]";
    ylabel(tit(5));
    title(strcat('Ganho do EDFA para ', num2str(EDFA*1e3), 'mW e Pin de ', num2str(Pin*1e3), 'mW'));
end
    %%%%%%% Potencias totais em mW %%%%%%%
    Pot_saida_total = sum(real(Pot_saida))*1e3;
    Pot_antes_edfa_total = sum(real(bombeio_pre_edfa))*1e3;
    Pot_depois_edfa_total = sum(real(bombeio))*1e3;
    
    simu = real(Pot_saida)*1e3;             %mW
    
    if ifplot || savefig
        fig(6) = figure('visible',ifplot);
        plot(simu,'b', 'LineWidth', 2)
        xlabel('Wavelength (nm)','FontName','Times New Roman','FontSize',16,'FontWeight','bold')
        ylabel('Optical spectrum (u.a.)','FontName','Times New Roman','FontSize',16,'FontWeight','bold')
        %axis([1565.5 1567.5 0 1.1])
        plt = gca;
        plt.YAxis(1).Color = 'k';
        plt.XAxis(1).Color = 'k';
        set(plt.YAxis(1),'FontName','Times New Roman','FontSize',16,'FontWeight','bold');
        set(plt.XAxis(1),'FontName','Times New Roman','FontSize',16,'FontWeight','bold');
        title(strcat('EDFA = ',num2str(EDFA*1e3),'mW       Pin = ', num2str(Pin*1e3), 'mW'));
        tit(6) = "Analytical";
        
        fig(7) = figure('visible',ifplot);
        plot(simu,'b-o')
        xlabel('Stokes Line','FontName','Times New Roman','FontSize',16,'FontWeight','bold')
        ylabel('Peaks Power (mW)','FontName','Times New Roman','FontSize',16,'FontWeight','bold')
        plt = gca;
        plt.YAxis(1).Color = 'k';
        plt.XAxis(1).Color = 'k';
        set(plt.YAxis(1),'FontName','Times New Roman','FontSize',16,'FontWeight','bold');
        set(plt.XAxis(1),'FontName','Times New Roman','FontSize',16,'FontWeight','bold');
        title(strcat('EDFA = ',num2str(EDFA*1e3),'mW       Pin = ', num2str(Pin*1e3), 'mW'));
        tit(7) = "Comparison Experimental vs Analytical(mW)";
    end
    if savefig
        for i=1:length(fig)
            saveas(fig(i),strcat('../Data/EDFA_',num2str(EDFA*1e3),'mW/Pin_',num2str(Pin*1e3),'mW/',num2str(tit(i))),'jpg');
        end
    end
end