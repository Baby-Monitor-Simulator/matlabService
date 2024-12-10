for i=1:size(HR(:,1))
    if HR(i,2)<0; HR(i,2)=NaN; end
end

tmax=max(HR(end,1),toco(end,1));
figure; subplot(2,1,1); plot(HR(:,1)/60,HR(:,2));axis([0,tmax/60,60,210]); subplot(2,1,2); plot(toco(:,1)/60,toco(:,2)); axis([0,tmax/60,0,100]);

if exist('HR2')&&exist('toco2')
    HR2(:,1)=HR2(:,1)-HR2(1,1);
    toco2(:,1)=toco2(:,1)-toco2(1,1);
    figure; subplot(2,1,1); plot(HR2(:,1),HR2(:,2),'k');
    axis([0,HR2(end,1),60,210]); 
    xlabel('time [min]')
    ylabel('FHR [bpm]')
    set(gca,'xtick',[0:HR2(end,1)+1])
    set(gca,'ytick',[60:20:210])
    daspect([0.5,20,1])
    grid on
    title('CTG')
    subplot(2,1,2); plot(toco2(:,1),toco2(:,2),'k'); 
    xlabel('time [min]')
    ylabel('UP [mmHg]')
    set(gca,'xtick',[0:HR2(end,1)+1])
    set(gca,'ytick',[0:25:100])
    axis([0,HR2(end,1),0,100])
    daspect([0.5,50,1])
    grid on
end 