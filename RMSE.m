function rmse = RMSE(X,Y)
%Calculates the Root Mean Square Error, measures loss of information due to
%Dimensionality Reduction
X=mat2gray(X);
Y=mat2gray(Y);
rmse=zeros(size(X,1),size(X,2));
for k=1:size(X,3)
   rmse=rmse+((X(:,:,k)-Y(:,:,k)).^2);
end
rmse=((rmse./size(X,3)).^(1/2));
