%% Buckling Analysis Code
% Group 10
% Author: Brooks Wing

function StoW = AnalyzeBuckling(x1,x2)
%% Failure Analysis Prep
% Material Dimentions
s_b = 10;                         %in    Len of loaded side of skin
s_a = 8;                          %in    Len of unloaded side of skin
s_eff_web = 1.9;                  %effective skin web width
s_eff_flange = 0.62;              %effective skin flange width
density = 0.1004339;              %lb/in^3  

%%%========Stringers========%%%
% Material Dimentions
b_ss = 3.72; b_sf = 1.28;     %in
% f_Kc = 0.47;                %FLANGE coefficient from C5.2 wrt BC and Aspect Ratio
% w_Kc = 4;                   %WEB    coefficient from C5.2 wrt BC and Aspect Ratio
%   Channel Section
% c_g = 5;
c_le = s_a;                %in    Effective Length (S-S), Le=L

% Material Properties (General)
E = 10.7*10^6;              %psi
nu = 0.3;                   %Poisson's Ratio
sig_07 = 39 * 10^3;         %psi 
sig_cy = 40 * 10^3;         %psi Compressive Yield Strength
sig_lim = 0.9*sig_cy;       %psi From Table 7.1 0.9 * sig_cy
n = 11.5;
t = 0.032;                  %in **Monolithic thickniss is approx same
p_weight = 3*(2*(x1*t*s_a*density) + x2*t*s_a*density) + t*s_b*s_a*density;           %lb (Brooks' Panel)

%%%==========Skin==========%%%
K_ss = 4;    %S-S skin all sides with 4/5 AR (Figure C5.2)

%%%
c_area =  2*x1*t + x2*t;   %in^2 (Cross Sectional Area of Channel Section)



% %   Monolithic Section
% m_g = 7 + (2/3);
% m_area = c_area + (t*b_ss);%in^2 (Cross Sectional Area of Monolithic)

% Calculate Moment of Inertia about X-X axis (for symmetric, == 0.5*x2)
% Centroids and Areas for each rectangle
y1 = 0.5*t;         A1 = x1*t;
y2 = 0.5*x2 + t;    A2 = t * x2;
y3 = x2 + 1.5*t;    A3 = A1;
y_c = (y1*A1 + y2*A2 + y3*A3)/(A1 + A2 + A3); %Centroid y coordinate

Ixx1 = (1/12)*x1*t^3 + A1*(x2/2 + t/2)^2;
Ixx2 = (1/12)*t*x2^3;
Ixx3 = Ixx1;

Ix_s = Ixx1 + Ixx2 + Ixx3;  %in^4
rho = (Ix_s/c_area)^0.5;    %in    Radius of Gyration

%%%========Fasteners========%%%
% r_c = 2;               %Cherry rivet end fixity

%% (A) Crippling Strength for each stringer vs monolithic stringer
%%%======Stringer Strength======%%%
% Our stringer is a Channel Section (Type 3)
c_crip = sig_cy*3.2*((t^2/c_area)*(E/sig_cy)^(1/3))^0.75;
if c_crip >= sig_lim
   c_crip = sig_lim; 
end
% c_crip_load = c_crip * c_area;
% % fprintf('Channel Section Crippling Load: %5f lb\n', c_crip_load)
% 
% %%%=====Monolithic Stringer=====%%%
% % Comparable Monolithic Sections (Type1)
% m_crip = sig_cy*0.56*(((m_g*t^2)/m_area)*(E/sig_cy)^0.5)^0.85;
% if m_crip >= sig_lim
%    m_crip = sig_lim; 
% end
% m_crip_load = m_crip * m_area;
% fprintf('Monolithic Section Crippling Load: %5f lb\n', m_crip_load)

%% (B) Column Buckling (Elastic and Inelastic) for smaller crippling load
% Smallest Crippling Load == Channel Section
%-------------------------------------------
% Johnson-Euler Stress
c_je = c_crip - ((c_crip)^2/(4*pi^2*E))*(c_le/rho)^2;
% c_je_load = c_je * c_area;
% fprintf('Johnson-Euler Buckling Load: %5f lb\n', c_je_load)

% If Johnson-Euler Stress is > (Crippling Stress/2) and < (, then the column is of
% intermediate length and will fail by mix of local crippling and buckling.
%
% If Johnson-Euler Stress is < (Crippling Stress/2) check if elastic
% buckling or inelastic buckling.
% Failure Mode:
%   0 == Elastic
%   1 == Local Crippling and Buckling
%   2 == Crippling
f_mode = 0;
if (c_je < c_crip) && (c_je > c_crip/2)
    f_mode = 1;
elseif (c_je > c_crip)
    f_mode = 2;
end

% Dictate which what the failure stress/load for stringers are
if f_mode == 0
%     fprintf('.....Euler Failure.....\n')
    c_fail = (pi^2*E)/(c_le/rho)^2;
elseif f_mode == 1
%     fprintf('.....Johnson Euler Failure.....\n')
    c_fail = c_je;
else
%     fprintf('.....Cripple Failure.....\n')
    c_fail = c_crip; 
end
% c_fail_load = c_fail * c_area;
% fprintf('Single Stringer Failure Load: %5f lb\n', c_fail_load)

%% (C) Calculate Effective Skin Width
% Calculate Buckling Load for S-S skin (Same as S-F skin in this case)
% p_A = 3*c_area + s_b*t;                                %CS area for panel
% s_crit = K_ss*((pi^2*E)/(12*(1-nu^2)))*(t/b_ss)^2;
% s_crit_load = s_crit*p_A;
% fprintf('Skin Buckling Load: %5f lb\n', s_crit_load)

% The skin will fail before the combined stringers will (Make c_fail the
% p_fail)
p_fail = c_fail;    % Panel Failure stress
% Therefore we need to get effective lengths for after the skin buckles
% At pnt of failure, each stiffener can carry p_fail stress
w = s_eff_web*t*(E/p_fail)^0.5;

if w > b_ss
    StoW = -Inf;
    return
end
w_star = s_eff_flange*t*(E/p_fail)^0.5;

if w_star > b_sf
   StoW = -Inf;
   return
end

% Get total effective width for panel
w_tot = w + 2*(w/2) + 2*w_star;

% Get Failure Load
A_eff = w_tot*t + 3*c_area;
p_fail_load = p_fail * A_eff;
% fprintf('Panel Failure Load: %5f lb\n', p_fail_load)

%% (D and E) Find fastener spacing by using inelastic inter-rivet buckling stress
% Et = E*(1/(1+(3/7)*(n)*(p_fail/sig_07)^(n-1))); %Tangent Modulus of Elasticity for IE fasteners
% spacing = t/(p_fail/(0.822*r_c*Et))^0.5;
% fprintf('Cherry Rivet Spacing: %5f in\n', spacing)

%% (F) Analyze Local Buckling of Stringers (epsilon = 0 => SS support for plate)
% For checking for Elasticity of calculated stress, I follow exercise 4
% from HO-4 in for the local analysis. Uses Ramberg-Osgood formula to
% closely match C5.7.
%I use 0.7 as my ratio cutoff for elastic behavior for n is ~= 10
%I use 1.45 and 1.05 like the original code though.
%if the ratio is inbetween i use the linear relationship described in the
%fortran code also.

% % Web Local Buckling
% w_loc_crit = w_Kc*(pi^2*E)/(12*(1-nu^2))*(t/x2)^2;    %Initial Web local critical stress
% w_ratio_calc = w_loc_crit / sig_07;                   %Calc Ratio to see if Elastic
% if w_ratio_calc < 0.7
%     tmp_crit = w_loc_crit;
% elseif w_ratio_calc > 0.7 && w_ratio_calc < 1.45
%     tmp_crit = (0.7 + ((1.05 - 0.7)/(1.45 - 0.7))*(w_ratio_calc-0.7))*sig_07;
% else %> 1.45
%     tmp_crit = 1.05*sig_07;
% end
% w_loc_load = tmp_crit*c_area;
% 
% % Flange Local Buckling
% f_loc_crit = f_Kc*(pi^2*E)/(12*(1-nu^2))*(t/x1)^2;    %Initial flange local crit stress
% f_ratio_calc = f_loc_crit / sig_07;
% if f_ratio_calc < 0.7
%     tmp_crit = f_loc_crit;
% elseif f_ratio_calc > 0.7 && f_ratio_calc < 1.45
%     tmp_crit = (0.7 + ((1.05 - 0.7)/(1.45 - 0.7))*(f_ratio_calc-0.7))*sig_07;
% else %> 1.45
%     tmp_crit = 1.05*sig_07;
% end
% f_loc_load = tmp_crit*c_area;
% 
% % Check which section buckles first
% if f_loc_load < w_loc_load
%     loc_load = f_loc_load;
% %     fprintf('Local Buckling @ Flange: %5f lb\n', loc_load)
% else
%     loc_load = w_loc_load;
% %     fprintf('Local Buckling @ Web: %5f lb\n', loc_load)
% end

%% Strength to Weight for Panel
StoW = (p_fail_load)/p_weight;
% fprintf('Strength to Weight Ratio: %5f \n', StoW)