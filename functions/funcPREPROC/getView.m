% This function will get 2 points from the edge of the breast area. If
% these points are in a line of more than 45º of slope, it will determine
% the view as CC, otherwise it will be MLO.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PARAMETERS                    %
%     I = input Image (2D uint8)%
% RETURNS                       %
%     isMLO (boolean)           %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [isMLO] = getView(I)

I = medfilt2(I,[11 11]);    % Grayscale filtering
BW = imbinarize(I,0.0196);	% Binarization of the filtered image. TH>=5
[~, cols] = size(I);

edge1 = 0;  % Column position of the edge pixels
edge2 = 0;

%% Get edge points
% Get edge point on row 10
for col = cols:-1:1
    if BW(10,col)~=0
        edge1 = col;
        break;
    end
end

% Get edge point on row 40
for col = cols:-1:1
    if BW(40,col)~=0
        edge2 = col;
        break;
    end
end

%% Check slope
% 30px on Y axis and 30px on X axis give a slope of 45º     \
if (edge2-edge1)>=30
    isMLO = false;
else
    isMLO = true;
end
