% This function gets the perimeter of an object on a binary image.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PARAMETERS                                %
%	mask = binary Image                     %
% RETURNS                                   %
%	perim = binary Image with the perimeter	%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [perim] = getPerimeter(mask)

% Smooth edges of the mask
windowSize = 51;
kernel = ones(windowSize) / windowSize ^ 2;
blurryImage = conv2(single(mask), kernel, 'same');
mask = blurryImage > 0.5; % Rethreshold

% Get perimeter of a Binary image
perim = bwperim(mask);

