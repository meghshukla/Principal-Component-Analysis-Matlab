clc;
close all;
clear all;
a=load('E:\IIT Bombay\IITB\Sem1\Principles of Satellite Images\PCT_project\SatelliteImage\Indian_pines.mat'); %Replace file with Indian_pines.mat / Salinas_corrected.mat
Image=a.indian_pines;    %Replace with indian_pines /  salinas_corrected                                                         
bandmatrix=Band_matrix(Image);           %Collecting each band data into single column  
[NormalizedBand, mu]=Normalize(bandmatrix);    %Making mean of the data = 0
CovarianceMatrix=cov(NormalizedBand);    %Covariance Matrix to estimate eigenvalue and eigenvector
e=eig(CovarianceMatrix);                 %Obtain eigenvalues in single column  
[V,D]=eig(CovarianceMatrix);             %Obtain eigenvectors

%To arrange eigenvectors in decreasing values of variance,
tempMatrix=[e';V];                              %Append eigenvalue to eigenvector matrix
tempMatrix=sortrows(tempMatrix',-1);            %Sort according to eigenvalues
tempMatrix=tempMatrix';
D=tempMatrix(1,:);
tempMatrix(1,:)=[];                             %Delete the eigenvalue row            
V=tempMatrix;               

%TRANSFORM IMAGE INTO PRINCIPAL COMPONENT SPACE
%Please note that we could partially vectorize the computations as Matlab
%does not treat values along 3rd dimension as Array/Matrix and treats them
%as individual values only
Img_size=size(Image);
P_space=ones(Img_size);
for a=1:size(V,2)
    for i=1:Img_size(1)
        for j=1:Img_size(2)
            temp=ones(Img_size(3),1);
            for p=1:Img_size(3)
                temp(p)=Image(i,j,p);
            end
            P_space(i,j,a)=V(:,a)'*temp;     %For every pixel in image, multiply eigenvector and band value for           
        end                                  %that pixel and store in PC as decided by eigenvector
    end
end
        
%Change value of number of PCs to display
%Change 3rd dimension of P_space(,,*) to display corresponding PC
figure(1)
subplot(2,3,1)
Display(Image)
title('FCC')
for i=2:5
    temp=mat2gray(P_space(:,:,i-1));
    subplot(2,3,i)
    imshow(temp)
    title(sprintf('Principal Component : %d',i-1))
end


%CODE TAKES 50 seconds to execute till this part

%Depending on Eigenvectors, we choose number of PCs to retain 
retain=input('Number of Principal Components to retain?');
condition_check=retain<=Img_size(3) && retain>=1;
while condition_check==0
    sprintf('Number of bands to retain is incorrect');
    retain=input('Number of Principal Components to retain?');
    condition_check=retain<=Img_size(3) && retain>=1;
end

%Converting from PC domain back to spectral domain 
V=V(:,1:retain);
P_space=P_space(:,:,1:retain);
spectral_space=zeros(size(Image));
for k=1:size(V,1)
    for i=1:Img_size(1)
        for j=1:Img_size(2)
            temp=ones(size(P_space,3),1);
            for a=1:size(P_space,3)
                temp(a)=P_space(i,j,a);
            end
            spectral_space(i,j,k)=V(k,:)*temp;
        end
    end
end


%Adding the mean valuesback to the image
for i=1:size(mu,2)
    spectral_space(:,:,i)=spectral_space(:,:,i)+(mu(i)*ones(Img_size(1),Img_size(2)));
end


subplot(2,3,6)
Display(spectral_space)
title('Reduced space')

%Calculate RMSE values
error=RMSE(Image,spectral_space);
%Display Error as an image
figure(2)
imshow(mat2gray(error))
title('Error due to dimensionality reduction')
