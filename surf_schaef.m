function [left, right] = surf_schaef(data,name)
%SURF_SCHAEF       Plots results onto Schaefer Atlas
%
% Note: data must be 400x1

struc_L = gifti('/Volumes/CRU/Parkinsons/Lexi_Honours_2020/FMRIprep/Brain_Plots/Conte69.L.midthickness.32k_fs_LR.surf.gii');
struc_R = gifti('/Volumes/CRU/Parkinsons/Lexi_Honours_2020/FMRIprep/Brain_Plots/Conte69.R.midthickness.32k_fs_LR.surf.gii');
left = gifti('/Volumes/CRU/Parkinsons/Lexi_Honours_2020/FMRIprep/Brain_Plots/schaef_left.func.gii');
right = gifti('/Volumes/CRU/Parkinsons/Lexi_Honours_2020/FMRIprep/Brain_Plots/schaef_right.func.gii');

% identity matrix
idx = zeros(401,2);
idx(2:401,1) = 1:1:400;
idx(2:401,2) = data;


% left
original = left.cdata;
[~,index_net] = ismember(original,idx(:,1));
map_net = idx(:,2);
left.cdata = map_net(index_net);
figure; plot(struc_L,left);
abc = sprintf('%s%s%s','save(left,''left_',name,'.func.gii'',''Base64Binary'');');
eval(abc)

% right
original = right.cdata;
[~,index_net] = ismember(original,idx(:,1));
map_net = idx(:,2);
right.cdata = map_net(index_net);
figure; plot(struc_R,right);
abc = sprintf('%s%s%s','save(right,''right_',name,'.func.gii'',''Base64Binary'');');
eval(abc)



end



