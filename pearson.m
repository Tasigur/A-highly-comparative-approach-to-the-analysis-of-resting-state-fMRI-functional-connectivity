function xFC=pearson(data)

% calculate Pearson correlation between every pair of time series in
% data... not needed, corr already does that on the whole matrix at once

nt  = size(data,1);
ns  = size(data,2);

for i=1:ns-1
    for j=i+1:ns
        xFC(i,j)=corr(data(:,i),data(:,j));
        xFC(j,i)=xFC(i,j);
    end
end