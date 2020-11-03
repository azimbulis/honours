%% Spearman's correlation between ranking of groups

[rho,pval]= corr(NP_rank_final(:,2),NP_rank_final(:,3),'Type','Spearman')

%% K-means
for kk = 1:19
    idx_rank_sweep_NP_2(:,kk) = kmeans(NP_rank_final,kk+1);
end

%% Permutation testing
idx_rank_sweep_NP_2 = zeros(42,19,100);
for xx = 1:100
    for kk = 1:19
        idx_rank_sweep_NP_2(:,kk,xx) = kmeans(NP_rank_final,kk+1);
    end
    sprintf('%d',xx)
end

%% similarity index 
sim_idx_NP_2 = zeros(19,100,100);
for kk = 1:19
    for xx = 1:100
        for yy = 1:100
            [~,sim_idx_NP_2(kk,xx,yy)] = partition_distance(idx_rank_sweep_NP_2(:,kk,xx),idx_rank_sweep_NP_2(:,kk,yy));
        end
    end
      sprintf('%d',kk)
end

%% Visualisation 

sim_idx_NP_2_2 = reshape(sim_idx_NP_2,19,10000)

figure
plot(mean(sim_idx_NP_2_2,2))

figure
plot(std(sim_idx_schaef_2,[],2))
