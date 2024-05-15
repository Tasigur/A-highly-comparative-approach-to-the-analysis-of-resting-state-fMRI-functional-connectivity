%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

stringa='script_calculate_xFC_erg';

%This script creates every possible combination of measure, then it calls multi_range_qsub in order to create the .m files and the jobs that will be launched with the cluster

%% 1. Setting up path files: already done in startup.m

% setting up dirs

setDir;

% extract subIDs
subvect={};
iSub=0;
Dthis=dir(dataErgDir);

for i=1:length(Dthis)
    numthis=str2num(Dthis(i).name);
    if ~isempty(numthis)
        iSub=iSub+1;
        subvect{iSub}=Dthis(i).name;
    end
end

par.subvect=subvect;
% vector of xFC measures
par.measvect={'ar_mls2','ar_mls','corr','partialcorr'};

%Vector of parcellations
par.parcelvect={'Schaefer100','Schaefer200','Schaefer400','Schaefer800','Glasser360'};


%Vector of sessions
par.sessionvect={'rfMRI_REST1_LR','rfMRI_REST1_RL','rfMRI_REST2_LR','rfMRI_REST2_RL'};


par.gsrvect={'','_gsr'}; % global signal regression
par.bpvect={'','_bp'}; % Bandpass filter
par.zsvect={'','_z'}; % z-score

stringa_mfile={'calculate_xFC_erg_fun'};
multi_range_qsub(stringa,stringa_mfile,par);

