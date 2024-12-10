%Chemo Ursino am j heart circ physiol 2000;279:H149-165

if ico==2
    %constants
    %ts= 0.5557;     %[s] zou tso moeten zijn
    facmin=         1.16;   %[spikes/s]
    facmax=         17.07;  %[spikes/s]
    PO2n=           18;       %45[mmHg]
    k_ac=           7.24;   %29.27/95= k_ac/23[mmHg]
    tau_c=          2;       %[s]
    f_esinf=        2.1;   %[spikes/s]
    f_es0=          16.11;   %[spikes/s]
    f_esmin=        2.66;  %[spikes/s]
    f_espmin=       13;
    f_esmax=        60;    %[spikes/s]
    k_es=           0.0675;   %[s]
    f_evinf=        6.3;   %[spikes/s]
    f_ev0=          3.2;     %[spikes/s]
    f_ab0=          25;      %[spikes/s]
    f_abmin=        2.52;   %[spikes/s]
    f_abmax=        47.78;  %[spikes/s]
    pn=             40.;          %[mmHg]
    k_ab=           4.09;      %[11.76/92=k_ab/32 mmHg]
    k_ev=           7.06;    %[spikes/s]
    W_bsp=          1;   
    W_csp=          5;
    W_psp=          0.34;
    W_bsh=          1;   
    W_csh=          1;   
    W_cv=           0.2;
    W_pv=           0.103;
    theta_v=        -0.68;   %[spikes/s]
    fi_ac0=         (facmax+facmin*exp(0))/(1+exp(0));
    f_ac(1:2)=      fi_ac0; 
    f_ab(1:omax)=   25;     %[spikes/s] is SS
    f_ap(1:omax)=   0.583*23.29;  %[spikes/s] is SS from VT0 and G_ap 
    chi_minsp=      7.33;    %[spikes/s]
    chi_maxsp=      13.32;   %[spikes/s]
    tau_isc=        30;        %[s]
    k_iscsp=        2;         %[mmHg]
    PO2nsp=         7.57;       %30/95 = 7.58/24 [mmHg] 
    chi_minsh=      -49.38;  %[spikes/s]
    chi_maxsh=      3.59;    %[spikes/s]
    k_iscsh=        6;         %[mmHg]
    PO2nsh=         11.36;      %45/95 = 11.13/24 [mmHg]
    PfO20=          PO2n;          %[mmHg]
    chi_sp0=        (chi_minsp+chi_maxsp*exp((PfO20-PO2nsp)/k_iscsp))/(1+exp((PfO20-PO2nsp)/k_iscsp));
    theta_sp(1:2)=  chi_sp0;
    chi_sh0=        (chi_minsh+chi_maxsh*exp((PfO20-PO2nsh)/k_iscsh))/(1+exp((PfO20-PO2nsh)/k_iscsh));
    chi_sh(1:2)=    -10.45;
    theta_sh(1:2)=  -10.45;
    tau_pb=         2.076;      %[s]
    tau_zb=         6.37;       %[s]
    pwig(1:2)=        pn;         %[mmHg] is ss pwig, which equals MAP
    tau_Ts=         2;          %[s]
    tau_Tv=         1.5;        %[s]
    tau_Rp=         6;          %[s]
    D_Ts=           2;            %[s]
    D_Tv=           0.2;          %[s]
    D_Rp=           2;        %[s]
    G_Ts=           -0.13;        %[s^2/spikes]
    G_Tv=           0.09;         %[s^2/spikes]
    G_Rp=           0.3;         %[kPa.ms/ml/spikes] .144 bij 47%
    fRp0=           110;      %[kPa.ms/ml] 
    T0=             0.21;    
    if lamb==1; T0=0.14; end%[s]
    sigma_Ts(1:2)=  -0.3;%-0.2392;
    sigma_Tv(1:2)=  0.53;%0.5269;
    sigma_Rp(1:2)=  1.9365*G_Rp;
    DeltaTs(1:2)=   sigma_Ts(1);
    DeltaTv(1:2)=   sigma_Tv(1);
    DeltaRp(1:2)=   sigma_Rp(1);
    fT(1:2)=        sigma_Ts(1)+sigma_Tv(1)+T0;
    f_sp(1:2)=      18.8;   %SS at PfO20
    f_sh(1:2)=      11.8;%7.9551;    %SS at PfO20
    f_v(1:2)=       5.8545;     %SS at PfO20

elseif ico>2
%NAGAAN WAAROM SIGMA-SP NIET NUL IS
    jsearch0=j;
    jsearch1=round(jsearch0-ftcycle(fcycle-1)/dt);
    jsearch2=round(jsearch1-ftcycle(fcycle-2)/dt);
    mfpart(ico)=mean(fpart(jsearch1:jsearch0))*fackPaHg;
    if ico==3
        mfpart(1:2)=mean(fpart(jsearch2:jsearch1))*fackPaHg;
    end
    %Calculate fire rate chemo from current PfO2
    fi_ac(ico)=(facmax+facmin*exp((PfO2(ico-1)-PO2n)/k_ac))/(1+exp((PfO2(ico-1)-PO2n)/k_ac));
    f_ac(ico)=(f_ac(ico-1)*tau_c+fi_ac(ico)*tso)/(tau_c+tso);

    %CNS hypoxic response
    chi_sp(ico)=(chi_minsp+chi_maxsp*exp((PfO2(ico-1)-PO2nsp)/k_iscsp))/(1+exp((PfO2(ico-1)-PO2nsp)/k_iscsp));
    theta_sp(ico)=(theta_sp(ico-1)*tau_isc+chi_sp(ico)*tso)/(tau_isc+tso);
    chi_sh(ico)=(chi_minsh+chi_maxsh*exp((PfO2(ico-1)-PO2nsh)/k_iscsh))/(1+exp((PfO2(ico-1)-PO2nsh)/k_iscsh));
    theta_sh(ico)=(theta_sh(ico-1)*tau_isc+chi_sh(ico)*tso)/(tau_isc+tso);

    %constant baro rate: f_ab(ico)=f_ab SS
    pwig(ico)=(mfpart(ico)*(tso/tau_pb)+(tau_zb/tau_pb)*(mfpart(ico)-mfpart(ico-1))+pwig(ico-1))/(1+tso/tau_pb);
    f_ab1(ico)=(f_abmin+f_abmax*exp((pwig(ico)-pn)/k_ab))/(1+exp((pwig(ico)-pn)/k_ab));
    f_ab(ico)=24;% f_ab1(ico);%
    f_v(ico)=(f_ev0+f_evinf*exp((f_ab(ico)-f_ab0)/k_ev))/(1+exp((f_ab(ico)-f_ab0)/k_ev))+W_cv*f_ac(ico)-W_pv*f_ap(ico)-theta_v;

    if scen==1 && convm==2 && con>0
        %Vagal compression during early deceleration: addition of vag fire rate due
        %to vagal hypoxia
        f_v1(ico)=f_v(ico);
        f_v2(ico)=1.5*vag_comp(j); 
        f_v(ico)=f_v1(ico)+f_v2(ico);
    end

    %Calculate fire rate OS and PS
    f_sp(ico)=f_esinf+(f_es0-f_esinf)*exp(k_es*(-W_bsp*f_ab(ico)+W_csp*f_ac(ico)-W_psp*f_ap(ico)-theta_sp(ico)));
    if f_sp(ico)>=f_esmax; f_sp(ico)=f_esmax; end

    f_sh(ico)=f_esinf+(f_es0-f_esinf)*exp(k_es*(-W_bsh*f_ab(ico)+W_csh*f_ac(ico)-theta_sh(ico)));
    if f_sh(ico)>=f_esmax; f_sh(ico)=f_esmax; end

    % Effectors: Rp
    if ico<=ceil(D_Rp/tso)+3 || f_sp(ico-round(D_Rp/tso))<f_espmin
        sigma_Rp(ico)=G_Rp*1.9365;
    elseif ico>ceil(D_Rp/tso)+3 && f_sp(ico-round(D_Rp/tso))>f_espmin
        sigma_Rp(ico)=G_Rp*log(f_sp(ico-round(D_Rp/tso))-f_espmin+1);
    end
    DeltaRp(ico)=(DeltaRp(ico-1)*tau_Rp+sigma_Rp(ico)*tso)/(tau_Rp+tso);
    Rp1(ico)=DeltaRp(ico)*facHgkPa*1e3+fRp0;
    if ico>10
        %fR(2)=Rp1(ico);
    end


    % Effectors: T
    if ico<=ceil(D_Ts/tso)+3
        sigma_Tv(ico)=sigma_Tv(1);
        DeltaTv(ico)=sigma_Tv(ico);
        sigma_Ts(ico)=sigma_Ts(1);
        DeltaTs(ico)=sigma_Ts(ico);
    elseif ico<=ceil(D_Tv/tso)+3
        sigma_Tv(ico)=sigma_Tv(1);
        DeltaTv(ico)=sigma_Tv(ico);
    else
        %Heart rate
        if f_sh(ico)>+f_esmin
            sigma_Ts(ico)=G_Ts*log(f_sh(ico-round(D_Ts/tso))-f_esmin+1);
        else
            sigma_Ts(ico)=0;
        end
        DeltaTs(ico)=(DeltaTs(ico-1)*tau_Ts+sigma_Ts(ico)*tso)/(tau_Ts+tso);
        sigma_Tv(ico)=G_Tv*f_v(ico-round(D_Tv/tso));
        DeltaTv(ico)=(DeltaTv(ico-1)*tau_Tv+sigma_Tv(ico)*tso)/(tau_Tv+tso);
    end

    fT(ico)=DeltaTs(ico)+DeltaTv(ico)+T0;
end
