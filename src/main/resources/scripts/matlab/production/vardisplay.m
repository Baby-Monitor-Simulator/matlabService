%Variables end values

disp(' ')
disp('Contraction parameters ')
disp('--------------------------------------------------------- ')
disp(['p_rest       : ' num2str( fprest,'%10.2f' )                  ' mmHg ' ]);
disp(['p_con        : ' num2str( contrstrength(1),'%10.2f' )        ' mmHg'  ]);
disp(['T_con        : ' num2str( contrlength(1)*dt/1e3,'%10.0f' )   ' s']);
disp(['T_inter      : ' num2str( (j_contrstart(2)-j_contrstart(1))*dt/1e3,'%10.0f' ) ' s'  ]);
disp(['c_R1         : ' num2str( c_R1,'%10.2f' )  ]);
disp(['c_R2         : ' num2str( c_R2,'%10.2f' )  ]);
disp(['W_eff        : ' num2str( scaledepth(1),'%10.2f' ) ]);

disp(' ')
disp('Maternal cardiovascular parameters ')
disp('--------------------------------------------------------- ')
disp(['V_w          : ' num2str( mVw,'%10.0f' )     '    ml       V_total      : ' num2str( mVtotal,'%10.0f' )  '  ml'  ]);
disp(['V_lv,0       : ' num2str( mV0lv,'%10.1f' )    '   ml       V_a,0        : ' num2str( mVa0,'%10.0f' )    '   ml'  ]);
disp(['l_s,0        : ' num2str( mls0,'%10.1f' )    '    um       V_v,0        : ' num2str( mVv0,'%10.0f' )     '  ml'  ]);
disp(['l_s,a0       : ' num2str( mlsa0,'%10.1f' )   '    um       V_ut,0       : ' num2str( Vut0,'%10.0f' )    '   ml'  ]);
disp(['l_s,a1       : ' num2str( mlsa1,'%10.1f' )   '    um       R_a          : ' num2str( mRa,'%10.0f' )   '     kPa.ms/ml'  ]);
disp(['sigma_f,0    : ' num2str( msf0,'%10.2f' )     '   kPa      R_p          : ' num2str( mRp,'%10.0f' )    '    kPa.ms/ml'  ]);
disp(['sigma_r,0    : ' num2str( msr0,'%10.2f' )     '   kPa      R_v          : ' num2str( mRv,'%10.0f' )   '     kPa.ms/ml'  ]);
disp(['sigma_a,0    : ' num2str( mTa0,'%10.0f' )    '    kPa      R_ivs        : ' num2str( Rutmc,'%10.0f' )    '   kPa.ms/ml'  ]);
disp(['c_f          : ' num2str( mcf,'%10.0f' )    '              R_utv        : ' num2str( Rutv,'%10.0f' )  '    kPa.ms/ml'      ]);
disp(['c_c          : ' num2str( mcc,'%10.0f' )   '               C_a          : ' num2str( mCa,'%10.0f' )    '    ml/kPa'       ]);
disp(['tau_r,1      : ' num2str( mtaur1,'%10.0f' )  '    ms       C_v          : ' num2str( mCv,'%10.0f' )     '   ml/kPa'  ]);
disp(['tau_d,1      : ' num2str( mtaud1,'%10.0f' )  '    ms       C_ut         : ' num2str( Cut,'%10.1f' )     '   ml/kPa'  ]);
disp(['a_r          : ' num2str( mar,'%10.0f' )     '    ms       L_a          : ' num2str( mLa,'%10.0f' )    '    kPa.ms2/ml'  ]);
disp(['a_d          : ' num2str( mad,'%10.0f' )     '    ms       L_v          : ' num2str( mLv,'%10.0f' )    '    kPa.ms2/ml'  ]);
disp(['b_d          : ' num2str( mbd,'%10.2f' )      '   s2       l._s,0       : ' num2str( mv0,'%10.2f' )      '  um/ms'  ]);
disp(['HR_0         : ' num2str( mHR0,'%10.2f' )     '   1/s      c_l.         : ' num2str( mcv,'%10.1f' )       ]);

disp(' ')
disp('Fetal cardiovascular parameters ')
disp('--------------------------------------------------------- ')
disp(['V_w          : ' num2str( fVw,'%10.0f' )    '     ml       V_total      : ' num2str( fVtotal,'%10.0f' ) '   ml'  ]);
disp(['V_lv,0       : ' num2str( fV0lv,'%10.0f' ) '      ml       V_a,0        : ' num2str( fVa0,'%10.1f' )     '  ml'  ]);
disp(['l_s,0        : ' num2str( fls0,'%10.1f' )    '    um       V_v,0        : ' num2str( fVv0,'%10.1f' )     '  ml'  ]);
disp(['l_s,a0       : ' num2str( flsa0,'%10.1f' )   '    um       V_um,0       : ' num2str( Vum0,'%10.1f' )     '  ml'  ]);
disp(['l_s,a1       : ' num2str( flsa1,'%10.1f' )   '    um       V_br,0       : ' num2str( Vbr0,'%10.1f' )     '  ml'  ]);
disp(['sigma_f,0    : ' num2str( fsf0,'%10.2f' )     '   kPa      R_a          : ' num2str( fRa,'%10.1f' )      '  kPa.ms/ml'  ]);
disp(['sigma_r,0    : ' num2str( fsr0,'%10.2f' )     '   kPa      R_p          : ' num2str( fRp,'%10.0f' )     '   kPa.ms/ml'  ]);
disp(['sigma_a,0    : ' num2str( fTa0,'%10.0f' )    '    kPa      R_v          : ' num2str( fRv,'%10.1f' )     '   kPa.ms/ml'  ]);
disp(['c_f          : ' num2str( fcf,'%10.0f' )    '              R_ummc       : ' num2str( Ruma,'%10.0f' )    '   kPa.ms/ml'  ]);
disp(['c_c          : ' num2str( fcc,'%10.0f' )   '               R_umv        : ' num2str( Rummc,'%10.1f' )   '   kPa.ms/ml'      ]); 
disp(['tau_r,1      : ' num2str( ftaur1,'%10.0f' ) '     ms       R_brmc0      : ' num2str( Rbra,'%10.0f' )     '  kPa.ms/ml'      ]);
disp(['tau_d,1      : ' num2str( ftaud1,'%10.0f' )  '    ms       R_brv        : ' num2str( Rbrmc,'%10.1f' )   '   kPa.ms/ml'      ]);
disp(['a_r          : ' num2str( far,'%10.0f' )    '     ms       C_a          : ' num2str( fCa,'%10.1f' )     '   ml/kPa'       ]);
disp(['a_d          : ' num2str( fad,'%10.2f' )        ' ms       C_v          : ' num2str( fCv,'%10.0f' )    '    ml/kPa'  ]);
disp(['b_d          : ' num2str( fbd,'%10.2f' )      '   s2       C_um         : ' num2str( Cum,'%10.0f' )    '    ml/kPa'  ]);
disp(['HR_0         : ' num2str( fHR0,'%10.2f' )     '   1/s      C_br         : ' num2str( Cbr,'%10.2f' )      '  ml/kPa'  ]);
disp(['l._s,0       : ' num2str( fv0,'%10.2f' )      '   um/ms    L_a          : ' num2str( fLa,'%10.0f' )    '    kPa.ms2/ml'  ]);  
disp(['c_l.         : ' num2str( fcv,'%10.1f' )     '             L_v          : ' num2str( fLa,'%10.0f' )    '    kPa.ms2/ml'  ]);

disp(' ')
disp('Oxygen distribution parameters ')
disp('--------------------------------------------------------- ')
disp(['D            : ' num2str( D,'%10.2e' )           '     m3 gas/s/mmHg O2 ' ]);
disp(['C_a,m        : ' num2str( Cm(1),'%10.2f' )  '          m3 gas/m3 blood'  ]);
disp(['C_p,th       : ' num2str( Cfth,'%10.2f' )   '          m3 gas/m3 blood']);
disp(['C_br,th      : ' num2str( Cfbrth,'%10.2f' ) '          m3 gas/m3 blood'  ]);
disp(['O._met,p     : ' num2str( dVfdt0,'%10.2e' )      '     m3 gas/s' ]);
disp(['O._met,br    : ' num2str( dVfbrdt0,'%10.2e' )    '     m3 gas/s'  ]);
disp(['K_f          : ' num2str( Ko,'%10.2e' )          '     m3 blood/s'  ]);
disp(['alfa         : ' num2str( alfa,'%10.2e' )        '     m3 gas/g'  ]);
disp(['beta         : ' num2str( beta,'%10.2e' )        '     m3 gas/m3 blood/mmHg O2'  ]);
disp(['Hb_m         : ' num2str( Hbm,'%10.2e' )         '     g/m3 blood' ]);
disp(['Hb_f         : ' num2str( Hbf,'%10.2e' )         '     g/m3 blood' ]);
disp(['c_1,m        : ' num2str( c1m,'%10.2e' )         '     mmHg O2^3' ]);
disp(['c_1,f        : ' num2str( c2m,'%10.0f' )   '           mmHg O2^2']);
disp(['c_2,m        : ' num2str( c1f,'%10.2e' )         '     mmHg O2^3' ]);
disp(['c_2,f        : ' num2str( c2f,'%10.0f' )   '           mmHg O2^2']);

disp(' ')
disp('Regulation parameters ')
disp('--------------------------------------------------------- ')
disp(['f_v,0        : ' num2str( f_v(1),'%10.2f' )      '     1/s ' ]);
disp(['pO_2,br,0    : ' num2str( Pfbrmc0,'%10.1f' ) '     mmHg ']);
disp(['W_v          : ' num2str( 0.2,'%10.1f' )         '      s' ]);
disp(['DeltaT_s     : ' num2str( DeltaTs(1),'%10.2f' )  ]);
disp(['T,0          : ' num2str( T0,'%10.2f' )          '     s'  ]);
disp(['tau_T,v      : ' num2str( tau_Tv,'%10.1f' )      '      s' ]);
disp(['G_T,v        : ' num2str( G_Tv,'%10.2f' )        '     s^2'  ]);
disp(['D_T,v        : ' num2str( D_Tv,'%10.1f' )        '      s'  ]);
