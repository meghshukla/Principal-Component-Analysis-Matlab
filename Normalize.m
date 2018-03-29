function [Data,mu] = Normalize(X)
%Subtracts the mean for each band from image
mu=mean(X);
Data=X;
dim_size=size(X);
for i=1:dim_size(1)
    Data(i,:)=Data(i,:)-mu;
end

