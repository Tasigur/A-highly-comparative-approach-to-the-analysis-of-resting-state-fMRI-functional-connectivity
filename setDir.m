% This file contains the directories and their paths we are working in. 

if isfolder('/home/fabiano/neuron/dimitri/') % Optiplex-7040 , delf or flaptop
    dataDir = '/home/fabiano/neuron/dimitri/highly_comp/HCP_TiBiUan';
    dataErgDir = '/home/fabiano/neuron/dimitri/HCP-Data/HCP_100unrelated_preprocessed_ERG/data/';
    baseDir = '/home/fabiano/neuron/dimitri/highly_comp';
elseif (isfolder('/home/baroni/neuron/dimitri/') || isfolder('/miplabsrv2home/baroni/neuron/dimitri/')) % miplabsrv
    dataDir = '/media/miplab-nas3/Data/HCP_TiBiUan';
    dataErgDir = '/media/miplab-nas2/HCP-Data/HCP_100unrelated_preprocessed_ERG/data/';    
    % baseDir = '/media/miplab-nas3/HCP-Data/highly_comp'; % no longer used
    baseDir = '/media/miplab-nas2/Data-NAS1/highly_comp';    % new base dir after 210120
else
    disp('Trabajando en local');
    dataDir = '/home/tasigur/Escritorio/TFM/data';
    dataErgDir = '/home/tasigur/Escritorio/TFM/data';
    baseDir='/home/tasigur/Escritorio/TFM/prueba_local';

    %keyboard;
end

xFCDir = '/home/tasigur/Escritorio/TFM/prueba_local/xFC';

behDir = [baseDir '/beh'];

figDir = '/home/tasigur/Escritorio/TFM/prueba_local/figures/';

if isempty(dir(figDir))
    mkdir(figDir)
end

if isfolder('/home/baroni/neuron/dimitri/')
    figDirTex = '/home/laurale/data_jm/figures'; 
elseif isfolder('/miplabsrv2home/baroni/neuron/dimitri/')
    figDirTex = '/miplabsrv2home/fabiano/neuron/dimitri/highly_comp/figures/';
else
	figDirTex = '/home/laurale/data_jm/figures'; 
end
