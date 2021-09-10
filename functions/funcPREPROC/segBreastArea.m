% This algorithm segments all the objects in an image and gets the Area
% information of them, needed for selecting the biggest object (presumably
% the breast). It will erase from the image all objects smaller than it and
% save the result in a binarized image. Afterwards it will mask the
% original image with the Binary image to get a segmentation of the breast
% area. Finally it will cut the image to the breast boundary box.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PARAMETERS                                        %
%     I = input Image (2D or 3D uint8)              %
% RETURNS                                           %
%     J = segmented ROI and cutted image (2D uint8) %
%     mask = binary mask of J                       %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [J, mask] = segBreastArea(I)

% Convert to grayscale if needed
if numel(size(I))>=3            
    I = rgb2gray(I);
end

IGM = medfilt2(I,[5 5]);        % Grayscale filtering
BW = imbinarize(IGM,0.0196);	% Binarization of the filtered image. TH>=5

%% Get the Biggest object
% Regionprops method segments every object in the image, and builds a
% struct with the Area value and the Boundary of each object.
stats = regionprops(BW,'Area','BoundingBox'); 

% Get the object index with the highest Area value, which should be the breast region.
maxA = 0;   % area Value
objNum = 0; % object index
for n = 1:length(stats)
    if stats(n).Area > maxA
        maxA = stats(n).Area;
        objNum = n;
    end
end

%% Obtain the mask for the biggest object
if (objNum > 0)
    BW = bwareaopen(BW,maxA);       % Eliminate all objects with area smaller than maxA
    BW = bwmorph(BW,'clean');       % Clean possible isolated 1's
    BW = bwmorph(BW,'majority');	% Recover possible isolated 0's
    BW = imfill(BW,'holes');        % Fill holes in the binary object

    % Mask the original image with the Binary Image to get the breast ROI and remove BG noise
    I = immultiply(I, BW);
    
    % Cut the image to Breast Bounding Box
	J = imcrop(I, uint32(stats(objNum).BoundingBox));
    mask = imcrop(BW, uint32(stats(objNum).BoundingBox));
    
else
    error('ERROR: No object found in Binarized image.');
end