function dist = pdist(X)
N = size(X,1);
D = zeros(N,'like',X);
for n=1:N
    D(:,n) = sqrt(sum((X-X(n,:)).^2,2));
end
dist = squareform(D);
end
