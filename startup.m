p=pathdef;
path(p);

% Adds the shared folder to do all we want: contains SPM8
PathSPM = '/media/miplab-nas3/Code-NAS1/shared/static_FC_pipeline/spm8';
PathPrepro = '/media/miplab-nas3/Code-NAS1/projects/ABIDE/preprocessing_Thomas/MyPreprocessing';
PathDPARSFA = '/media/miplab-nas3/Code-NAS1/shared/static_FC_pipeline/DPARSF_V2.3_130615';
PathRafael = '~/neuron/dimitri/raphael/FC-Behavior/';

% If the 'server link' exists, we add the path. Else, we add the computer
% path (with Volumes)
addpath(genpath(PathSPM));
addpath(genpath(PathPrepro));
addpath(genpath(PathDPARSFA));
addpath(genpath(PathRafael));
addpath('~/libraries');
addpath('~/libraries/subtightplot/');
addpath('~/libraries/polardendrogram/');
addpath(genpath('~/mylibraries'));
addpath(genpath('~/libraries/matlab-schemer'));
% schemer_import('cobalt.prf');
schemer_import('solarized-dark.prf');

% addpath(genpath('~/libraries')); % this can create problems, let's add only what we need
% addpath('~/libraries');
% addpath('~/libraries/fieldtrip');
% addpath(genpath('~/libraries/chronux'));
% addpath(genpath('~/libraries/eeglab14_1_1b'));
% addpath(genpath('~/libraries/IoSR-Surrey-MatlabToolbox-4bff1bb'));
% addpath('~/libraries/CircStat2012a/');
% addpath('~/libraries/bipolar_colormap/');
% addpath('~/libraries/lrkrol-permutationTest-06e5978/');
% addpath('~/neuron/hyafil/sylb');
% addpath('~/neuron/hyafil/NSLtools');
% addpath('~/neuron/hyafil/main_code');
% addpath(genpath('~/mylibraries'));

% addpath('~/data_an/manduca/ALL_DATA');
% addpath('~/neuron/AL');
% addpath('~/neuron/calab');
% addpath('~/neuron/exctblt');
% addpath('~/neuron/isian');
% addpath('~/neuron/isirm');
% addpath('~/neuron/lsm');
% addpath('~/neuron/preference');
% addpath('~/neuron/stdp');
% addpath('~/neuron/STG');
% addpath('~/neuron/ento');
% addpath('~/neuron/2neu');
% addpath(genpath('~/neuron/hetnet/richardson'));

% % THIS WAS ONLY NEEDED IN MERRY AND BRUCE
% addpath(genpath('~/dmf/libraries'));
% addpath('~/dmf/data_an/manduca/ALL_DATA');
% addpath('~/dmf/neuron/AL');
% addpath('~/dmf/neuron/calab');
% addpath('~/dmf/neuron/exctblt');
% addpath('~/dmf/neuron/isian');
% addpath('~/dmf/neuron/isirm');
% addpath('~/dmf/neuron/lsm');
% addpath('~/dmf/neuron/preference');
% addpath('~/dmf/neuron/stdp');
% addpath('~/dmf/neuron/STG');
% addpath('~/dmf/neuron/ento');
% addpath('~/neuron/2neu');

set(0, 'DefaultAxesFontSize', 20);
set(0, 'DefaultLineLineWidth', 2);
set(0, 'DefaultTextFontSize', 20);
set(0, 'DefaultErrorBarLineWidth', 2);
% set(0, 'DefaultAxesFontSize', 16);
% set(0, 'DefaultLineLineWidth', 1);
% set(0, 'DefaultTextFontSize', 16);
% set(0, 'DefaultAxesFontSize', 30);
% set(0, 'DefaultLineLineWidth', 2);
% set(0, 'DefaultTextFontSize', 30);
% set(0, 'DefaultAxesXlabelFontSize', 12);
% set(0, 'DefaultAxesYlabelFontSize', 12);
% set(0, 'DefaultAxesZlabelFontSize', 12);

set(0, 'defaultFigureColor',[1 1 1]);
