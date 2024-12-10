% u_reg_input
%
% input for regulatory model: Table 1, Ursino 2003
%
%-----------------------------------------------------

% --- Rep

ffac_Rp     = 0.35*fRp;         % [kPa.ms/ml] - amplitude of max and min mRp
fGa_Rp      = 0.1/facHgkPa;     % [kPa^-1] intact
fGp_Rp      = 0;                % [l^-1]
fmax_Rp     = fRp*1.25;%ffac_Rp;      % [kPa*ms/ml]
fmin_Rp     = fRp*0.65;%-ffac_Rp;      % [kPa*ms/ml]
fD_Rp       = 3000;             % [ms]
ftau_Rp     = 1500;             % [ms]

if fVagatomy==1; 
    fGa_Rep  = 0.04*facHgkPa;   % [mmHg^-1] vagatomized
    fGp_Rep  = 0;               % [l^-1]
end

% --- Vuv

ffac_Vuv    = 0.22*fVv0;        % [ml] - amplitude of max and min mVv
fGa_Vuv     = 10.8/facHgkPa;    % [kPa^-1]
fGp_Vuv     = 0;                % [l^-1]
fmin_Vuv    = fVv0-ffac_Vuv;    % [ml]
fmax_Vuv    = fVv0+ffac_Vuv;    % [ml]
fD_Vuv      = 5000;             % [ms]
ftau_Vuv    = 10000;            % [ms]

if CAVmodel==1
    
    % --- Emaxlv: NB in mmHg instead of kPa

    fGa_Emaxlv   = 0.012;       % [mmHg^-1]
    fGp_Emaxlv   = 0;           % [l^-1]
    fmin_Emaxlv  = 1.0;         % [mmHg/ml]
    fmax_Emaxlv  = 3.0;         % [mmHg/ml]
    fD_Emaxlv    = 2000;        % [ms]
    ftau_Emaxlv  = 1500;        % [ms]
elseif CAVmodel==2
    
    % --- Ta0, now referred to as Emax_lv to build mtheta
    
    ffac_Emaxlv  = 0.5*fTa0;    % [kPa] - amplitude of max and min mTa0
    fGa_Emaxlv   = 1;           % [kPa^-1] empirically determined: fluctuations +6% and -12%
    fGp_Emaxlv   = 0;           % [l^-1]
    fmin_Emaxlv  = fTa0-ffac_Emaxlv;   % [-]
    fmax_Emaxlv  = fTa0+ffac_Emaxlv;   % [-]
    fD_Emaxlv    = 2000;        % [ms]
    ftau_Emaxlv  = 1500;        % [ms]
end

% --- T

fGa_Tv       = 0.028/facHgkPa;  % [kPa^-1]
fGp_Tv       = .25;             % [l^-1]
fD_Tv        = 500;             % [ms]
ftau_Tv      = 800;             % [ms]

fGa_Ts       = 0.015/facHgkPa;  % [kPa^-1]
fGp_Ts       = 0;               % [l^-1]
fD_Ts        = 3000;            % [ms]
ftau_Ts      = 1800;            % [ms]


ffac_T       = 178;             % [ms] - amplitude of max and min fT
fmin_T       = ftcycle(1)-ffac_T;   % [ms]
fmax_T       = ftcycle(1)+ffac_T;   % [ms]
fkT          = (fmax_T-fmin_T)/4000;% [ms]

if fVagatomy==1
    fGa_Tv   = 0;            % [mmHg^-1]
    fGa_Ts   = 0.006;        % [mmHg^-1]
end

% store feedback parameters: note negative value inserted for Gp_Tv !

fGa_theta    = [ fGa_Rp          fGa_Vuv          fGa_Emaxlv      fGa_Ts   fGa_Tv  ];
fGp_theta    = [ fGp_Rp          fGp_Vuv          fGp_Emaxlv      fGp_Ts   fGp_Tv  ];
fmax_theta   = [ fmax_Rp         fmax_Vuv         fmax_Emaxlv     0        0  ];
fmin_theta   = [ fmin_Rp         fmin_Vuv         fmin_Emaxlv     0        0  ];
fD_theta     = [ fD_Rp           fD_Vuv           fD_Emaxlv       fD_Ts    fD_Tv   ];
ftau_theta   = [ ftau_Rp         ftau_Vuv         ftau_Emaxlv     ftau_Ts  ftau_Tv ];

% --- derived quantities

fk_theta     = (fmax_theta-fmin_theta)/4;
fk_theta(1)  = -fk_theta(1)/1000;    % decreasing R sigmoid; from s to ms
fk_theta(3)  = -fk_theta(3);         % decreasing Emax sigmoid; from s to ms

ftheta0      = (fmax_theta+fmin_theta)/2;
ftheta0(1)=fRp;
% --- setpoints

fpsan        = 40*facHgkPa;           % [mmHg]
fVLn         = 2.3;          % [l]

% --- end u_reg_input