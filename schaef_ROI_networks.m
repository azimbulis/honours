%%Putting into 17 networks
schaef_ROI = zeros(42,51);
for x = 1:42
    for network = 1:17
        schaef_ROI(x,network)= mean(dr_all(x,schaef_id17==network));
  %mean((PD_all_ROI(:,1:12))+(PD_all_ROI(:,201:212)))
    end
    
    for network = 1:17
        b=network+17;
        schaef_ROI(x,b)= mean(lc_all(x,schaef_id17==network));
  %mean((PD_all_ROI(:,1:12))+(PD_all_ROI(:,201:212)))
    end
    
    for network = 1:17
        c=network+34;
        schaef_ROI(x,c)= mean(ms_all(x,schaef_id17==network));
  %mean((PD_all_ROI(:,1:12))+(PD_all_ROI(:,201:212)))
    end
    sprintf('%d',x)
end