% This function calculates the average intensity of a window centered
% at a given pixel in a grayscale image

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PARAMETERS                            %
%   I = input Image (2D uint8)          %
%   row = row of given pixel            %
%   col = column of given pixel         %
% RETURNS                               %
%	intensity = average value (double)  %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [intensity] = getAvg(I, row, col)

winSize = 37; % Window size

% Window is smaller for the px near to the edges of the img
% top & left edging px
if row <= winSize && col <= winSize
    wind = I( (1:row+winSize), (1:col+winSize) );
% left edging px
elseif col <= winSize && row > winSize
    wind = I( (row-winSize:row+winSize), (1:col+winSize) );
% top edging px
elseif row <= winSize && col > winSize
    wind = I( (1:row+winSize), (col-winSize:col+winSize) );
% Non-edging px
else
    wind = I( (row-winSize:row+winSize), (col-winSize:col+winSize) );
end

intensity = double(mean2(wind));