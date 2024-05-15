% Generate random data to simulate an autoregressive process
n = 100; % Number of samples
noise = 0.1 * randn(n, 1); % Noise component

% True autoregression coefficients
a1 = 0.5;
a2 = -0.3;
a3 = 0.2;


w = zeros(3);
w(2,3)=1;
w(1,2)=1;

% Create the autoregressive model
x = zeros(n, 1);
z = zeros(n, 1);
y = zeros(n, 1);

for t = 4:n
    x(t) = a1 * x(t-1) + a2 * x(t-2) + a3 * x(t-3) + noise(t) ;
    y(t) = a1 * y(t-1) + a2 * y(t-2) + a3 * y(t-3) + noise(t) + w(1,2)*x(t-1);
    z(t) = a1 * z(t-1) + a2 * z(t-2) + a3 * z(t-3) + noise(t) + w(2,3)*y(t-1);
end
%Up to this point unregularized model


% Obtain the precision matrix through regularization
data = [x, y, z]; % Combine the data x, y, z into one matrix
lambda = 0.001; % Regularization parameter
S=(cov(data));
theta_o=inv(S);
approximate = 0;
verbose = 0;
penalDiag = 1;
tolThreshold = 1e-4;
maxIter = 1e4;
w=S;
theta=theta_o;
warmInit=true;
S;
tic
[W, Theta, iter, avgTol, hasError] = GraphicalLasso(data, lambda, [], approximate, warmInit, verbose, penalDiag, tolThreshold, maxIter, w, theta);
p=zeros(3);
[nRows, nColumns] = size(Theta);
correlation_matrix=corr(data);
par=partialcorr(data);
toc
for i = 1:nRows
    for j = 1:nColumns
        if i~=j
            p(i,j)= -Theta(i,j)/sqrt(Theta(i,i)*Theta(j,j));
         end
         if i==j
            correlation_matrix(i,j)= NaN;
            p(i,j)=NaN;
            par(i,j)=NaN;
         end
    end
end
figure;
position1 = [0.05, 0.65, 0.4, 0.25];%Positions for the plots
position2 = [0.55, 0.65, 0.4, 0.25];
position3 = [0.05, 0.35, 0.4, 0.25];
position4 = [0.55, 0.35, 0.4, 0.25];
position5 = [0.05, 0.05, 0.4, 0.25];
position6 = [0.55, 0.05, 0.4, 0.25];

subplot('Position', position1);
imAlpha=ones(size(correlation_matrix));
imAlpha(isnan(correlation_matrix))=0;
imagesc(correlation_matrix,'AlphaData',imAlpha);
set(gca,'color',0.95*[1 1 1]);
colorbar;
title("Correlation");
set(gca,'CLim',[-1 1]);
axis square;

subplot('Position', position2);
imAlpha=ones(size(par));
imAlpha(isnan(par))=0;
imagesc(par,'AlphaData',imAlpha);
set(gca,'color',0.95*[1 1 1]);
colorbar;
title("Partial correlation");
set(gca,'CLim',[-1 1]);
axis square;





subplot('Position', position3);
imAlpha=ones(size(p));
imAlpha(isnan(p))=0;
imagesc(p,'AlphaData',imAlpha);
set(gca,'color',0.95*[1 1 1]);
colorbar;
title("Glasso with lambda="+lambda);
set(gca,'CLim',[-1 1]);
axis square;

lambda = 0.003; % Regularization parameter
S=(cov(data));
theta_o=inv(S);
approximate = 0;
verbose = 0;
penalDiag = 1;
tolThreshold = 1e-4;
maxIter = 1e4;
w=S;
theta=theta_o;
warmInit=true;
S;
tic
[W, Theta, iter, avgTol, hasError] = GraphicalLasso(data, lambda, [], approximate, warmInit, verbose, penalDiag, tolThreshold, maxIter, w, theta);
p=zeros(3);
[nRows, nColumns] = size(Theta);
correlation_matrix=corr(data);
par=partialcorr(data);
toc


for i = 1:nRows
    for j = 1:nColumns
        if i~=j
            p(i,j)= -Theta(i,j)/sqrt(Theta(i,i)*Theta(j,j));
         end
         if i==j
            correlation_matrix(i,j)= NaN;
            p(i,j)=NaN;
            par(i,j)=NaN;
         end
    end
end
subplot('Position', position4);
imAlpha=ones(size(p));
imAlpha(isnan(p))=0;
imagesc(p,'AlphaData',imAlpha);
set(gca,'color',0.95*[1 1 1]);
colorbar;
title("Glasso with lambda="+lambda);
set(gca,'CLim',[-1 1]);
axis square;

lambda = 0.03; % Regularization parameter
S=(cov(data));
theta_o=inv(S);
approximate = 0;
verbose = 0;
penalDiag = 1;
tolThreshold = 1e-4;
maxIter = 1e4;
w=S;
theta=theta_o;
warmInit=true;
S;
tic
[W, Theta, iter, avgTol, hasError] = GraphicalLasso(data, lambda, [], approximate, warmInit, verbose, penalDiag, tolThreshold, maxIter, w, theta);
p=zeros(3);
[nRows, nColumns] = size(Theta);
correlation_matrix=corr(data);
par=partialcorr(data);
toc


for i = 1:nRows
    for j = 1:nColumns
        if i~=j
            p(i,j)= -Theta(i,j)/sqrt(Theta(i,i)*Theta(j,j));
         end
         if i==j
            correlation_matrix(i,j)= NaN;
            p(i,j)=NaN;
            par(i,j)=NaN;
         end
    end
end
subplot('Position', position5);
imAlpha=ones(size(p));
imAlpha(isnan(p))=0;
imagesc(p,'AlphaData',imAlpha);
set(gca,'color',0.95*[1 1 1]);
colorbar;
title("Glasso with lambda="+lambda);
set(gca,'CLim',[-1 1]);
axis square;

lambda = 0.1; % Regularization parameter
S=(cov(data));
theta_o=inv(S);
approximate = 0;
verbose = 0;
penalDiag = 1;
tolThreshold = 1e-4;
maxIter = 1e4;
w=S;
theta=theta_o;
warmInit=true;
S;
tic
[W, Theta, iter, avgTol, hasError] = GraphicalLasso(data, lambda, [], approximate, warmInit, verbose, penalDiag, tolThreshold, maxIter, w, theta);
p=zeros(3);
[nRows, nColumns] = size(Theta);
correlation_matrix=corr(data);
par=partialcorr(data);
toc


for i = 1:nRows
    for j = 1:nColumns
        if i~=j
            p(i,j)= -Theta(i,j)/sqrt(Theta(i,i)*Theta(j,j));
         end
         if i==j
            correlation_matrix(i,j)= NaN;
            p(i,j)=NaN;
            par(i,j)=NaN;
         end
    end
end
subplot('Position', position6);
imAlpha=ones(size(p));
imAlpha(isnan(p))=0;
imagesc(p,'AlphaData',imAlpha);
set(gca,'color',0.95*[1 1 1]);
colorbar;
title("Glasso with lambda="+lambda);
set(gca,'CLim',[-1 1]);
axis square;


% Create an additional axis for the color bar
colorbar_axes = axes('Position', [0.95, 0.05, 0.02, 0.9]);

% Adjust the axis limit and hide ticks
set(colorbar_axes, 'YLim', [0 1], 'YTick', [], 'Visible', 'off');

% Add the color bar to the new axis
colorbar('peer', colorbar_axes);
