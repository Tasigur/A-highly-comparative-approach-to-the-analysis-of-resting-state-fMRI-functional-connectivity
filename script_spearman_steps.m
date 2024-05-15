%load('Escritorio/TFM/var_exp_all_170621_4.mat');
load('var_exp_all_170621_4.mat')

original_size = size(var_exp_all);

half_rows = floor(original_size(1) / 2);

% Create variance matrices for each preprocessing step 
% (one for cases where it's used and one for where it's not)
var_exp_zscore = zeros(half_rows, original_size(2));
var_exp_nozscore = zeros(half_rows, original_size(2));
var_exp_gsr = zeros(half_rows, original_size(2));
var_exp_nogsr = zeros(half_rows, original_size(2));
var_exp_bpf = zeros(half_rows, original_size(2));
var_exp_nobpf = zeros(half_rows, original_size(2));

iFC=0;
I_z=0;
I_noz=0;
I_gsr=0;
I_nogsr=0;
I_bpf=0;
I_nobpf=0;

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
                    % For each of the created matrices, we add their corresponding rows
                    % from the matrix containing all of them
                     switch zsvect{izs}
                                case ''
                                  I_noz=I_noz+1;
                        var_exp_nozscore(I_noz,:) = var_exp_all(iFC, :);
                                case '_z'
                                    I_z=I_z+1;
                        var_exp_zscore(I_z,:) = var_exp_all(iFC, :);
                     end


                     switch gsrvect{igsr}
                            case ''
                               I_nogsr=I_nogsr+1;
                     var_exp_nogsr(I_nogsr,:) = var_exp_all(iFC, :);

                            case '_gsr'
                               I_gsr=I_gsr+1;
                     var_exp_gsr(I_gsr,:) = var_exp_all(iFC, :);
                     end


                          switch bpvect{ibp}
                                case ''
                                  I_nobpf=I_nobpf+1;
                        var_exp_nobpf(I_nobpf,:) = var_exp_all(iFC, :);
                                case '_bp'
                                    I_bpf=I_bpf+1;
                        var_exp_bpf(I_bpf,:) = var_exp_all(iFC, :);
                          end



                    end
                end
            end
        end
    end
end





[rows, columns] = size(var_exp_zscore);
correlation_zscore = zeros(rows, 1);
correlation_gsr= zeros(rows, 1);
correlation_bpf= zeros(rows, 1);

% For each preprocessing step, calculate the Spearman correlation 
% between using it and not using it
for i = 1:rows
        correlation_zscore(i,:) = corr(var_exp_zscore(i, :)', var_exp_nozscore(i, :)', 'type', 'Spearman', 'rows', 'complete');
        correlation_gsr(i,:) = corr(var_exp_gsr(i, :)', var_exp_nogsr(i, :)', 'type', 'Spearman', 'rows', 'complete');        
        correlation_bpf(i,:) = corr(var_exp_bpf(i, :)', var_exp_nobpf(i, :)', 'type', 'Spearman', 'rows', 'complete');

end

correlation_zscore=correlation_zscore(~isnan(correlation_zscore));
correlation_gsr=correlation_gsr(~isnan(correlation_gsr));
correlation_bpf=correlation_bpf(~isnan(correlation_bpf));

% For each pair matrix, calculate mean, standard deviation, percentage of
% positive, negative, and zero values.
analysis_zscore=[mean(correlation_zscore),std(correlation_zscore),sum(correlation_zscore > 0)/size(correlation_zscore,1),sum(correlation_zscore < 0)/size(correlation_zscore,1),sum(correlation_zscore == 0)/size(correlation_zscore,1)];
analysis_gsr=[mean(correlation_gsr),std(correlation_gsr),sum(correlation_gsr > 0)/size(correlation_gsr,1),sum(correlation_gsr < 0)/size(correlation_gsr,1),sum(correlation_gsr == 0)/size(correlation_gsr,1)];
analysis_bpf=[mean(correlation_bpf),std(correlation_bpf),sum(correlation_bpf > 0)/size(correlation_bpf,1),sum(correlation_bpf < 0)/size(correlation_bpf,1),sum(correlation_bpf == 0)/size(correlation_bpf,1)];


%Violin plot in order to see these correlations


rows_nan = any(isnan(var_exp_zscore), 2);
var_exp_zscore = var_exp_zscore(~rows_nan, :);
vector_zscore=mean(var_exp_zscore);
rows_nan = any(isnan(var_exp_nozscore), 2);
var_exp_nozscore = var_exp_nozscore(~rows_nan, :);
vector_nozscore=mean(var_exp_nozscore);

rows_nan = any(isnan(var_exp_bpf), 2);
var_exp_bpf = var_exp_bpf(~rows_nan, :);
vector_bpf=mean(var_exp_bpf);
rows_nan = any(isnan(var_exp_nobpf), 2);
var_exp_nobpf = var_exp_nobpf(~rows_nan, :);
vector_nobpf=mean(var_exp_nobpf);

rows_nan = any(isnan(var_exp_gsr), 2);
var_exp_gsr = var_exp_gsr(~rows_nan, :);
vector_gsr=mean(var_exp_gsr);
rows_nan = any(isnan(var_exp_nogsr), 2);
var_exp_nobpf = var_exp_nogsr(~rows_nan, :);
vector_nogsr=mean(var_exp_nogsr);

comb_zscore=[vector_nozscore,vector_zscore];
comb_bpf=[vector_nobpf,vector_bpf];
comb_gsr=[vector_nogsr,vector_gsr];


% We do the violin plot for every correlation
figure;

subplot(1, 3, 1);
violinplot(correlation_zscore);
xlabel('Zscore');

subplot(1, 3, 2);
violinplot(correlation_bpf);
xlabel('BPF');


subplot(1, 3, 3);
violinplot(correlation_gsr);
xlabel('GSR');



