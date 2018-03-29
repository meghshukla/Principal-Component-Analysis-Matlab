function Display(X)
%Generating and display standard FCC using band 5,4,3 which is numbered as 50,27,17 for AVIRIS
r=mat2gray(X(:,:,50));               
g=mat2gray(X(:,:,27));
b=mat2gray(X(:,:,17));
FCC=cat(3,r,g,b);
figure(1)
title('False Colour Composite')
imshow(FCC)
end