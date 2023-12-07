% Read input image as a grayscale image 
inputImage = rgb2gray(imread('input.jpg'));

imDim = size(inputImage);
rowSize = imDim(1);
colSize = imDim(2); 

% Sharpen the image
improvedImage = sharpImage(inputImage);

% Improve the contrast of the image
improvedImage = histeq(improvedImage);


% subplot(1,2,1)
% imshow(inputImage);
% subplot(1,2,2)
% imshow(improvedImage);

% Convert image to binary 
binarizedImage = im2binary(improvedImage,90);

% Perform vertical and horizontal segmentation to reduce the unwanted
% number of blobs

binarizedImage = vSegment(binarizedImage,34,300);
binarizedImage = hSegment(binarizedImage,50,300);

binarizedImage = cropImage(binarizedImage,12,103,10,350);

% Show license plate number
% imshow(binarizedImage);

%Visualize horizontal and vertical project of an image

rowVals = zeros(1,rowSize);
colVals = zeros(1,colSize); 

for i = 1:rowSize
    rowVals(i) = sum(binarizedImage(i,:))./255;
end

for i = 1:colSize
    colVals(i) = sum(binarizedImage(:,i))./255;
end

% Display horizontal project
% barh(rowVals);
% Display vertical project
% bar(colVals);

segmentedChars = charLevelSegmentation(binarizedImage,colVals,colSize);

templateChars = preprocessTemplate();

temp1 = segmentedChars{1};
imDim = size(temp1);
temp2 = imresize(templateChars{36},imDim);

% display(corr2(temp1,temp2));

% imshow(temp2);
licensePlateNumber = matchChars(segmentedChars,templateChars);
display(licensePlateNumber)
function licensePlateNumber = matchChars(licensPlateChars, templateChars)
    licensePlateNumber = "";
    uniqueChars = ['A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','Q','R','S','T','U','V','W','X','Y','Z','0','1','2','3','4','5','6','7','8','9'];

    for i =1:6
        currChar = licensPlateChars{i}; 
        currCharDim = size(currChar); 

        maxCorr = 0.0;
        maxCorrIndex = 1;

        for j = 1:36
            currTemplate = templateChars{j};
            currTemplate = imresize(currTemplate,currCharDim);
            
            r = corr2(currChar,currTemplate);

            if(r>maxCorr && r >=0.50)
                maxCorr = r;
                maxCorrIndex = j;
            end
        end
        licensePlateNumber =strcat(licensePlateNumber,uniqueChars(maxCorrIndex));
    end
end 


function templateChars = preprocessTemplate()
    uniqueChars = ['A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','Q','R','S','T','U','V','W','X','Y','Z','0','1','2','3','4','5','6','7','8','9'];
    totalUnique = 36; 
    strPrefix = 'LicensePlateBinary/';
    strSuffix = '_template.bmp';
    templateChars = {};

for img_index =1:totalUnique
    img = imread(strcat(strPrefix,uniqueChars(img_index),strSuffix));
    img = flipColors(img);

    imDim = size(img); 
    rowSize = imDim(1);
    colSize = imDim(2); 

    rowVals = zeros(1,rowSize);
    colVals = zeros(1,colSize);

    for i = 1:rowSize
        rowVals(i) = sum(img(i,:))./255;
    end
    
    for i = 1:colSize
        colVals(i) = sum(img(:,i))./255;
    end
    
    lastWhite = 0; 
    for i = 1:colSize
        if(i < colSize && colVals(i+1) ~= 0 && colVals(i) == 0)
            lastWhite = i;
        elseif(colVals(i) == 0 && lastWhite ~= 0)
            img = img(:,lastWhite:i);
            lastWhite = 0;
        end
    end
    lastWhite = 0;

    for i = 1:rowSize
        if(i < rowSize && rowVals(i+1) ~= 0 && rowVals(i) == 0)
            lastWhite = i;
        elseif(rowVals(i) == 0 && lastWhite ~= 0)
            img = img(lastWhite:i,:);
            lastWhite = 0;
        end
    end
    
    templateChars = [templateChars, img];
end


end

function binarizedImage = flipColors(binarizedImage)
    imDim = size(binarizedImage); 
    rowSize = imDim(1);
    colSize = imDim(2); 

    for i=1:rowSize
        for j=1:colSize
            if(binarizedImage(i,j) == 255)
                binarizedImage(i,j) = 0; 
            else
                binarizedImage(i,j) = 255; 
            end
        end
    end
end

function segmentedChars = charLevelSegmentation(binarizedImage,colVals,colSize)
    segmentedChars = {};

    upperXPixel = 91;
    lowerXPixel = 19; 

    thresholdBorderBoxWidth = 15; 
    
    firstWhite = 0;

    for i =1:colSize
        if(i < colSize && colVals(i + 1) > 0 && colVals(i) == 0)
            firstWhite = i;
        elseif(colVals(i) == 0)
            width = i - firstWhite;

            if(width > thresholdBorderBoxWidth)
                charImage = binarizedImage(lowerXPixel:upperXPixel, firstWhite:i);
                segmentedChars = [segmentedChars,charImage];
            end
            firstWhite = i;
        end
    end
end

function binarizedImage = cropImage(binarizedImage, xLower,xUpper,yLower,yUpper)

    dim = size(binarizedImage);

    rowSize = dim(1);
    colSize = dim(2);

    binarizedImage(1:xLower, :) = 0;
    binarizedImage(xUpper:rowSize,:) = 0;

    binarizedImage(:, 1:yLower) = 0;
    binarizedImage(:, yUpper:colSize) = 0;

end
function binarizedImage = vSegment(binarizedImage, tMin, tMax)

    blobCount = 0;

    dim = size(binarizedImage);

    rowSize = dim(1);
    colSize = dim(2); 

    for i=1:colSize
        for j=1:rowSize
            if(binarizedImage(j,i) == 0)
                blobCount = blobCount + 1;
           end
        end

        if (blobCount >= tMax || blobCount <= tMin)
            binarizedImage(:,i) = 0;
        end

        blobCount = 0;
    end
    
end

function binarizedImage = hSegment(binarizedImage, tMin, tMax)

    blobCount = 0;

    dim = size(binarizedImage);

    rowSize = dim(1);
    colSize = dim(2); 

    for i=1:rowSize
        for j=1:colSize
            if(binarizedImage(i,j) == 0)
                blobCount = blobCount + 1;
           end
        end

        if (blobCount >= tMax || blobCount <= tMin)
            binarizedImage(i,:) = 0;
        end

        blobCount = 0;
    end
    
end

function binarizedImage = im2binary(image, t)
    dim = size(image);

    rowSize = dim(1);
    colSize = dim(2); 

    binarizedImage = zeros(rowSize,colSize);

    for i = 1: rowSize
        for j = 1 : colSize
            if(image(i,j) <= t)
                binarizedImage(i,j) = 255;
            end
        end
    end
end

function sharpenedImage = sharpImage(inputImage)

    % Sharpen the image using unsharp mask 
    sharpenedImage = imsharpen(inputImage);

    % Apply 3x3 median filtering using zero padding 

    imageDim = size(inputImage);
    rowSize = imageDim(1);
    colSize = imageDim(2); 
    
    zeroPadded = zeros(rowSize + 2,colSize + 2);
    zeroPadded(2:rowSize+1,2:colSize+1) = sharpenedImage(:,:);
    
    for i=2:rowSize + 1
        for j = 2:colSize + 1
            filter = zeroPadded(i-1:i+1,j-1:j+1);
            filter = reshape(filter,1,9);
            sortedFilter = sort(filter);
            
            sharpenedImage(i-1,j-1) = sortedFilter(5);
        end
    end

    % sharpenedImage = zeroPadded;
end