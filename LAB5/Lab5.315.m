% Load images.
close all;
clear all;
folder = "Z:\RSN\LAB5\LadyFixedFifteen";
buildingDir = fullfile(folder, '*.jpg');
buildingScene = imageDatastore(buildingDir);

% Display images to be stitched.
montage(buildingScene.Files)


%%
rotationAngle = -90;
windowSize = [1 1];
NoOfPoints = 2000;
% Read the first image from the image set.
I = imrotate(readimage(buildingScene,1),rotationAngle);

%undistort Images
K = [3284.595162302226981 0 0; 0 3289.623517078526220 0 ; 1999.500000000000000 1499.500000000000000 1 ];
RadialDistortion = [-0.004323 0.01383 -0];
TangentialDistortion = [-0.001452 0.00201];
%cameraParams = cameraParameters("k",k,"RadialDistortion",RadialDistortion,"TangentialDistortion",TangentialDistortion);
cameraParams = cameraParameters("IntrinsicMatrix",K,"RadialDistortion",RadialDistortion);
J = undistortImage(I,cameraParams,'OutputView','full');


% Initialize features for I(1)
grayImage = im2gray(J);
%[y,x,m] = harris(grayImage);
[y,x,m] = harris(grayImage,NoOfPoints,'tile',windowSize,'disp');
points = cornerPoints([x,y]);
[features, points] = extractFeatures(grayImage,points);

% Initialize all the transforms to the identity matrix. Note that the
% projective transform is used here because the building images are fairly
% close to the camera. Had the scene been captured from a further distance,
% an affine transform would suffice.
numImages = numel(buildingScene.Files);
tforms(numImages) = projective2d(eye(3));

% Initialize variable to hold image sizes.
imageSize = zeros(numImages,2);

% Iterate over remaining image pairs
for n = 2:numImages
    
    % Store points and features for I(n-1).
    pointsPrevious = points;
    featuresPrevious = features;
        
    % Read I(n).
    I = imrotate(readimage(buildingScene, n),rotationAngle);
    J = undistortImage(I,cameraParams,'OutputView','full');

    % Convert image to grayscale.
    grayImage = im2gray(J);    
    
    % Save image size.
    imageSize(n,:) = size(grayImage);
    
    % Detect and extract Harris features for I(n).
    %points = detectSURFFeatures(grayIma ge);    
    [y,x,m] = harris(grayImage, NoOfPoints, 'tile', windowSize, 'disp');
    points = cornerPoints([x,y]);    
    [features, points] = extractFeatures(grayImage, points);
  
    % Find correspondences between I(n) and I(n-1).
    indexPairs = matchFeatures(features, featuresPrevious, 'Unique', true);
       
    matchedPoints = points(indexPairs(:,1), :);
    matchedPointsPrev = pointsPrevious(indexPairs(:,2), :);        
    
    % Estimate the transformation between I(n) and I(n-1).
    tforms(n) = estimateGeometricTransform2D(matchedPoints, matchedPointsPrev,...
        'projective', 'Confidence', 99.9, 'MaxNumTrials', 2000);
    
    % Compute T(n) * T(n-1) * ... * T(1)
    tforms(n).T = tforms(n).T * tforms(n-1).T; 
end

%%

% Compute the output limits for each transform.
for i = 1:numel(tforms)           
    [xlim(i,:), ylim(i,:)] = outputLimits(tforms(i), [1 imageSize(i,2)], [1 imageSize(i,1)]);    
end

%%

avgXLim = mean(xlim, 2);
[~,idx] = sort(avgXLim);
centerIdx = floor((numel(tforms)+1)/2);
centerImageIdx = idx(centerIdx); 

%%
Tinv = invert(tforms(centerImageIdx));
for i = 1:numel(tforms)    
    tforms(i).T = tforms(i).T * Tinv.T;
end

%%
for i = 1:numel(tforms)           
    [xlim(i,:), ylim(i,:)] = outputLimits(tforms(i), [1 imageSize(i,2)], [1 imageSize(i,1)]);
end

maxImageSize = max(imageSize);

% Find the minimum and maximum output limits. 
xMin = min([1; xlim(:)]);
xMax = max([maxImageSize(2); xlim(:)]);

yMin = min([1; ylim(:)]);
yMax = max([maxImageSize(1); ylim(:)]);

% Width and height of panorama.
width  = round(xMax - xMin);
height = round(yMax - yMin);

% Initialize the "empty" panorama.
panorama = zeros([height width 3], 'like', I);

%%

blender = vision.AlphaBlender('Operation', 'Binary mask', ...
    'MaskSource', 'Input port');  

% Create a 2-D spatial reference object defining the size of the panorama.
xLimits = [xMin xMax];
yLimits = [yMin yMax];
panoramaView = imref2d([height width], xLimits, yLimits);

% Create the panorama.
for i = 1:numImages
    
    J = imrotate(readimage(buildingScene, i),rotationAngle);  
    I = undistortImage(J,cameraParams,'OutputView','full');

   
    % Transform I into the panorama.
    warpedImage = imwarp(I, tforms(i), 'OutputView', panoramaView);
                  
    % Generate a binary mask.    
    mask = imwarp(true(size(I,1),size(I,2)), tforms(i), 'OutputView', panoramaView);
    
    % Overlay the warpedImage onto the panorama.
    panorama = step(blender, panorama, warpedImage, mask);
end

figure
imshow(panorama)
