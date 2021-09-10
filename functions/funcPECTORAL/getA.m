% This function returns a point on the top row of the image, which is the
% edge between pectoral muscle and breast area. 
% It is selected by creating a mask with all the pixels that have a higher
% intensity than the average on the first 30 rows of the image.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PARAMETERS                                    %
%     I = input Image (2D uint8)                %
% RETURNS                                       %
%     A = edge point (uint8[row,col])           %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [A] = getA(I)

[rows, cols] = size(I);
BW = zeros(10,cols);   % BW is the mask of the high intensity pixels

%% Get average value of non-background pixels (first 30 rows)
n = 0;
sum = 0;
for row = 1:30
    for col = 1:cols
        if I(row,col) > 0
            sum = sum + uint32(I(row,col));
            n = n+1;
        end
    end
end
avg = sum/n;

%% Apply thresholding
for row = 1:10
    for col = 1:cols
        if I(row,col) > avg
            BW(row,col) = 1;
        end
    end
end

%% Smoothing the mask
BW = bwmorph(BW,'clean');       % Clean possible isolated 1's
BW = bwmorph(BW,'majority');	% Recover possible isolated 0's
SE = strel('disk', 2);
BW = imerode(BW,SE);            % Erosion
BW = imdilate(BW,SE);           % Dilation

%% Get the edge point
% The target column will be the average edge column index of the first 5
% rows of the mask
index = 0;
for row = 1:5
    for col = cols:-1:1
        if BW(row, col) > 0
            index = index + col;
            break;
        end
    end
end

index = uint32(index/5);

if index == 0
    index = 1;
end

A = [1, index];


