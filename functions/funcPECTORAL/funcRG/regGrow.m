% This Region Growing function creates a mask for the Pectoral Muscle
% removal. It is limited to those pixels inside the rectangle triangle
% defined by A, B and the top left corner of the image, and it will erase
% the pixels inside this area that have a similar or higher intensity as
% the ones already included in the RG, starting from the seed.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PARAMETERS                                           %
%   I = input Image (2D uint8)                         %
%   A, B = points of limit line                        %
%   m = slope of AB                                    %
%   dev = deviation of the RG minimum threshold [0..1] %
% RETURNS                                              %
%	mask = binary image (breast without pectoral)      %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [mask] = regGrow(I, A, B, m, dev)

[Rows, Cols] = size(I);
marked = zeros(Rows,Cols);          % matrix to mark the px already checked
mask = ones(Rows,Cols, 'logical');  % mask of the breast

% Contrast enhancement (This could also be optimized)
I = adapthisteq(I, 'NumTiles',[2 2], 'ClipLimit', 0.008, 'NBins', 256, 'Distribution', 'uniform');

% define "marked" as a mask only for the px inside the limit triangle
c = double(A(2));
for row = 1:B(1)
    for col = 1:uint32(c)
        marked(row,col) = 1;
    end
    c = c + (1/m);  % slope of the hypotenuse for the next row (limit)
end

%% Regoin Growing
seed = [uint32(B(1)/4), uint32(A(2)/4)];  % define seed (close to the center of the triangle)
pPX = [seed(1), seed(2)];     % pPX is the vector of selected pixels

marked(seed(1), seed(2)) = 0; % "mark" the seed point
sum = getAvg(I, seed(1), seed(2)); % always pixels are considered inside a window
n = 1;

while ~isempty(pPX)
    
    avgRG = sum/n;  % average of intensities of the segmented pixels in RG
    
    % Threshold update
    th1 = avgRG - (dev)*avgRG; % dev might be obtained from the GWO
    
    % Pixel is segmented if its intensity is higher than thresholds
    intensity = getAvg(I, pPX(1), pPX(2));
    if th1 < intensity
        mask(pPX(1), pPX(2)) = 0;
        
        % update values for the average of intensities
        n = n+1;
        sum = sum + intensity;
    end
    
    % Add neighbouring pixels to the RG
    [pPX, marked] = rgAddNext(pPX, marked);
    pPX(1:2) = [];
end
