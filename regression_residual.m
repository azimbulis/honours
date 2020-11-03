>> for rr = 1:51
[~,~,schaef_ROI_residual(:,rr)] = regress(schaef_ROI(:,rr),off_on_dopamine(:,1));
end

for xx = 1:3
[hh(:,xx),pp(:,xx)] = ttest2(schaef_ROI_residual(median_split_NP(:,xx)==1,:),schaef_ROI_residual(median_split_NP(:,xx)==0,:),'dim',1);
end
>>find(hh(:,1)==1)

>> for xx = 1:3
[hh1(:,xx),pp1(:,xx)] = ttest2(schaef_ROI(median_split_NP(:,xx)==1,:),schaef_ROI(median_split_NP(:,xx)==0,:),'dim',1);
end
>> find(hh1(:,1)==1)
