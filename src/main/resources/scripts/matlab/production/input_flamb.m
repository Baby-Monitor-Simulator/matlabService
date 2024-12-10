% FMP model
fRpVar      = 0;
fBreathing  = 0;             % breathing (1) or not (0)
fBaroReg    = 0;             % baroreceptors on (1) or off (0)
fLungReg    = 0;             % lung stretch receptors on (1) or off (0)
fVagatomy   = 0;             % vagatomy (1) or not (0)

fReg        = 0;
if fBaroReg==1 || fLungReg ==1
    fReg=1;
end

npext=0;
nseg=0;
ncav=0;
nnodes=0;
fcycle=1;
facHgkPa=133/1000;
fackPaHg=1/facHgkPa;
ftstart=0;
fjstart=0;

% --- timing and convergence
fHR             = 160;                  % [bpm] - heart rate
if scen==2; fHR=160; end
ftcycle         = round((60/fHR)*1000); % [ms] - duration cardiac cycle
fTvs            = 0.3*ftcycle+160;      % [ms] - duration activation ventricle
if foetus==1 && mother==0
    dt          = 1;                % [ms] - time step
    ncyclemax   = 100;              % [-] - maximum number of cycles to find equilibrium
    ncyclemin   = 10;               % [-] - minimum number of cycles before checking on equilibrium
    ncycleplot  = 2;                % [-] - number of cycles to be plotted
    Verrormax   = 0.0001;           % [-] - maximum relative volume error allowed
    nmax        = ceil(1.2*ncyclemax*ftcycle/dt);         % [-] - number of increments
end

% --- ventricles and atria
if CAVmodel==1
    fElv_min    = 2.05;            % [mmHg/ml] - passive elastance LV     
    fElv_max    = 53.1;            % [mmHg/ml] - maximum elastance LV     
    fClv        = 1/fElv_min;      % [ml/mmHg] - passive compliance LV

elseif CAVmodel==2 
    fcontrac    = 1;
    fcntr       = 0;
    fClv        = 0.75;       % [ml/mmHg] - dummy compliance LV

 % material properties
    fVw=18;             % [ml] - LV wall volume
    fVlv0=fVw/3;        % [ml] - LV reference cavity volume
    fVlv(1)=fVlv0;      % [ml] - initial estimated LV volume
    hh=0.5;
    kk=0.5;
    
    fls0     = 2;     % [um] - reference sarcomere length
    fsf0     = hh*0.6;     % [kPa] - reference passive fiber stress
    fsr0     = hh*0.15;    % [kPa] - reference passive cross-fiber stress
    fcf      = 12;    	% [-] - curvature of fiber stress-length relation
    fcc      = 9;    	% [-] - curvature of cross-fiber stress-length relation

    fTa0     = hh*150;     % [kPa] - scaling parameter for active stress
    fca      = 1;       % [-] - curvature of active stress-length relation
    flsa0    = 1.5;     % [um] - sarcomere length with zero active stress
    flsa1    = 2.0;     % [um] - reference sarcomere length for active stress
    ftaur1   = kk*150; % [ms] - 'rise time' active stress for ls = lsa1
    ftaud1   = kk*250; % [ms] - 'decay time' active stress for ls = lsa1
    far      = kk*100; % [ms/um] - length dependence of rise time
    fad      = kk*400; % [ms/um] - length dependence of decay time
    fbd      = 0.07;    % [s.s] - frequency dependence of decay time
    fHR0     = 0.5/kk;     % [1/s] - reference frequency for freq dependence
    fv0      = 0.05; 	% [um/ms] - unloaded shortening velocity
    fcv      = 0.0;	 	% [-] - curvature of stress-velocity relation

end

% --- unstressed volumes
fVtotal   = 330;%405;        % [ml] - total blood volume: 3kg *110 ml/kg  
fV0lv     = 5;%6;          % [ml] - intercept volume LV
fVa0      = 20;%24;       % [ml] - systemic arterial intra thoracic node 
fVv0      = 100;%122;       % [ml] - systemic arterial extra thoracic node 

% --- resistances

fRp  = 310;             % [kPa.ms/ml] - systemic arterial extra thoracic segment
fRa  = 0.03*fRp;        % [kPa.ms/ml] - aortic valve + systemic arterial intra thoracic segment   
fRv  = 0.15*fRp;        % [kPa.ms/ml] - mitral valve resistance
fCa  = 2;             % [ml/kPa] - systemic arterial intra thoracic node 
fCv  = 35;              % [ml/kPa] - systemic arterial extra thoracic node 
fLa  = 2;              % [kPa.ms^2/ml] - extrathoracic blood flow inertia

facven = 10;                % factor of resistance increase to backflow in venous segment
facval = 10^6;              % factor of resistance increase to backflow in valve

ffRpmin   = 0.01;           % minimum frequency of Rep variation
ffRpmax   = 0.40;           % maximum frequency of Rep variation
ffRpstep  = 0.01;
fRp1      = fRp/2;          % amplitude of Rep variation
ffRp      = ffRpmin:ffRpstep:ffRpmax;
fnRp      = length(ffRp);
fphiRp    = 2*pi*randn(1,fnRp);

% --- external pressures
fp_ref =[];

fpext   = [0; 0];              % external pressures

% --- nodal data in mandatory format [ inod C V0 ipc ipe ] with
% ipc = 1 (plv), 2 (prv), or 0
% ipe = 1 (pth), 2 (pab), or 0
% cavities should be given a non-zero compliance

fnoddata = [
 nnodes+1  fClv  fV0lv  ncav+1  1 ;
 nnodes+2  fCa   fVa0   0       1 ;
 nnodes+3  fCv   fVv0   0       1 ;
 ] ;

nflv  =  nnodes+1;       % LV node
nfa   =  nnodes+2;       % systemic arterial intrathoracic node
nfv   =  nnodes+3;       % systemic arterial extrathoracic node

% --- segment data in mandatory format[ iseg nod1 nod2 R L ]  

fsegdata = [
 nseg+1  nnodes+1  nnodes+2  fRa  fLa ;
 nseg+2  nnodes+2  nnodes+3  fRp   0  ;
 nseg+3  nnodes+3  nnodes+1  fRv   0  ;
 ]; 
                
sfa  =  nseg+1;         % arterial segment
sfp  =  nseg+2;         % peripheral segment
sfv  =  nseg+3;         % venous segment

nnodes=  max(fnoddata(:,1));
nseg  =  max(fsegdata(:,1));

% --- cavity (ventricle and atrium) data in user defined format dependent
%     on cavity model, to be used in user m-file u_pcav. 
%     This format: [ icav Emax Emin V0 Tsystole Tdelay ]
if CAVmodel==1
    fcavdata = [
     ncav+1  fElv_max  fElv_min  fV0lv fTvs 0 ;
     ];
    fncav=numel(fcavdata(:,1));
elseif CAVmodel==2
    fcavdata = [
    1  fVw  fV0lv fls0 fsf0 fsr0 fcf fcc fTa0 fca flsa0 flsa1 ftaur1 ftaud1 far fad fbd fHR/60 fHR0 fv0 fcv
    ];
end

% --- scenarios

if umbilical==1
    Vum0    = 90;%110;
    Cum     = 11;
    Rummc    = 1.39*fRp;
    Rumv   = 0.01*fRp;
    
    % extend segdata
    fsegdata = [fsegdata;
     nseg+1  nfa      nnodes+1  Rummc   0 ;
     nseg+2  nnodes+1   nfv     Rumv  0 ;
    ]; 
    
    % extend segment nrs
    summc  = nseg+1;
    sumv = nseg+2;
    
    nseg  =  max(fsegdata(:,1));
    
    % extend noddata
    fnoddata = [ fnoddata;
     nnodes+1  Cum  Vum0  0  2 ;
     ] ;
 
    % extend node nrs
    num = nnodes+1;
    
    nnodes=  max(fnoddata(:,1));
elseif umbilical==2
    Vuma0    = 10;    %volume gaat af van arteriele volume: 1:4
    Vumv0    = 80;%100;    %identiek  
    Cuma     = 0.5;  % gaat af van art. compliantie   
    Cumv     = 10.5;
    Ruma    = 0.39*fRp;   %opzoeken!! verhouding R, som identiek aan normaal
    Rummc   = 1.00*fRp;
    Rumv    = 0.01*fRp;
        
    % extend segdata
    fsegdata = [fsegdata;
     nseg+1  nfa      nnodes+1  Ruma  0 ; 
     nseg+2  nnodes+1 nnodes+2  Rummc  0 ;
     nseg+3  nnodes+2 nfv       Rumv 0
     ]; 
    
    % extend segment nrs
    suma  = nseg+1;
    summc = nseg+2;
    sumv  = nseg+3;
    nseg  = max(fsegdata(:,1));
    
    % extend noddata
    fnoddata = [ fnoddata;
     nnodes+1  Cuma  Vuma0  0  2 ; 
     nnodes+2  Cumv  Vumv0  0  2
     ] ;
 
    % extend node nrs
    numa = nnodes+1;
    numv = nnodes+2;
        
    num = nnodes+1;
    
    
    nnodes=  max(fnoddata(:,1));
end

if brain==1
    Vbr0    = 7.2;%9;
    Cbr     = 0.57;         %from Pennati
    Rbrmc    = 13.99*fRp;
    Rbrv   = 0.01*fRp;
    
    % extend segdata
    fsegdata = [fsegdata;
     nseg+1  nfa        nnodes+1  Rbrmc   0 ;
     nseg+2  nnodes+1   nfv       Rbrv  0 ;
     ]; 
    
    % extend segment nrs
    sbrmc  = nseg+1;
    sbrv = nseg+2;
    
    nseg  =  max(fsegdata(:,1));
    
    % extend noddata
    fnoddata = [ fnoddata;
     nnodes+1  Cbr  Vbr0  0  2 ;
     ] ;
 
    % extend node nrs
    nbr = nnodes+1;
    %nbrv = nnodes+2;
    
    nnodes=  max(fnoddata(:,1));
end

% --- breathing

fTresp   = 1270;            % [ms]      - respiratory period, fetus 1.27 s (timor-tritsch 1980)
fTi      = fTresp*0.45;     % [ms]      - inspiration duration, adult 2s?
fTe      = fTresp*0.55;     % [ms]      - expiration duration, adult 2s?
fpthmin  = -3*facHgkPa;     % [mmHg]    - minimum thoracic pressure
fpthmax  = 0*facHgkPa;      % [mmHg]    - maximum thoracic pressure   
fpabmin  = -2.5*facHgkPa;   % [mmHg]    - minimum abdominal pressure  
fpabmax  = 0;               % [mmHg]    - minimum abdominal pressure  

% --- regulation 

if fReg==1 && CAVmodel==1
    ftheta(1:5,:)     = [ fRp  fVv0  fElv_max    0  0 ]';
    reg_input_f
elseif fReg==1 && CAVmodel==2
    ftheta(1:5,:)     = [ fRp  fVv0  fTa0    0  0 ]';
    reg_input_f
end

% process input

fnseg = size(fsegdata,1);     % number of segments
fnnod = size(fnoddata,1);     % number of nodes
fnpc  = size(fcavdata,1);     % number of cavity pressures
fnpe  = size(fpext,1);        % number of external pressures

fR    = fsegdata(:,4);        % segment resistances
fLt   = fsegdata(:,5)/dt;     % segment inertances 

fC    = fnoddata(:,2);        % nodal complances
fV0   = fnoddata(:,3);        % nodal unstresses volumes

flio = zeros(fnseg,fnnod);     % logical input-output matrix for determining nodal flow

for inod=1:fnnod
    for iseg=1:fnseg
        if fsegdata(iseg,2)==inod
            flio(iseg,inod)=-1;
        end
        if fsegdata(iseg,3)==inod
            flio(iseg,inod)=1;
        end
    end
end

flpc = zeros(fnpc,fnnod); % logical cavity pressure selection matrix

for inod = 1:fnnod
    for ipc = 1:fnpc
        if fnoddata(inod,4)==ipc
            flpc(ipc,inod)=1;
        end
    end
end

fllpc=sum(flpc,1);

flpe = zeros(fnpe,fnnod); % logical external pressure selection matrix

for inod = 1:fnnod
    for ipe = 1:fnpe
        if fnoddata(inod,5)==ipe
            flpe(ipe,inod)=1;
        end
    end
end