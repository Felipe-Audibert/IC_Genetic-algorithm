function [pks480, Pot_saida_dBm] = cascateado(varargin)  
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

if length(Pop)==4
    ganho = [Pop(1) Pop(2) Pop(3) Pop(4)];
    Coup_1 = 0.2;
    Coup_2 = 0.19;
elseif length(Pop)==6
    ganho = [Pop(1) Pop(2) Pop(3) Pop(4)];
    Coup_1 = Pop(5);
    Coup_2 = Pop(6);
else
    error('Wrong Pop vector length');
end

if not(ischar(savefig)) && not(isstring(savefig))
   savefig = ''; 
end

%% Finding Workspace number %%
Vec_EDFA                                = [0.12 0.15 0.17 0.2 0.22 0.25 0.28];
Vec_Pin                                 = [1 0.43 0.68 4.01 14].*1e-3;
Workspaces                              = [1:7; 9:15; 16:22; 25:31; 32:38];

lin_EDFA                                = find(Vec_EDFA==EDFA);
col_Pin                                 = find(Vec_Pin==Pin);

if      isempty(col_Pin)
    error('Value of Pin is not available');
elseif      isempty(lin_EDFA)
    error('Value of EDFA is not available');
else
end

Num_Workspace                           = Workspaces(col_Pin,lin_EDFA);
Workspace_Name                          = sprintf('Workspace_%.3d',Num_Workspace);

    file_path = strcat('../1565nm_BP_',num2str(Pin*1e3),'mW', '/', Workspace_Name, '.mat');

pot = [];
 
%% Load new data (Dudu)
load(file_path)

Lambda = eval(['Lambda' num2str(Num_Workspace)]);
Power = eval(['Power' num2str(Num_Workspace)]);
    

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
turns                                  = 5;                                      % number of cavity turns in the fiber
round_trips                            = (1:turns)';                             % round trips inside of the cavity   
stokes_lines_number                    = 18;                                     % number of output sotkes channels
Pp0                                    = Pin;                                    % Potencia bombeio inicial [W]

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
Pp0 = Pp0*ganho_simples(Pp0/2,ganho)/2;
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
    Pp0 = PsL_cav_2(cav_pos-1,1)*ganho_simples(PsL_cav_2(cav_pos-1,1)/2 + pot_atual_bom/2,ganho)/2;
    bombeio_pre_edfa(comp_onda) = Pp0/ganho_simples(PsL_cav_2(cav_pos-1,1)/2 + + pot_atual_bom/2,ganho)+pot_atual_bom/2;
    ganho_EDFA(comp_onda) = ganho_simples(PsL_cav_2(cav_pos-1,1)/2 + + pot_atual_bom/2,ganho);    
end

if ifplot || not(strcmp(savefig, ''))
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
    
    %% Find peaks (envelope) in experimental data:
    Power= 10*log10((Power)/1e-3);      %Convert Power to dBm
    [pks480,locs480]                        = findpeaks(real(Power(405:end-200)),Lambda(405:end-200),'MinPeakDistance',(Lambda(2)-Lambda(1))*19);

    L1 = 10.^(real(pks480-max(pks480))/10);
    aux = real(Pot_saida_dBm)-max(real(Pot_saida_dBm));
    aux = aux.';
    L2 = 10.^(aux/10);
    
    P1 = 10.^(real(Power)/10);
    %P2 = 10.^(real(Pot_saida_dBm)/10);
    Pot1 = trapz(Lambda,P1);
    %Pot2 = trapz(Lambda,P2);
   
    num = length(Lambda);
    delta_lambda = Lambda(num)-Lambda(1);
    eixo_x = linspace(-37*pi,37*pi,num);
    osa_simulado = zeros(1,num);
    ajuste = (mean(Lambda)-locs480(1))*74*pi/delta_lambda;
    eixo_y = sech(eixo_x + ajuste).^2;
    eixo_y = eixo_y*max(P1);
    
    for tt=1:stokes_lines_number
        ajuste = (mean(Lambda)-locs480(tt))*74*pi/delta_lambda;
        eixo_y(tt,:) = sech(eixo_x + ajuste).^2;
        eixo_y(tt,:) = eixo_y(tt,:)*L2(tt);
        osa_simulado = eixo_y(tt,:) + osa_simulado;
    end
    
    pot = locs480-10:locs480+10;
    
    for i=[1:length(locs480)]
        x = find(Lambda==locs480(i));
        testando(i) = trapz(Lambda(x-15:x+15),Power(x-15:x+15));
    end
    
    experimental = 10.^(pks480./10);            %Power em mW
    simu = real(Pot_saida)*1e3*10;           %
    exp_r = experimental(2:end);
    simu_r = simu(2:end);
    
    exp_norm = P1/max(P1);

    
    if ifplot || not(strcmp(savefig, ''))
        fig(6) = figure('visible',ifplot);
        plot(Lambda,exp_norm,'r', 'LineWidth', 2)
        hold on
        plot(Lambda,osa_simulado,'b', 'LineWidth', 2)
        xlabel('Wavelength (nm)','FontName','Times New Roman','FontSize',16,'FontWeight','bold')
        ylabel('Optical spectrum (u.a.)','FontName','Times New Roman','FontSize',16,'FontWeight','bold')
        legend('Experimental','Analytical solution','FontSize',16,'FontWeight','bold')
        axis([1565.5 1567.5 0 1.1])
        plt = gca;
        plt.YAxis(1).Color = 'k';
        plt.XAxis(1).Color = 'k';
        set(plt.YAxis(1),'FontName','Times New Roman','FontSize',16,'FontWeight','bold');
        set(plt.XAxis(1),'FontName','Times New Roman','FontSize',16,'FontWeight','bold');
        title(strcat('EDFA = ',num2str(EDFA*1e3),'mW       Pin = ', num2str(Pin*1e3), 'mW'));
        subtitle(print_pop(ganho));
        tit(6) = "Comparison Experimental vs Analytical";
        
        fig(7) = figure('visible',ifplot);
        plot(experimental,'r-o')
        hold on
        plot(simu,'b-o')
        xlabel('Stokes Line','FontName','Times New Roman','FontSize',16,'FontWeight','bold')
        ylabel('Peaks Power (mW)','FontName','Times New Roman','FontSize',16,'FontWeight','bold')
        legend('Experimental','Analytical solution','FontSize',16,'FontWeight','bold')
        plt = gca;
        plt.YAxis(1).Color = 'k';
        plt.XAxis(1).Color = 'k';
        set(plt.YAxis(1),'FontName','Times New Roman','FontSize',16,'FontWeight','bold');
        set(plt.XAxis(1),'FontName','Times New Roman','FontSize',16,'FontWeight','bold');
        title(strcat('EDFA = ',num2str(EDFA*1e3),'mW       Pin = ', num2str(Pin*1e3), 'mW'));
        subtitle(print_pop(ganho));
        tit(7) = "Comparison Experimental vs Analytical(mW)";
    end
    if not(strcmp(savefig, ''))
        mkdir(strcat(savefig))
        for i=1:length(fig)
            saveas(fig(i),strcat(savefig, '\', tit(i), '.jpg'));
        end
    end
end