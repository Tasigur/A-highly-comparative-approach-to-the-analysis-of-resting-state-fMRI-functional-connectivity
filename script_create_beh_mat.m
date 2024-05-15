%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% 1. Setting up path files: already done in startup.m

% setting up dirs

setDir;


% loading csv beh file
beh_unrest=readcell([behDir '/unrestricted_hcp.csv']);
beh_rest=readcell([behDir '/restricted_hcp.csv']);

beh=[beh_unrest beh_rest];

subID_col_unrest=beh(:,1);
subID_col_rest=beh(:,size(beh_unrest,2)+1);
isequal(subID_col_unrest,subID_col_rest) % yes, they are equal

Indices_1206_Subjects=cell2mat(subID_col_unrest(2:end))';

beh=beh(:,[1:size(beh_unrest,2) size(beh_unrest,2)+2:end]); % removing extra Subject column due to concatenating unrest and rest data


% better to load Thomas xls file

[beh_xls beh_xls_txt beh_xls_raw]=xlsread([behDir '/ALL_HCP_SUBJECTS_BEHAV.xls']);





Behavioral_Data=beh_xls(:,24:end); % to conform with variable names in thomas_step9 ; beh features considered start from index 24 (Height)

rng default % this puts the random number generator back to its default settings - ppca uses rand for setting i.c.
cd ../mot_ana/MOT_ANA/Matlab_Scripts/
thomas_step9; % step 9 from Thomas MOT_ANA preprocessing pipeline
cd ../../../highly_comp/

% saving beh
Behavior=PCA;
Indices_1206s=beh_xls(:,1); % subject indexes
save([behDir '/Behavior_1206s.mat'],'Behavior');
save([behDir '/Indices_1206s.mat'],'Indices_1206s'); % indices of subjects for whom Beh is available
save([behDir '/PCA_title_1206s.mat'],'PCA_title');

% from before I figured out the PPCA procedure
% for beh_name=1:length(PCA_title)
%     ind_feat=strmatch(PCA_title(beh_name),beh(1,:),'exact');
% end

