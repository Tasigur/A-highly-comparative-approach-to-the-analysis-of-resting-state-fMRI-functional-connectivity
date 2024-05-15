%load('Escritorio/TFM/var_exp_all_170621_4.mat');
load('var_exp_all_170621_4.mat')

original_size = size(var_exp_all);

rows = floor(original_size(1) / 5);

% We create variance matrices for each parcellation
var_exp_Schaefer100 = zeros(rows, original_size(2));
var_exp_Schaefer200 = zeros(rows, original_size(2));
var_exp_Schaefer400 = zeros(rows, original_size(2));
var_exp_Schaefer800 = zeros(rows, original_size(2));
var_exp_Glasser360 = zeros(rows, original_size(2));



iFC=0;
I_100=0;
I_200=0;
I_400=0;
I_800=0;
I_360=0;

for imeas=1:length(measvect)
    meas=measvect{imeas};
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
                           switch parcelvect{iparcel}
                               % For each of the created matrix, we add their corresponding rows
                               % from the matrix containing all of them
                               case 'Schaefer100'
                                    I_100=I_100+1;
                                    var_exp_Schaefer100(I_100,:) = var_exp_all(iFC, :);
                                case 'Schaefer200'
                                    I_200=I_200+1;
                                    var_exp_Schaefer200(I_200,:) = var_exp_all(iFC, :);
                                case 'Schaefer400'
                                    I_400=I_400+1;
                                    var_exp_Schaefer400(I_400,:) = var_exp_all(iFC, :);
                                case 'Schaefer800'
                                    I_800=I_800+1;
                                    var_exp_Schaefer800(I_800,:) = var_exp_all(iFC, :);
                               case 'Glasser360'
                                    I_360=I_360+1;
                                    var_exp_Glasser360(I_360,:) = var_exp_all(iFC, :);
                           end


                    end
                end
            end
        end
    end
end





[rows, columns] = size(var_exp_Schaefer100);

correlation_100_200 = zeros(rows, 1);
correlation_100_400= zeros(rows, 1);
correlation_100_800= zeros(rows, 1);
correlation_100_360= zeros(rows, 1);
correlation_200_400= zeros(rows, 1);
correlation_200_800= zeros(rows, 1);
correlation_200_360= zeros(rows, 1);
correlation_400_800= zeros(rows, 1);
correlation_400_360= zeros(rows, 1);
correlation_800_360= zeros(rows, 1);

% For each possible pair of parcellations, we calculate their Spearman correlation
for i = 1:rows
        correlation_100_200(i,:) = corr(var_exp_Schaefer100(i, :)', var_exp_Schaefer200(i, :)', 'type', 'Spearman', 'rows', 'complete');
        correlation_100_400(i,:) = corr(var_exp_Schaefer100(i, :)', var_exp_Schaefer400(i, :)', 'type', 'Spearman', 'rows', 'complete');        
        correlation_100_800(i,:) = corr(var_exp_Schaefer100(i, :)', var_exp_Schaefer800(i, :)', 'type', 'Spearman', 'rows', 'complete');
        correlation_100_360(i,:) = corr(var_exp_Schaefer100(i, :)', var_exp_Glasser360(i, :)', 'type', 'Spearman', 'rows', 'complete');
        correlation_200_400(i,:) = corr(var_exp_Schaefer200(i, :)', var_exp_Schaefer400(i, :)', 'type', 'Spearman', 'rows', 'complete');
        correlation_200_800(i,:) = corr(var_exp_Schaefer200(i, :)', var_exp_Schaefer800(i, :)', 'type', 'Spearman', 'rows', 'complete');
        correlation_200_360(i,:) = corr(var_exp_Schaefer200(i, :)', var_exp_Glasser360(i, :)', 'type', 'Spearman', 'rows', 'complete');
        correlation_400_800(i,:) = corr(var_exp_Schaefer400(i, :)', var_exp_Schaefer800(i, :)', 'type', 'Spearman', 'rows', 'complete');
        correlation_400_360(i,:) = corr(var_exp_Schaefer400(i, :)', var_exp_Glasser360(i, :)', 'type', 'Spearman', 'rows', 'complete');
        correlation_800_360(i,:) = corr(var_exp_Schaefer800(i, :)', var_exp_Glasser360(i, :)', 'type', 'Spearman', 'rows', 'complete');
end

% Remove possible empty or erroneous values (NaN values)
correlation_100_200=correlation_100_200(~isnan(correlation_100_200));
correlation_100_400=correlation_100_400(~isnan(correlation_100_400));
correlation_100_800=correlation_100_800(~isnan(correlation_100_800));
correlation_100_360=correlation_100_360(~isnan(correlation_100_360));
correlation_200_400=correlation_200_400(~isnan(correlation_200_400));
correlation_200_800=correlation_200_800(~isnan(correlation_200_800));
correlation_200_360=correlation_200_360(~isnan(correlation_200_360));
correlation_400_800=correlation_400_800(~isnan(correlation_400_800));
correlation_400_360=correlation_400_360(~isnan(correlation_400_360));
correlation_800_360=correlation_800_360(~isnan(correlation_800_360));

% For each pair matrix we calculate mean, standard deviation, percentage of
% positive, negative, and zero values.
analysis_100_200 = [
    mean(correlation_100_200),
    std(correlation_100_200),
    sum(correlation_100_200 > 0) / size(correlation_100_200, 1),
    sum(correlation_100_200 < 0) / size(correlation_100_200, 1),
    sum(correlation_100_200 == 0) / size(correlation_100_200, 1)
];

analysis_100_400 = [
    mean(correlation_100_400),
    std(correlation_100_400),
    sum(correlation_100_400 > 0) / size(correlation_100_400, 1),
    sum(correlation_100_400 < 0) / size(correlation_100_400, 1),
    sum(correlation_100_400 == 0) / size(correlation_100_400, 1)
];

analysis_100_800 = [
    mean(correlation_100_800),
    std(correlation_100_800),
    sum(correlation_100_800 > 0) / size(correlation_100_800, 1),
    sum(correlation_100_800 < 0) / size(correlation_100_800, 1),
    sum(correlation_100_800 == 0) / size(correlation_100_800, 1)
];

analysis_100_360 = [
    mean(correlation_100_360),
    std(correlation_100_360),
    sum(correlation_100_360 > 0) / size(correlation_100_360, 1),
    sum(correlation_100_360 < 0) / size(correlation_100_360, 1),
    sum(correlation_100_360 == 0) / size(correlation_100_360, 1)
];

analysis_200_400 = [
    mean(correlation_200_400),
    std(correlation_200_400),
    sum(correlation_200_400 > 0) / size(correlation_200_400, 1),
    sum(correlation_200_400 < 0) / size(correlation_200_400, 1),
    sum(correlation_200_400 == 0) / size(correlation_200_400, 1)
];

analysis_200_800 = [
    mean(correlation_200_800),
    std(correlation_200_800),
    sum(correlation_200_800 > 0) / size(correlation_200_800, 1),
    sum(correlation_200_800 < 0) / size(correlation_200_800, 1),
    sum(correlation_200_800 == 0) / size(correlation_200_800, 1)
];

analysis_200_360 = [
    mean(correlation_200_360),
    std(correlation_200_360),
    sum(correlation_200_360 > 0) / size(correlation_200_360, 1),
    sum(correlation_200_360 < 0) / size(correlation_200_360, 1),
    sum(correlation_200_360 == 0) / size(correlation_200_360, 1)
];

analysis_400_800 = [
    mean(correlation_400_800),
    std(correlation_400_800),
    sum(correlation_400_800 > 0) / size(correlation_400_800, 1),
    sum(correlation_400_800 < 0) / size(correlation_400_800, 1),
    sum(correlation_400_800 == 0) / size(correlation_400_800, 1)
];

analysis_400_360 = [
    mean(correlation_400_360),
    std(correlation_400_360),
    sum(correlation_400_360 > 0) / size(correlation_400_360, 1),
    sum(correlation_400_360 < 0) / size(correlation_400_360, 1),
    sum(correlation_400_360 == 0) / size(correlation_400_360, 1)
];

analysis_800_360 = [
    mean(correlation_800_360),
    std(correlation_800_360),
    sum(correlation_800_360 > 0) / size(correlation_800_360, 1),
    sum(correlation_800_360 < 0) / size(correlation_800_360, 1),
    sum(correlation_800_360 == 0) / size(correlation_800_360, 1)
];


figure;

subplot(2, 2, 1);
violinplot(correlation_100_200);
xlabel('Schaefer100 and Schaefer200', 'FontSize', 20);

subplot(2, 2, 2);
violinplot(correlation_100_400);
xlabel('Schaefer100 and Schaefer400', 'FontSize', 20);

subplot(2, 2, 3);
violinplot(correlation_100_800);
xlabel('Schaefer100 and Schaefer800', 'FontSize', 20);

subplot(2, 2, 4);
violinplot(correlation_100_360);
xlabel('Schaefer100 and Glasser360', 'FontSize', 20);

figure;

subplot(2, 2, 1);
violinplot(correlation_200_400);
xlabel('Schaefer200 and Schaefer400', 'FontSize', 20);

subplot(2, 2, 2);
violinplot(correlation_200_800);
xlabel('Schaefer200 and Schaefer800', 'FontSize', 20);

subplot(2, 2, 3);
violinplot(correlation_200_360);
xlabel('Schaefer200 and Glasser360', 'FontSize', 20);

subplot(2, 2, 4);
violinplot(correlation_400_800);
xlabel('Schaefer400 and Schaefer800', 'FontSize', 20);

figure;

subplot(1, 2, 1);
violinplot(correlation_400_360);
xlabel('Schaefer200 and Glasser360', 'FontSize', 20);

subplot(1, 2, 2);
violinplot(correlation_800_360);
xlabel('Schaefer800 and Glasser360', 'FontSize', 20);

