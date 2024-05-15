function xFC=ar_mls2(data,p)

% calculate bivariate AR dFC between every pair of time series in
% data. Calls ar_mls

nt  = size(data,1); % number of time points
ns  = size(data,2); % number of time series

xFC=ones(ns); % diagonal elements will = 1 and will be uninteresting

for i=1:ns-1
    for j=i+1:ns        
        [Y,B,Z,E]=ar_mls([data(:,i),data(:,j)],p);
        xFC(i,j)=B(1,3); % first column gives the bias, not considered here
        xFC(j,i)=B(2,2);
    end
end