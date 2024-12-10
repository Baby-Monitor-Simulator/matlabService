clear randinter contrstrength conrise condecay contrlength j_contrstart j_contrstop
fpcon=zeros(1,4e5)+fprest;
con=0;
for j=1:4e5;
% Update changes in Variable Decelerations
fpcon0=70*facHgkPa;  %fpcon = externe druk
fpcon1=100*facHgkPa;
Pfbrmc0=14.8;
c_R1=6e3; % max waarbij vat dicht zit.
c_R2=0.15; %steilheid
c_R3=6e3;
c_R4=.06;

if con==0
    con=1;                                                  % Contraction number
    %scaledepth(con)= 0.6;%normrnd(15,7)/30;                % Random normalised gaussian depth of decel 
    randinter(con)=1000*round(60/dt);           % Random gaussian contraction interval in ic's
    contrstrength(con)=90*facHgkPa;                  % Random gaussian contraction strength in mmHg
    contrlength(con)=1000*round(60/dt);          % Random gaussian contraction length in ic's
    conrise(con)=round(1/4*contrlength(con));
    condecay(con)=3*conrise(con);
    j_contrstart(con)=round(43*mtcycle(1));               % Start time of contraction after about 30 maternal beats
    j_contrstop(con)=j_contrstart(con)+contrlength(con);  % Stop time of contraction
    W_v=1;
end
    %fprest=fpcon(1) fpcon = externe druk
    % Umbilical pressure 
if j>j_contrstart(con) && j<=j_contrstart(con)+conrise(con);%j_contrstop(con)
    fpcon(j)=fprest+contrstrength(con)*sin(pi/(2*conrise(con))*(j-j_contrstart(con))).^2;
elseif j>j_contrstart(con)+conrise(con)&& j<=j_contrstop(con)
    fpcon(j)=fprest+contrstrength(con)-contrstrength(con)*sin(pi/(2*condecay(con))*(j-(j_contrstart(con)+conrise(con)))).^2;
end

% if icycle>oxcycle
%     vag_comp0(j)=max(0,(Pfbrmc0-Pfbrmc(ico-1))/(0.2*Pfbrmc0)); % Ergo max of 20% is responsible for 30 bpm decrease in FHR
%     vag_comp(j)=(vag_comp(j-1)*tau_V+vag_comp0(j)*dt)/(tau_V+dt);
% end

    % New compression calculation
if j==j_contrstop(con)+randinter(con)
    con=con+1;                                              % Contraction number
        %scaledepth(con)=min(1,normrnd(scaledepth(1)*30,1)/30);                    % Random normalised gaussian depth of decel 
    randinter(con)=round(normrnd(randinter(1)*dt,10000)/dt);               % Random gaussian contraction interval in j's
    contrstrength(con)=normrnd(contrstrength(1),8*facHgkPa);  
    contrlength(con)=round(normrnd(contrlength(1)*dt,5000)/dt);          % Random gaussian contraction length in j's
    conrise(con)=round(1/4*contrlength(con));
    condecay(con)=3*conrise(con);
    j_contrstart(con)=j+1;
    j_contrstop(con)=j_contrstart(con)+contrlength(con);   % Stop time of contraction                                       
    W_v=1;
    
end
end
figure; plot(fpcon)