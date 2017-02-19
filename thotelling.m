%Read images
selection = 1;

if (selection == 1)
    for n = 1:6
        path = strcat('adra/banda', int2str(n), '.tif');
        adraImg = imread(path);
        adraImg = im2double(adraImg);
        adraImages(:,:,n) = adraImg;
    end
else
    index = 1;
    for n = 'a':'e'
        path = strcat('camiones/', n, '.jpg');
        adraImg = imread(path);
        adraImg = rgb2gray(adraImg);
        adraImg = im2double(adraImg);
        adraImages(:,:,index) = adraImg;
        index = index + 1;
    end
end
sizeVector = size(adraImages);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%Applu Hotelling transform
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Mean and expectation mean  of pixel vectors
mean = zeros(1,sizeVector(3), 'double');
for i = 1:sizeVector(1)
    for j = 1:sizeVector(2)
        vector = adraImages(i,j,:);
        vector = squeeze(vector(1,1,:)).';
        mean = mean + vector;
    end
end
mean = mean / sizeVector(3);
expectationMean = (mean') * mean;

%Expectation of pixel vectors
expectation = zeros(sizeVector(3),sizeVector(3), 'double');
for i = 1:sizeVector(1)
    for j = 1:sizeVector(2)
        vector = adraImages(i,j,:);
        vector = squeeze(vector(1,1,:)).';
        expectation = vector' * vector;
    end
end
expectation = expectation / (sizeVector(1) * sizeVector(2));

%Covariance matrix
covMatrix = expectationMean - expectation;

%Get Eigenvalues and Eigenvectors
[eigenVectors, eigenValues] = eig(covMatrix);

%Order eigenVectors by eigenValues
for i = 1:(sizeVector(3)-1)
    for j = (i+1):sizeVector(3)
        if (eigenValues(i,i) > eigenValues(j,j)) 
            aux1 = eigenValues(i,i);
            eigenValues(i,i) = eigenValues(j,j);
            eigenValues(j,j) = aux1;
            
            aux2 = eigenVectors(i,:);
            eigenVectors(i,:) = eigenVectors(j,:);
            eigenVectors(j,:) = aux2;
        end
    end
end

%Apply Hotelling on pixel vectors y = A(x-m)
newAdraImages = adraImages;
for n = 1:sizeVector(3)
    for i = 1:sizeVector(1)
        for j = 1:sizeVector(2)
            vector = adraImages(i,j,:);
            vector = squeeze(vector(1,1,:)).';
            newAdraImages(i,j,:) = 0.30 + (vector - mean) * eigenVectors;
        end
    end
end

figure, subplot(2,3,1), imshow(newAdraImages(:,:,1)),...
    subplot(2,3,2), imshow(newAdraImages(:,:,2)),...
    subplot(2,3,3), imshow(newAdraImages(:,:,3)),...
    subplot(2,3,4), imshow(newAdraImages(:,:,4)),...
    subplot(2,3,5), imshow(newAdraImages(:,:,5)),...
    subplot(2,3,6), imshow(newAdraImages(:,:,6));
    
