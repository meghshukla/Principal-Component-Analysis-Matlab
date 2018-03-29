function bm = Band_matrix(X)
%Converts image into a single column for each band from 1 to max band number
dim_image=size(X);
bm=ones(dim_image(1)*dim_image(2),dim_image(3));
for i=1:dim_image(3)
    temp=X(:,:,i);
    temp=temp(:);
    bm(:,i)=temp;
end

% %Removes the black margin in satellite images since they are not sensor values
% i=1;
% z=zeros(1,dim_image(3));
% rows=dim_image(1)*dim_image(2);
% while i<=rows
%     if sum(bm(i,:)==z)==dim_image(3)
%         bm(i,:)=[];
%         i=i-1;
%         rows=rows-1;
%     end
%     i=i+1;
% end

        
        
        
            
