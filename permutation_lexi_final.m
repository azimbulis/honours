function [pval]= permutation(data1,data2, iter)
%iter number of interations (standard 5000)
%vector with original values 
%data1 is the group id
%data2 is the correlation matrix for each subject (42x51)

size1 = size(data1);
data_permute = data2; %42 x 51 matrix
grp_size1 = size(data1,1);
grp_id = data1;  %ids for either high or low performing neuropsych

for x = 1:iter
    rand_vec = rand(grp_size1,1);
    [~,sort_rand] = sort(rand_vec);
    grp_rand = grp_id(sort_rand);
    %new pval is not correct,it's not calculating actual pvalues here
    null_delta(x,:)= nanmean(data_permute(grp_rand==1,:),1) - nanmean(data_permute(grp_rand==0,:),1);
    %calculate p-value (significant difference) between 1s and 0s for each edge for 5000
    sprintf('%d',x)
end
 
orig_delta = nanmean(data_permute(grp_id==1,:),1)- nanmean(data_permute(grp_id==0,:),1);
%significance of it happening
a= size(data2,2); %51 ROIs, their significance based on permutation iteration
for xx = 1:a
    delta_above(xx) = sum(orig_delta(xx)>null_delta(:,xx))/iter;
    delta_below(xx) = sum(orig_delta(xx)<null_delta(:,xx))/iter;
    sprintf('%d',xx)
end

pval = min(vertcat(delta_above,delta_below));
end



