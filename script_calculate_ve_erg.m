%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% 1. Setting up path files: already done in startup.m

% setting up dirs

setDir;

PLOT.print=1;

% extract subIDs
subvectData={};
iSub=0;
Dthis=dir(dataErgDir);

for i=1:length(Dthis)
    numthis=str2num(Dthis(i).name);
    if ~isempty(numthis)
        iSub=iSub+1;
        subvectData{iSub}=Dthis(i).name; % indices of subjects for whom fMRI data is available
    end
end

% vector of xFC measures
measvect={'ar_mls2','ar_mls','corr','partialcorr'};

% vector of available parcellation schemes
parcelvect={'Schaefer100','Schaefer200','Schaefer400','Schaefer800','Glasser360'};

% vector of sessions
sessionvect={'rfMRI_REST1_LR','rfMRI_REST1_RL','rfMRI_REST2_LR','rfMRI_REST2_RL'};


gsrvect={'','_gsr'}; % global signal regression vector
bpvect={'','_bp'}; % Bandpass filter vector
zsvect={'','_z'}; % z-score vector

load([baseDir '/subvect_w_zeros_erg']);
subvectData=setdiff(subvectData,subvect_w_zeros); % We disregard subjects with ROIs that are identically 0 for the time being


output_filename=['calculate_ve_erg_out_' datestr(now, 'ddmmyy_HHMMSS') '.txt'];
fid = fopen(output_filename,'w');


% loading beh
load([behDir '/Behavior_1206s.mat']);
load([behDir '/Indices_1206s.mat']); % indices of subjects for whom Beh is available
load([behDir '/PCA_title_1206s.mat']);

% extract subIDs
subvect={};
iSub=0;

for i=1:length(Indices_1206s)
    im=ismember(subvectData,num2str(Indices_1206s(i)));
    if any(im)
        iSub=iSub+1;
        subvect{iSub}=num2str(Indices_1206s(i)); % indices of subjects for whom both fMRI and Beh data are available
        Behavior_wcorrData(iSub,:)=Behavior(i,:);
    end
end


cov_mat=ones(length(subvect),1); % we do not bother about regressing out potentially confounding covariates for the time being

%We create two matrix where we will save all the variance explained by every combination of features
var_exp_all=zeros(length(sessionvect)*length(measvect)*length(parcelvect)*length(gsrvect)*length(bpvect)*length(zsvect),size(Behavior_wcorrData,2));
var_exp_ind_sort_all=zeros(length(sessionvect)*length(measvect)*length(parcelvect)*length(gsrvect)*length(bpvect)*length(zsvect),size(Behavior_wcorrData,2));


% loading xFC

iFC=0;

% We loop through every combination of features and subjects in order to load its xFC.
for imeas=1:length(measvect)
    meas=measvect{imeas};
    for iparcel=1:length(parcelvect)
        parcel=parcelvect{iparcel};
        for igsr=1:length(gsrvect)
            gsr=gsrvect{igsr};
            for ibp=1:length(bpvect)
                bp=bpvect{ibp};
                for izs=1:length(zsvect)
                    zs=zsvect{izs};
                    for isession=1:length(sessionvect)
                        session=sessionvect{isession};
                        
                        iFC=iFC+1;
                        clear xFC_all;
                        
                        for iSub=1:length(subvect)
                            Sub=subvect{iSub};
                            filename=[Sub '_' session '_' parcel gsr bp zs '_' meas];
			    try
                           	xFC_this=load([xFCDir '/' filename],'xFC');
                            switch measvect{imeas}
                                case 'ar_mls2'
                                    xFC_this=xFC_this.xFC;
                                case 'ar_mls'
                                    xFC_this=xFC_this.xFC.B; % in the case of ar_mls ; xFC_this=xFC_this.xFC is a table with 4 tables , being B the one we are interested in
                                case 'corr'
                                    xFC_this=xFC_this.xFC;
                                case 'partialcorr'
                                    xFC_this=xFC_this.xFC;

                            end
                            xFC_all(iSub,:)=reshape(xFC_this,[1 prod(size(xFC_this))]);
                         catch
                         	disp(filename);
                            end
                            % keyboard;
                        end
                     
                        
                        % calculating the variance component matrix
                        K=corr(xFC_all');
                        
			% Calculate variance explained using heritability estimation
                        try
                        tstart = tic;
                        [h2, se, p_wald, p_perm,v_w] = get_heritability(Behavior_wcorrData, cov_mat, K, 'approx', 0); % not regressing out covariates of no interest
                        telapsed = toc(tstart);
                        fprintf(fid,['Calculating ve ' filename ' took ' num2str(telapsed) ' s\n']);
                        
                        var_exp_all(iFC,:)=v_w;
                        
                        %The results are then plotted
                        
                        figure
                        bar(v_w);
                        set(gca,'XTick',1:length(v_w))
                        set(gca,'XTickLabel',PCA_title);
                        set(gcf,'Position',[49         508        2511         816]);
                        set(gca,'Position',[0.0400    0.2577    0.9550    0.7073])
                        ylim([0 1]);
                        ylabel('variance explained');
                        xtickangle(30)
                        set(gca,'fontsize',16);
                        stringa_title=strrep([session '_' parcel gsr bp zs '_' meas],'_','-');
                        title(stringa_title,'FontWeight','normal');
                        if PLOT.print
                            figure_name=[figDir 'var_exp_' session '_' parcel gsr bp zs '_' meas];
                            export_fig(gcf,[figure_name '.png']);
                        end
                        
                        
                        [v_w_sorted ind_v_w_sorted]=sort(v_w,'descend');
                        var_exp_ind_sort_all(iFC,:)=ind_v_w_sorted;
                        
                        figure
                        bar(v_w_sorted);
                        set(gca,'XTick',1:length(v_w))
                        set(gca,'XTickLabel',PCA_title(ind_v_w_sorted));
                        set(gcf,'Position',[49         508        2511         816]);
                        set(gca,'Position',[0.0400    0.2577    0.9550    0.7073])
                        ylim([0 1]);
                        ylabel('variance explained');
                        xtickangle(30)
                        set(gca,'fontsize',16);
                        stringa_title=strrep([session '_' parcel gsr bp zs '_' meas],'_','-');
                        title(stringa_title,'FontWeight','normal');
                        if PLOT.print
                            figure_name=[figDir 'var_exp_sorted_' session '_' parcel gsr bp zs '_' meas];
                            export_fig(gcf,[figure_name '.png']);
                        end
                        end
                        
                        close all;
                    end
                end
            end
        end
    end
end

filename=['var_exp_all_170621_4']; % Output file where we save the results obtained
save([xFCDir '/' filename],'var_exp_all','var_exp_ind_sort_all','measvect','parcelvect','gsrvect','bpvect','zsvect','sessionvect','subvect');
% keyboard;
