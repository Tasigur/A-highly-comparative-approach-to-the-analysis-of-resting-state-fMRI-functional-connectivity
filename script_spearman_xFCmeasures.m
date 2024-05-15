%load('Escritorio/TFM/var_exp_all_170621_4.mat');
load('var_exp_all_170621_4.mat')
original_size = size(var_exp_all);

rows = floor(original_size(1) / 4);

% Create variance matrices for each FC measure
var_exp_ar_mls2 = zeros(rows, original_size(2));
var_exp_ar_mls = zeros(rows, original_size(2));
var_exp_corr = zeros(rows, original_size(2));
var_exp_partialcorr = zeros(rows, original_size(2));


iFC=0;
I_armls2=0;
I_armls=0;
I_corr=0;
I_partialcorr=0;


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
                           switch measvect{imeas}
                               % For each of the created matrices, we add their corresponding rows
                               % from the matrix containing all of them
                                case 'ar_mls2'
                                    I_armls2=I_armls2+1;
                                    var_exp_ar_mls2(I_armls2,:) = var_exp_all(iFC, :);
                                case 'ar_mls'
                                    I_armls=I_armls+1;
                                    var_exp_ar_mls(I_armls,:) = var_exp_all(iFC, :);
                                case 'corr'
                                    I_corr=I_corr+1;
                                    var_exp_corr(I_corr,:) = var_exp_all(iFC, :);
                                case 'partialcorr'
                                    I_partialcorr=I_partialcorr+1;
                                    var_exp_partialcorr(I_partialcorr,:) = var_exp_all(iFC, :);
                           end


                    end
                end
            end
        end
    end
end





[rows, columns] = size(var_exp_ar_mls2);

correlation_armls2_armls = zeros(rows, 1);
correlation_armls2_corr= zeros(rows, 1);
correlation_armls2_partialcorr= zeros(rows, 1);
correlation_armls_corr= zeros(rows, 1);
correlation_armls_partialcorr= zeros(rows, 1);
correlation_corr_partialcorr= zeros(rows, 1);

% For each possible pair of FC measures we calculate their Spearman correlation
for i = 1:rows
        correlation_armls2_armls(i,:) = corr(var_exp_ar_mls2(i, :)', var_exp_ar_mls(i, :)', 'type', 'Spearman', 'rows', 'complete');
        correlation_armls2_corr(i,:) = corr(var_exp_ar_mls2(i, :)', var_exp_corr(i, :)', 'type', 'Spearman', 'rows', 'complete');        
        correlation_armls2_partialcorr(i,:) = corr(var_exp_ar_mls2(i, :)', var_exp_partialcorr(i, :)', 'type', 'Spearman', 'rows', 'complete');
        correlation_armls_corr(i,:) = corr(var_exp_ar_mls(i, :)', var_exp_corr(i, :)', 'type', 'Spearman', 'rows', 'complete');
        correlation_armls_partialcorr(i,:) = corr(var_exp_ar_mls(i, :)', var_exp_partialcorr(i, :)', 'type', 'Spearman', 'rows', 'complete');
        correlation_corr_partialcorr(i,:) = corr(var_exp_corr(i, :)', var_exp_partialcorr(i, :)', 'type', 'Spearman', 'rows', 'complete');

end

% Remove possible empty or erroneous values (NaN values)
correlation_armls2_armls=correlation_armls2_armls(~isnan(correlation_armls2_armls));
correlation_armls2_corr=correlation_armls2_corr(~isnan(correlation_armls2_corr));
correlation_armls2_partialcorr=correlation_armls2_partialcorr(~isnan(correlation_armls2_partialcorr));
correlation_armls_corr=correlation_armls_corr(~isnan(correlation_armls_corr));
correlation_armls_partialcorr=correlation_armls_partialcorr(~isnan(correlation_armls_partialcorr));
correlation_corr_partialcorr=correlation_corr_partialcorr(~isnan(correlation_corr_partialcorr));

% For each pair matrix,we calculate mean, standard deviation, percentage of
% positive, negative, and zero values.
analysis_armls2_armls = [
    mean(correlation_armls2_armls),
    std(correlation_armls2_armls), 
    sum(correlation_armls2_armls > 0) / size(correlation_armls2_armls, 1), 
    sum(correlation_armls2_armls < 0) / size(correlation_armls2_armls, 1), 
    sum(correlation_armls2_armls == 0) / size(correlation_armls2_armls, 1) 
];

analysis_armls2_corr = [
    mean(correlation_armls2_corr),
    std(correlation_armls2_corr),
    sum(correlation_armls2_corr > 0) / size(correlation_armls2_corr, 1),
    sum(correlation_armls2_corr < 0) / size(correlation_armls2_corr, 1),
    sum(correlation_armls2_corr == 0) / size(correlation_armls2_corr, 1)
];

analysis_armls2_partialcorr = [
    mean(correlation_armls2_partialcorr),
    std(correlation_armls2_partialcorr),
    sum(correlation_armls2_partialcorr > 0) / size(correlation_armls2_partialcorr, 1),
    sum(correlation_armls2_partialcorr < 0) / size(correlation_armls2_partialcorr, 1),
    sum(correlation_armls2_partialcorr == 0) / size(correlation_armls2_partialcorr, 1)
];

analysis_armls_corr = [
    mean(correlation_armls_corr),
    std(correlation_armls_corr),
    sum(correlation_armls_corr > 0) / size(correlation_armls_corr, 1),
    sum(correlation_armls_corr < 0) / size(correlation_armls_corr, 1),
    sum(correlation_armls_corr == 0) / size(correlation_armls_corr, 1)
];

analysis_armls_partialcorr = [
    mean(correlation_armls_partialcorr),
    std(correlation_armls_partialcorr),
    sum(correlation_armls_partialcorr > 0) / size(correlation_armls_partialcorr, 1),
    sum(correlation_armls_partialcorr < 0) / size(correlation_armls_partialcorr, 1),
    sum(correlation_armls_partialcorr == 0) / size(correlation_armls_partialcorr, 1)
];

analysis_corr_partialcorr = [
    mean(correlation_corr_partialcorr),
    std(correlation_corr_partialcorr),
    sum(correlation_corr_partialcorr > 0) / size(correlation_corr_partialcorr, 1),
    sum(correlation_corr_partialcorr < 0) / size(correlation_corr_partialcorr, 1),
    sum(correlation_corr_partialcorr == 0) / size(correlation_corr_partialcorr, 1)
];

figure;

subplot(2, 3, 1);
violinplot(correlation_armls2_armls);
xlabel('AR ML2 and AR ML', 'FontSize', 20);

subplot(2, 3, 2);
violinplot(correlation_armls2_corr);
xlabel('AR ML2 and Correlation', 'FontSize', 20);

subplot(2, 3, 3);
violinplot(correlation_armls2_partialcorr);
xlabel('AR ML2 and Partial Correlation', 'FontSize', 20);

subplot(2, 3, 4);
violinplot(correlation_armls_corr);
xlabel('AR ML and Correlation', 'FontSize', 20);

subplot(2, 3, 5);
violinplot(correlation_armls_partialcorr);
xlabel('AR ML and Partial Correlation', 'FontSize',20);

subplot(2, 3, 6);
violinplot(correlation_corr_partialcorr);
xlabel('Correlation and Partial Correlation', 'FontSize', 20);