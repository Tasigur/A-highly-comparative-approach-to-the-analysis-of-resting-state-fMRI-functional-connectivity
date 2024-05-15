%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%It's the same as script_distribute_xFC.m but it only works with the missing subjects. As we were working with all the subjects, the cluster stopped working so there were some missing xFC. The ones missing corresponded to partialcorr with parcellations Glasser360 and Schaefer800

stringa='script_calculate_xFC_erg';

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

%% 
% Directory where the xFC are saved
directorio = "/home/laurale/data_jm/xFC";
% We obtain the full list with the names of the files
archivos = dir(fullfile(directorio, '*_rfMRI_REST2_LR_Schaefer100_gsr_bp_z_partialcorr.mat'));

sujetos = [];

% Regular expression to obtain 
pattern = '(\d{6})_rfMRI_REST2_LR_Schaefer100_gsr_bp_z_partialcorr.mat';

% Loop through every file
for i = 1:numel(archivos)
    % We extract and save the subjects numbers
    expresion = regexp(archivos(i).name, pattern, 'tokens');
    if ~isempty(expresion)
        sujetos = [sujetos; str2double(expresion{1})];
    end
end

sujetos_faltantes = [];
for i = 1:numel(sujetos)
    paciente = sujetos(i);
    
    nombre_archivo = fullfile(directorio, [num2str(paciente) '_rfMRI_REST2_LR_Schaefer800_gsr_bp_z_partialcorr.mat']);
    if exist(nombre_archivo, 'file') == 0
        sujetos_faltantes(end + 1) = paciente;
    end
    nombre_archivo = fullfile(directorio, [num2str(paciente) '_rfMRI_REST2_LR_Glasser360_gsr_bp_z_partialcorr.mat']);
    if exist(nombre_archivo, 'file') == 0
        sujetos_faltantes(end + 1) = paciente;
    end
end

% We check if the files already exist, if the don't we add them to the array in order to launch the jobs with them again later

sujetos_faltantes = num2cell(unique(sujetos_faltantes));
disp(sujetos_faltantes);
subvect = sujetos_faltantes; % We save only the missing subjects.
subvect = cellfun(@num2str, subvect, 'UniformOutput', false);

par.subvect=subvect;
par.measvect={'partialcorr'};


par.parcelvect={'Schaefer800','Glasser360'};


par.sessionvect={'rfMRI_REST1_LR','rfMRI_REST1_RL','rfMRI_REST2_LR','rfMRI_REST2_RL'};
% sessionvect={'rfMRI_REST1_LR','rfMRI_REST1_RL'}; % just considering the first 2 sessions

par.gsrvect={'','_gsr'}; % global signal regression
par.bpvect={'','_bp'}; % Bandpass filter
par.zsvect={'','_z'}; % z-score

stringa_mfile={'calculate_xFC_erg_fun'};
multi_range_qsub(stringa,stringa_mfile,par);

