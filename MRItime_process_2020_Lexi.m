function aaaa = MRItime_process(filename, subnum)
%mri file is the nuisance regressed/denoised file from denoiser output
%denoted by '_NR.nii.gz'
home_path = '/Volumes/PD/Lexi_Honours/rsfMRI/results';

%%mrifile = [subnum '_task-rest_run-01_bold_space-MNI152NLin2009cAsym_preproc_NR.nii.gz']; 
data = MRIread(filename); %create a MRI read to use the function
parc = MRIread('/Volumes/PD/Lexi_Honours/rsfMRI/brainstem/parc_nat2.nii.gz'); % parc_nat1 is just the cortical ROIs, whereas parc_nat2 contains the brainstem ROIs too
nNodes = 403; %  % cortex = 1-400; dorsal raphe = 401; median raphe = 402; locus coeruleus = 403

%% extract the time series

sub_ts = zeros(nNodes,data.nframes);


for t = 1:data.nframes %for each time point
    
    temp = data.vol(:,:,:,t); %create a temporary file with the "t"-th slice of the data
    temp = temp(:); %flatten it out
    
    for j = 1:nNodes %for each region in turn
        temp1 = find(parc.vol==j); %find the points in the volume where the ROI lives
        temp2 = temp(temp1); %extract the same points from the flattened temp file
        sub_ts(j,t) = sum(temp2)/size(temp,1); %calculate the average value across the ROI points
    end
    
    sprintf('%f%s',t/data.nframes*100,' % completed') %ticker to keep you up to date on progress
    
end

save(['/Volumes/PD/Lexi_Honours/rsfMRI/results/' subnum '/' subnum '-sub_ts_cort'],'sub_ts')

%% preprocess further, this is not necessary data has already been processed through denoise apply low-pass and high-pass filter

%create a bandpass filter - only allows slow frequencies (between 1/100 and
%1/10 cycles per second) through and deletes everything else

fs = 1/3; %sampling frequency
[b,a] = butter(3,[.01 .1]/(fs/2),'bandpass'); %creates values 'a' & 'b' that we'll use later
sub_ts1 = zeros(nNodes,data.nframes); %predefine
sub_ts2 = zeros(nNodes,data.nframes); %predefine

for j = 1:nNodes %for each region in turn
    sub_ts2(j,:) = filtfilt(b,a,sub_ts1(j,:)); %apply the bandpass filter
    sub_ts2(j,:) = filtfilt(b,a,sub_ts1(j,:)); %apply the bandpass filter
end
save(['Volumes/PD/Lexi_Honours/rsfMRI/results/rsfMRI/results/' subnum '/' subnum '-sub_ts2_cort'],'sub_ts2');

%% calculate correlation matrix
%outputfile = ['C:\Users\pdrc\Documents\Lexi\out\fmriprep\' num2str(subnum)];
ts_corr = corr(sub_ts2); %calculate the Pearson's correlation between regions
save(['/Volumes/PD/Lexi_Honours/rsfMRI/results/' subnum '/' subnum '-ts_corr_cort'],'ts_corr'); %main output that needs to be saved


% you should save this ("save ts_corr ts_corr") in each subjects folder
% (along with all the other files we create)

%% you can break up the correlation matrix into interpretable bits if you'd like

% cort_id is the network ID for each cortical region (i.e., region 1-400)
% 1-2 = visual, 3-4 = motor, 5-6 = dorsal attention, 7-8 = ventral
% attention, 9-10 = limbic, 11-13 = control, 14-16 = default & 17 =
% temporo-parietal
cort_id = [1;1;1;1;1;1;1;1;1;1;1;1;2;2;2;2;2;2;2;2;2;2;2;2;3;3;3;3;3;3;3;3;3;3;3;3;3;3;3;3;3;3;3;4;4;4;4;4;4;4;4;4;4;4;4;4;4;4;4;5;5;5;5;5;5;5;5;5;5;5;5;5;6;6;6;6;6;6;6;6;6;6;6;6;6;7;7;7;7;7;7;7;7;7;7;7;7;7;7;7;8;8;8;8;8;8;8;8;9;9;9;9;9;10;10;10;10;10;10;10;11;11;11;11;11;11;11;11;11;11;11;11;11;12;12;12;12;12;12;12;12;12;12;13;13;13;13;13;14;14;14;14;14;14;14;14;14;14;14;14;14;14;14;14;14;14;15;15;15;15;15;15;15;15;15;15;15;15;15;15;15;15;15;15;15;15;15;16;16;16;16;16;16;16;17;17;17;17;17;17;1;1;1;1;1;1;1;1;1;1;1;1;2;2;2;2;2;2;2;2;2;2;2;3;3;3;3;3;3;3;3;3;3;3;3;3;3;3;3;3;3;3;3;4;4;4;4;4;4;4;4;4;4;4;4;4;4;4;5;5;5;5;5;5;5;5;5;5;5;5;5;5;6;6;6;6;6;6;6;6;6;6;6;6;7;7;7;7;7;7;7;7;7;7;7;7;7;7;7;7;7;7;7;8;8;8;8;8;8;8;8;8;9;9;9;9;9;9;10;10;10;10;10;10;11;11;11;11;11;11;11;11;11;11;11;12;12;12;12;12;12;12;12;12;12;12;12;12;12;12;13;13;13;13;13;13;13;14;14;14;14;14;14;14;14;14;14;14;14;14;14;14;14;15;15;15;15;15;15;15;15;15;15;15;16;16;16;16;16;16;17;17;17;17;17;17;17;17;17;17];
nNet = max(cort_id);

% you could take the mean of each like this:
ts_corr_net = zeros(nNet);

for x = 1:nNet
    for y = 1:nNet
        ts_corr_net(x,y) = mean(mean(ts_corr(cort_id==x,cort_id==y)));
    end 
end
save(['/Volumes/PD/Lexi_Honours/rsfMRI/results/' subnum '/' subnum '-ts_corr_cort_net'],'ts_corr_net');

% to extract the correlation between the DR/MR/LC and cortex:
%outputfile = ['C:\Users\pdrc\Documents\Lexi\fmriprep\' num2str(subnum)];
dr_corr = ts_corr(:,401);
save(['/Volumes/PD/Lexi_Honours/rsfMRI/results/' subnum '/' subnum '-dr_corr_cort'],'dr_corr'); 
mr_corr = ts_corr(:,402);
save(['/Volumes/PD/Lexi_Honours/rsfMRI/results/' subnum '/' subnum '-ms_corr_cort'],'ms_corr');
lc_corr = ts_corr(:,403);
save(['/Volumes/PD/Lexi_Honours/rsfMRI/results/' subnum '/' subnum '-lc_corr_cort'],'lc_corr');


% you can then create the average across networks, if you'd like:

dr_corr_net = zeros(nNet,1);
mr_corr_net = zeros(nNet,1);
lc_corr_net = zeros(nNet,1);


for x = 1:nNet
   dr_corr_net(x,1) = mean(dr_corr(cort_id==x));
   save(['/Volumes/PD/Lexi_Honours/rsfMRI/results/' subnum '/' subnum '-dr_corr_subcort_net'],'dr_corr_net');
   mr_corr_net(x,1) = mean(mr_corr(cort_id==x));
   save(['/Volumes/PD/Lexi_Honours/rsfMRI/results/' subnum '/' subnum '-ms_corr_cort_net'],'ms_corr_net');
   lc_corr_net(x,1) = mean(lc_corr(cort_id==x));
   save(['/Volumes/PD/Lexi_Honours/rsfMRI/results/' subnum '/' subnum '-lc_corr_cort_net'],'lc_corr_net');
end

%% if you can get the data from each subject processed through this pipeline,
%% and sorted into groups (e.g., dr_corr_grp = 400 x No. Subjects)







