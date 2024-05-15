function calculate_xFC_erg_fun(par)


setDir;

subvect=par.subvect;
measvect=par.measvect;
parcelvect=par.parcelvect;
sessionvect=par.sessionvect;
gsrvect=par.gsrvect;
bpvect=par.bpvect;
zsvect=par.zsvect;

% % we probably don't need this at the moment
% %%%%%% LOAD VARIABLES brain_info and mask_final
% load brain_info
% load mask_final

% output_filename=['calculate_xFC_erg_out_' datestr(now, 'ddmmyy_HHMMSS') '.txt'];
output_filename=['calculate_xFC_erg_' char(subvect) '_out_' datestr(now, 'ddmmyy_HHMMSS') '.txt'];
fid = fopen(output_filename,'w');

% load([baseDir '/invalid_rois']);

for imeas=1:length(measvect)
    meas=measvect{imeas};
    %     for iscrub=1:length(scrubvect)
    %         scrub=scrubvect{iscrub};
    for iparcel=1:length(parcelvect)
        parcel=parcelvect{iparcel};
        for igsr=1:length(gsrvect)
            gsr=gsrvect{igsr};
            for ibp=1:length(bpvect)
                bp=bpvect{ibp};
                for izs=1:length(zsvect)
                    zs=zsvect{izs};
                    for iSub=1:length(subvect)
                        Sub=subvect{iSub};
                        for isession=1:length(sessionvect)
                            session=sessionvect{isession};
                            
                            
                            % data_this=load([dataErgDir '/' subvect{iSub} '/TC2_' scrubvect{iscrub}]);
                            data_this=load([dataErgDir '/' Sub '/' session '/' parcel '/TS_' parcel 'S' gsr bp zs '.mat']);
                            % eval(['data_this=data_this.TC2_' scrubvect{iscrub} '{' num2str(parcel) '};']);
                            data_this=data_this.TS';
                            
                            
                            
                            %                         if (iparcel==1 || iparcel==2)
                            %                             roi_vect=1:1:size(data_this,2);
                            %                             valid_rois=setdiff(roi_vect,invalid_rois{iparcel});
                            %                             data_this=data_this(:,valid_rois);
                            %                         end
                            tstart = tic;
                            switch meas
                                case 'ar_mls2'
                                    eval(['xFC=' meas '(data_this,1);']); % we just consider model order 1 at this stage, we already have enough loops...
                                case 'ar_mls'
                                    eval(['[Y,B,Z,E]=' meas '(data_this,1);']); % we just consider model order 1 at this stage, we already have enough loops...
                                    xFC=struct('Y',Y,'B',B,'Z',Z,'E',E); % the first row of B is the intercept, we still include it for the time being
                                case 'corr'
                                    eval(['[xFC pval]=' meas '(data_this);']);
                                case 'partialcorr'
                                    eval(['[xFC pval]=' meas '(data_this);']);
                            end
                            telapsed = toc(tstart);
                            filename=[Sub '_' session '_' parcel gsr bp zs '_' meas];                            
                            fprintf(fid,['Generating ' filename ' took ' num2str(telapsed) ' s\n']);
                            
                            switch meas
                                case 'ar_mls2'
                                    save([xFCDir '/' filename],'xFC','meas','parcel','Sub','gsr','bp','zs');
                                case 'ar_mls'
                                    save([xFCDir '/' filename],'xFC','meas','parcel','Sub','gsr','bp','zs');
                                case 'corr'
                                    save([xFCDir '/' filename],'xFC','pval','meas','parcel','Sub','gsr','bp','zs');
                                case 'partialcorr'
                                    save([xFCDir '/' filename],'xFC','pval','meas','parcel','Sub','gsr','bp','zs');
                            end
                            % keyboard;
                        end
                    end
                end
            end
        end
    end
end
% keyboard;
