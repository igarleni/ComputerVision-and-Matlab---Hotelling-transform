%Read images
for i = 1:6
    path = strcat('adra/banda', int2str(i), '.tif');
    adraImg = imread(path);
    adraImg = im2double(adraImg);
    adraImages(:,:,i) = adraImg;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%Create Hotelling transform

%Calculate Covariance Matrix
sizeVector = size(adraImages);
for i = 1:sizeVector(1)
    for j = 1:sizeVector(2)
        vector = adraImages(i,j,:);
        vector = squeeze(vector(1,1,:));
        covMatrix(i,j) = cov(vector);
    end
end