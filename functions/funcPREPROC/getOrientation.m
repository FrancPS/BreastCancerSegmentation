% This algorithm will create two 3x3 windows, one at left side and one at
% right side of the image. The greater mean of the intensity values between
% them will indicate the orientation of the image (Orientation is defined
% on where the "chest" is). Windows will be slided 50px to the center of
% the X axis , and 1/3 the height of the image to the Y axis center to
% avoid possible margin errors.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PARAMETERS                        %
%	I = input Image (2D uint8)      %
% RETURNS                           %
%	needFlip (boolean)              %
%       0 = img is well oriented    %
%       1 = img needs flipping      %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [needFlip] = getOrientation(I)

[height, width] = size(I);
Ypos = int32(height/3); % window slide (Y)

%% Get windows
% TOP-LEFT window
windowL = [I(Ypos-1, 49), I(Ypos-1, 50), I(Ypos-1, 51), ...
           I(Ypos, 49), I(Ypos, 50), I(Ypos, 51), ...
           I(Ypos+1, 49), I(Ypos+1, 50), I(Ypos+1, 51)];

% TOP-RIGHT window
Xpos = width-50;    % window slide (X)
windowR = [I(Ypos-1, Xpos-1), I(Ypos-1, Xpos), I(Ypos-1, Xpos+1), ...
           I(Ypos, Xpos-1), I(Ypos, Xpos), I(Ypos, Xpos+1), ...
           I(Ypos+1, Xpos-1), I(Ypos+1, Xpos), I(Ypos+1, Xpos+1)];

%% Calculate the means
meanL = sum(windowL)/9;
meanR = sum(windowR)/9;

%% Obtain Flipping boolean
if(meanL < meanR)
    needFlip = 1;       % 1 = 'chest' is at right side
else
    needFlip = 0;       % 0 = 'chest' is at left side
end


