%Read adra images
for n = 1:6
    path = strcat('adra/banda', int2str(n), '.tif');
    adraImg = imread(path);
    adraImg = im2double(adraImg);
    adraImages(:,:,n) = adraImg;
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%Applu Hotelling transform
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Calculate Covariance Matrix of pixel vectors
sizeVector = size(adraImages);
for i = 1:sizeVector(1)
    for j = 1:sizeVector(2)
        vector = adraImages(i,j,:);
        vector = squeeze(vector(1,1,:));
        covMatrix(i,j) = cov(vector);
    end
end

%Get Eigenvalues and Eigenvectors
[eigenVectors, eigenValues] = eig(covMatrix);

%Get A = covariance matrix ordered by eigenvalues (max to min)
A = eigenVectors;

%Apply Hotelling on pixel vectors y = A(x-m)
for n = 1:6
    for i = 1:sizeVector(1)
        for j = 1:sizeVector(2)
            vector = adraImages(i,j,:);
            vector = squeeze(vector(1,1,:)).';
            hotellingImage(i,j,:) = A * (vector - adraImages(i,j,n) );
        end
    end
end

