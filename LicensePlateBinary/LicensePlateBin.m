% Read the basis image
basisImage = imread('LicensePlateTemp.png');
% Convert to binary image
binaryBasisImage = imbinarize(basisImage, graythresh(basisImage));

% Define characters (0-9 and A-Z)
characters = ['A':'Z' '0':'9'];
numCharacters = length(characters);

% Image dimensions
imageHeight = size(basisImage, 1);
imageWidth = size(basisImage, 2);
templateHeight = 160;
templateWidth = 92;

% Create a figure to display the segmented template images for testing purposes
% figure;

% Loop through each character
for i = 1:numCharacters

    % Get the character
    currentChar = characters(i);
    
    % Create a blank binary template
    binaryTemplate = zeros(templateHeight, templateWidth);
    
    % Calculate the region of interest (ROI) for the current character
    rowStart = 1 + floor((i-1) / 9) * templateHeight;
    rowEnd = rowStart + templateHeight - 1;
    colStart = mod(i-1, 9) * templateWidth + 1;
    colEnd = colStart + templateWidth - 1;
    
    % Extract the current character from the basis image
    currentCharRegion = binaryBasisImage(rowStart:rowEnd, colStart:colEnd);
    
    % Add the character region to the binary template
    binaryTemplate(1:min(templateHeight, imageHeight-rowStart+1), 1:min(templateWidth, imageWidth-colStart+1)) = currentCharRegion(1:min(templateHeight, imageHeight-rowStart+1), 1:min(templateWidth, imageWidth-colStart+1));
    
    % Display the segmented template image for testing purposes
    % subplot(5, 9, i);
    % imshow(binaryTemplate);
    % title(currentChar);
    
    % Save the template as a BMP file
    imwrite(binaryTemplate, sprintf('%c_template.bmp', currentChar));
end
