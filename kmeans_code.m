
%% k-means analysis -- sweep through values of k (2-20)

for kk = 1:19
    idx_rank_sweep(:,kk) = kmeans(var_rank,kk+1);
end


%% calculate similarity between different values of k

for kk = 1:19
    for ll = 1:19
        [~,sim_idx(kk,ll)] = partition_distance(idx_rank_sweep(:,kk),idx_rank_sweep(:,ll));
    end
end


%% elbow plot

plot(sum(sim_idx))

% note - look for the point when adding another cluster doesn't change the
% similarity score all that much (i.e., doesn't buy you much in terms of
% stability)


%% 3D scatter plot of ranked variable scores, with colours defined by k-means analysis

gscatter3(var_rank(:,1),var_rank(:,2),var_rank(:,3),idx_rank_sweep(:,4)) % idx of 5 is equivalent to the 4th column of idx_rank_sweep

xlabel('dsb')
ylabel('lm')
zlabel('stroop')
title('ranks')

set(gcf,'color','w'); % #plot-autism

