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

% vector of sessionvects
sessionvect={'rfMRI_REST1_LR','rfMRI_REST1_RL','rfMRI_REST2_LR','rfMRI_REST2_RL'};

gsrvect={'','_gsr'}; % vector of global signal regression
bpvect={'','_bp'}; % vector of Bandpass filter
zsvect={'','_z'}; % vector of z-score

gsr_legvect={'\neg gsr','   gsr'}; % global signal regression
bp_legvect={'\neg bp','   bp'}; % Bandpass filter
zs_legvect={'\neg zs','   zs'}; % z-score

load([baseDir '/subvect_w_zeros_erg']);
subvectData=setdiff(subvectData,subvect_w_zeros); % Disregard subjects with ROIs that are identically 0 for the time being


output_filename=['calculate_ve_erg_out_' datestr(now, 'ddmmyy_HHMMSS') '.txt']; %Output file
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

% loading xFC

iFC=0;

filename=['var_exp_all_170621_4']; %Output file from script_calculate_ve_erg.m
load([xFCDir '/' filename]);

dist_colors = distinguishable_colors(50); %Defining the colors to print the results (FC measures)
magenta=dist_colors(5,:);
dark_green=dist_colors(7,:);
cyan=dist_colors(10,:);
color_mat(1,:)=magenta;
color_mat(2,:)=dark_green;
color_mat(3,:)=cyan;
color_mat(4,:)=[0 0 0];

face_color_mat(1,:)=[0 0 0];
face_color_mat(2,:)=[1 1 1];

symbol_mat={'^','s','p','h','o'}; %Defining the symbols to print the results (Parcellations)

n_meas=length(measvect); % outer loop
n_parcel=length(parcelvect); % mid-outer
n_gsr=length(gsrvect); % mid
n_bp=length(bpvect); % mid
n_zs=length(zsvect); % mid
n_session=length(sessionvect); % inner

n_in=n_parcel*n_gsr*n_bp*n_zs*n_session;

y_meas_pos=(n_in:n_in:n_in*n_meas)-n_in/2; %Defining the position for the FC measures


color_vect_all=[];% Vectors to save the outline color depending on the FC measure
symbol_vect_all={};% Vectors to save the shape depending on the parcellation
face_color_vect_all=[];% Vectors to save the color depending on the preproccesing steps combination

%We loop for every possible combination and save their outline, color and
%shape combination
for imeas=1:length(measvect)
    meas=measvect{imeas};
    disp(meas);
    for iparcel=1:length(parcelvect)
        parcel=parcelvect(iparcel);
        for igsr=1:length(gsrvect)
            gsr=gsrvect{igsr};
            for ibp=1:length(bpvect)
                bp=bpvect{ibp};
                for izs=1:length(zsvect)
                    zs=zsvect{izs};
                    for isession=1:length(sessionvect)
                        session=sessionvect{isession};
                        iFC=iFC+1;
                        color_vect_all(iFC,:)=color_mat(imeas,:);
                        symbol_vect_all{iFC}=symbol_mat{iparcel};
                        face_color_vect_all(iFC,:)=[igsr ibp izs]-1;
                    end
                end
            end
        end
    end
end


% Display image with scaled colors in order to show the Variance Explained by all the features. 
% The Y-axis is labeled to show to which FC measure corresponds each sample. 
% We save this image in a png. 
figure;
set(gcf,'Color',[1 1 1]);
set(gcf,'Position',[309         904        1782         420]);
imagesc(var_exp_all);
set(gca,'CLim',[0 1]);
set(gca,'Position',[0.0851    0.1822    0.8860    0.7428]);
cbh=colorbar;
xlabel('feature');
xlh = ylabel('xFC method');
xlh.Position(1) = xlh.Position(1) - 2;
for imeas=1:length(measvect)
    text(-2,y_meas_pos(imeas),measvect{imeas},'Interpreter','none','HorizontalAlignment','center','VerticalAlignment','middle','Color',color_mat(imeas,:),'Rotation',90,'Fontsize',13);
end
pos_vect=get(cbh,'Position');
th2=annotation('textbox',[pos_vect(1)+pos_vect(3)+0.01 pos_vect(2)+0.46*pos_vect(4) 0.012 0.046],'String','ve','FontSize',24,'LineStyle','none','VerticalAlignment','middle');

if PLOT.print
    figure_name=[figDir 'var_exp_all_erg'];
    export_fig(gcf,[figure_name '.png']);
end


% Find any row with a NaN and delete it
nan_rows = any(isnan(var_exp_all), 2);
var_exp_all_clean = var_exp_all(~nan_rows, :);

var_exp_all_dist = pdist(var_exp_all_clean);% Calculate pairwise distances between rows of var_exp_all_clean matrix
var_exp_all_link = linkage(var_exp_all_dist, 'single'); % Perform hierarchical clustering using single linkage method
var_exp_all_clust = cluster(var_exp_all_link, 'cutoff', 1.2); % Cluster the data using a distance cutoff of 1.2

% Convert the pairwise distance vector var_exp_all_dist into a square
% distance matrix and save its size
var_exp_all_distmat=squareform(var_exp_all_dist);
NFC=size(var_exp_all_distmat);

icMDS=[];


% Try to perform multidimensional scaling (MDS) to reduce the dimensionality of var_exp_all_distmat to 2 dimensions
try
    if isequal(icMDS,[])
        [xyMDS,stress] = mdscale(var_exp_all_distmat,2,'criterion','metricstress');
        icMDS=xyMDS;
    else
        [xyMDS,stress] = mdscale(var_exp_all_distmat,2,'criterion','metricstress','Start',icMDS);
        icMDS=xyMDS;
    end
catch
    maximumNumberOfTries = 100;
    counter  = 0;
    xyMDS=[];
    while isempty(xyMDS) && counter < maximumNumberOfTries % maximum ~100 tries
        try
            [xyMDS,stress] = mdscale(var_exp_all_distmat,2,'criterion','metricstress','Start','random');
        catch ME
            fprintf([ME.identifier '\n']);
            fprintf([ME.message '\n'])
        end
        counter = counter + 1;
    end
    if isempty(xyMDS)
        fprintf('robust_mdscale: well, seems that some of these points are Really co-located...\n');
    end
end

ff=0.1;

% Plot the MDS results in a 2D scatter plot. Each point represents a combination of different features, 
% and it is plotted according to its MDS coordinates. The shape and color of each point are customized 
% to show which features it represents. The result is saved in a png.

figure;
set(gcf,'Color',[1 1 1]);
disp(NFC(1));
disp(size(xyMDS));
for iFC=1:NFC(1)
    hold on;
    plot(xyMDS(iFC,1),xyMDS(iFC,2),symbol_vect_all{iFC},'Color',color_vect_all(iFC,:),'MarkerFaceColor',face_color_vect_all(iFC,:),'MarkerSize',20);
end
axis equal;
axis off;
xlim_vect=xlim;
ylim_vect=ylim;
xwidth=xlim_vect(2)-xlim_vect(1);
ywidth=ylim_vect(2)-ylim_vect(1);
xlim_vect=[xlim_vect(1)-1.38*ff*xwidth,xlim_vect(2)+1.38*ff*xwidth];
ylim_vect=[ylim_vect(1)-ff*ywidth,ylim_vect(2)+ff*ywidth];
plot(xlim_vect,ylim_vect(1).*ones(1,2),'k','LineWidth',2);
plot(xlim_vect,ylim_vect(2).*ones(1,2),'k','LineWidth',2);
plot(xlim_vect(1).*ones(1,2),ylim_vect,'k','LineWidth',2);
plot(xlim_vect(2).*ones(1,2),ylim_vect,'k','LineWidth',2);
set(gcf,'Position',[1           1        1920*5         970*5]);
if PLOT.print
    figure_name=[figDir 'var_exp_all_erg_mds_metric'];
    export_fig(gcf,[figure_name '.png']);
end
hold off;
stress



% Plot a dendrogram to visualize hierarchical clustering of features.Saved as a png
figure;
set(gcf,'Color',[1 1 1]);
dendrogram(var_exp_all_link,0); % trying to display the whole tree
set(gcf,'Position',[1000         392        1476         942]);
if PLOT.print
    figure_name=[figDir 'var_exp_all_erg_dendro'];
    export_fig(gcf,[figure_name '.png']);
end



% Plot a polar dendrogram to visualize hierarchical clustering of features.The
% nodes are customized to show which combination of features it
% corresponds to it. Saved as a png
figure;
set(gcf,'Color',[1 1 1]);
[H,T,outperm] = mypolardendrogram(var_exp_all_link,0); % trying to display the whole tree
zoom(0.8);
view(2);

xrange=size(var_exp_all,1);
minx=0;
for iFC=1:NFC(1)
    iFC_perm=outperm(iFC);
    [x,y]=pol2cart((((iFC-minx)/xrange)*(pi*11/6))+(pi*1/12),1.1);
    plot(x,y,symbol_vect_all{iFC_perm},'Color',color_vect_all(iFC_perm,:),'MarkerFaceColor',face_color_vect_all(iFC_perm,:),'MarkerSize',20);
    hold on;
end
set(gcf,'Position',[1000         392        942*6         942*6]);
if PLOT.print
    figure_name=[figDir 'var_exp_all_erg_polardendro_sym'];
    export_fig(gcf,[figure_name '.png']);
end



% Plot a dendrogram to visualize hierarchical clustering of features. The
% nodes are customized to show which combination of features it
% corresponds to it. Saved as a png.
figure;
set(gcf,'Color',[1 1 1]);
[H,T,outperm] = dendrogram(var_exp_all_link,0); % trying to display the whole tree
hold on;
set(gca,'XLim',[0 size(var_exp_all,1)+1]);
set(gca,'XTickLabel',{'','','','',''})
sa=axes('Position',[0.1300    0.0600    0.7750    0.05]);
axis off;
for iFC=1:NFC(1)
    iFC_perm=outperm(iFC);
    plot(iFC,-0.1,symbol_vect_all{iFC_perm},'Color',color_vect_all(iFC_perm,:),'MarkerFaceColor',face_color_vect_all(iFC_perm,:),'MarkerSize',20);
    hold on;
end
set(sa,'XLim',[0 size(var_exp_all,1)+1]);
set(gcf,'Position',[1000         392        14760         942]); % trying to make it much wider
axis off;
if PLOT.print
    figure_name=[figDir 'var_exp_all_erg_dendro_sym'];
    export_fig(gcf,[figure_name '.png']);
end


% Display image with scaled colors in order to show the Variance Explained by all the features. 
% The Y-axis is labeled to show to which FC measure corresponds each sample and to show to which combination of features it corresponds. 
% We save this image in a png. 
figure;
set(gcf,'Color',[1 1 1]);
set(gcf,'Position',[309         904        1782         11000]);
imagesc(var_exp_all);
set(gca,'CLim',[0 1]);
set(gca,'Position',[0.0851    0.1822    0.8860    0.7428]);
cbh=colorbar;
xlabel('feature');
xlh = ylabel('xFC method');
xlh.Position(1) = xlh.Position(1) - 2;
for imeas=1:length(measvect)
    text(-2,y_meas_pos(imeas),measvect{imeas},'Interpreter','none','HorizontalAlignment','center','VerticalAlignment','middle','Color',color_mat(imeas,:),'Rotation',90);
end
pos_vect=get(cbh,'Position');

th2=annotation('textbox',[pos_vect(1)+pos_vect(3)+0.01 pos_vect(2)+0.46*pos_vect(4) 0.012 0.046],'String','ve','FontSize',24,'LineStyle','none','VerticalAlignment','middle');

set(gca,'YTickLabel',{'','','','',''});
ylim_vect=get(gca,'YLim');
ba=gca;
sa=axes('Position',[0.0651    0.1822    0.02    0.7428]);
set(sa,'YDir','reverse'); % to agree with ba's YDir
for iFC=1:NFC(1)
    plot(-0.1,iFC,symbol_vect_all{iFC},'Color',color_vect_all(iFC,:),'MarkerFaceColor',face_color_vect_all(iFC,:),'MarkerSize',8);
    hold on;
end
set(sa,'YDir','reverse'); % to agree with ba's YDir
set(sa,'YLim',ylim_vect);
axis off;

if PLOT.print
    figure_name=[figDir 'var_exp_all_erg_sym'];
    export_fig(gcf,[figure_name '.png']);
end



% keyboard;

%return
%exit


% Create a legend figure with text labels and symbols
% and save it as a png 

xtext=[1 4.5 10.5];
ytext1=1:0.3:2.5;
ytext2=1:0.28:2.96;
ytext3=1:0.3:2.5;

i_preprocess=0;
for igsr=1:length(gsrvect)
    gsr=gsr_legvect{igsr};
    for ibp=1:length(bpvect)
        bp=bp_legvect{ibp};
        for izs=1:length(zsvect)
            zs=zs_legvect{izs};
            i_preprocess=i_preprocess+1;
            preprocessstringvect{i_preprocess}=[gsr ' ' bp ' ' zs];
        end
    end
end
parcelstringvect=parcelvect;
xoff=0.6;

figure;
set(gca,'YDir','reverse');
for imeas=1:length(measvect)
    meas=measvect{imeas};
    th=text(xtext(1),ytext1(imeas),meas,'FontUnits','normalized','FontSize',0.1,'Color',color_mat(imeas,:),'Interpreter','none','HorizontalAlignment','left','VerticalAlignment','middle');
    hold on;
end
i_preprocess=0;
for igsr=1:length(gsrvect)
    gsr=gsrvect{igsr};
    for ibp=1:length(bpvect)
        bp=bpvect{ibp};
        for izs=1:length(zsvect)
            zs=zsvect{izs};
            i_preprocess=i_preprocess+1;
            plot(xtext(2),ytext2(i_preprocess),symbol_mat{1},'Color',[0 0 0],'MarkerFaceColor',[igsr ibp izs]-1,'MarkerSize',20);
            th=text(xtext(2)+xoff,ytext2(i_preprocess),preprocessstringvect{i_preprocess},'FontUnits','normalized','FontSize',0.1,'Color',[0 0 0],'Interpreter','tex','HorizontalAlignment','left','VerticalAlignment','middle');
        end
    end
end

for iparcel=1:length(parcelvect)
    parcel=parcelvect(iparcel);
    plot(xtext(3),ytext3(iparcel),symbol_mat{iparcel},'Color',[0 0 0],'MarkerFaceColor',[1 1 1],'MarkerSize',20);
    th=text(xtext(3)+xoff,ytext3(iparcel),parcelstringvect{iparcel},'FontUnits','normalized','FontSize',0.1,'Color',[0 0 0],'Interpreter','none','HorizontalAlignment','left','VerticalAlignment','middle');
end
xlim([0 14]);
ylim([0.7 2.8]);
set(gcf,'Position',[1000         914        1070         420]);
axis off;
figure_name=[figDir 'var_exp_all_erg_legend'];
export_fig(gcf,[figure_name '.png']);





% keyboard;

