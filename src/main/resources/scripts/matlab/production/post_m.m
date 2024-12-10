% u_post
%
% postprocessing of output stored in arrays p, V and q
%
%-----------------------------------------------------
nj=j-1;
tsav=tsav(1:nj)./1000;
psav=mpsav(:,1:nj)*fackPaHg;
qsav=mqsav(:,1:nj)*60*1000;
Vsav=mVsav(:,1:nj);

%mq = mq*60*1000;        % convert flows from ml/ms to ml/min
jmax=nj;
jmin=jmax-mtcycle(icycle-2);
pao  = max(mpsav(nmlv,:),mpsav(nma,:));

%%% determine hemodynamics of last cycle

HR      = 60*1000/mtcycle(icycle);
plvmin  = min(psav(nmlv,jmin:jmax));
plvmax  = max(psav(nmlv,jmin:jmax));
psaimin = min(psav(nma,jmin:jmax));
psaimax = max(psav(nma,jmin:jmax));
pivs    = mean(psav(nutmc,jmin:jmax));
COsys   = mean(qsav(sma,jmin:jmax));
Vls     = max(Vsav(nmlv,jmin:jmax))-min(Vsav(nmlv,jmin:jmax));
Vlvmax  = max(Vsav(nmlv,jmin:jmax));
Vlvmin  = min(Vsav(nmlv,jmin:jmax));
ef      = Vls/Vlvmax;
mVlv    = mVsav(nmlv,jmin:jmax);
mplv    = mpsav(nmlv,jmin:jmax)*1000/133;
mls     = ls2(jmin:jmax);
mvs     = fackPaHg*vs2(jmin:jmax);
if uterus==1; qutart  = mean(qsav(nutmc,jmin:jmax)); end


sim = 'normal mother';

disp(' ')
disp(['Hemodynamics : ' sim ])
disp('--------------------------------------------------------- ')
disp(['Heart rate            : ' num2str( HR,'%10.0f' ) ' bpm ' ]);
disp(['LV pressure           : ' num2str( plvmin,'%10.0f' ) ' - ' num2str( plvmax,'%10.0f' ) ' mmHg'  ]);
disp(['Systemic pressure     : ' num2str( psaimin,'%10.0f' ) ' - ' num2str( psaimax,'%10.0f' ) ' mmHg'  ]);
disp(['Systemic CO           : ' num2str( COsys,'%10.0f' ) ' ml/min'  ]);
disp(['Vlv min               : ' num2str( Vlvmin,'%10.0f' ) ' ml '  ]);
disp(['Vlv max               : ' num2str( Vlvmax,'%10.0f' ) ' ml '  ]);
disp(['LV ef                 : ' num2str( ef )  ]);
if uterus==1; disp(['Ut art flow           : ' num2str( qutart,'%10.0f' ) ' ml/min'  ]); end


figure
subplot(2,2,1)
hold on
plot(tsav,psav(nmlv,:),tsav,psav(nma,:))
legend('plv','psa')
xlabel('time [ms]','FontSize',16);
ylabel('pressure [mmHg]','FontSize',16);
subplot(2,2,2)
hold on
plot(tsav,qsav(smv,:),tsav,qsav(sma,:),tsav,qsav(smp,:))
legend('qmv','qav','qper')
xlabel('time [s]','FontSize',16);
ylabel('flow [ml/min]','FontSize',16);
subplot(2,2,3)
hold on
plot(tsav,Vsav(nmlv,:))
legend('Vlv')
xlabel('time [s]','FontSize',16);
ylabel('volume [ml]','FontSize',16);
subplot(2,2,4)
hold on
plot(Vsav(nmlv,jmin:jmax),psav(nmlv,jmin:jmax))
legend('LV')
xlabel('volume [ml]','FontSize',16);
ylabel('pressure [mmHg]','FontSize',16);

figure
set(gcf,'Paperposition',[ 0 0 8 16]);
subplot(2,1,1)
hold on
plot(tsav,psav(nma,:),tsav,psav(nmv,:))
legend('p_{art}','p_{ven}')
xlabel('time [s]','FontSize',14);
ylabel('pressure [mmHg]','FontSize',14);
title('systemic circulation','FontSize',16)
subplot(2,1,2)
hold on
plot(tsav,qsav(sma,:),tsav,qsav(smp,:),tsav,qsav(smv,:))
legend('q_{art}','q_{per}','q_{ven}')
xlabel('time [s]','FontSize',14);
ylabel('flow [ml/min]','FontSize',14);

figure
set(gcf,'Paperposition',[ 0 0 8 16]);
subplot(2,1,1)
hold on
plot(tsav,psav(nutmc,:))
axis([0,round(max(tsav)/5)*5,0,90]);
legend('p_{ivs}')
xlabel('time [s]','FontSize',14);
ylabel('pressure [mmHg]','FontSize',14);
title('uterine circulation','FontSize',16)
subplot(2,1,2)
hold on
plot(tsav,qsav(sutmc,:),tsav,qsav(sutv,:))
axis([0,round(max(tsav)/5)*5,0,1800]);
legend('q_{ivs}','q_{ut_{v}}')
xlabel('time [s]','FontSize',14);
ylabel('flow [l/min]','FontSize',14);

% --- end u_post