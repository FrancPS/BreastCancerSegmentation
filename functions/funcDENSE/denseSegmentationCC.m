% This function creates a mask for the dense area of the breast for CC
% views, and also determines the area of it.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PARAMETERS                                %
%	I = greyscale Image                     %
% RETURNS                                   %
%	mask = binary Image of the dense Area	%
%	dnsArea = scalar value of dense Area	%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [mask, dnsArea] = denseSegmentationCC(I)

[Rows, Cols] = size(I);
mask = zeros(Rows,Cols,'logical');

%% Get average value of breast pixels
v = double(nonzeros(I));
th = sum(v)/length(v); % set threshold

%% Grayscale filtering and contrasting
I = medfilt2(I,[7 7]);

%%  Mask and Area
dnsArea = 0;
for row = 1:Rows
    for col = 1:Cols
        if I(row,col) > th
            mask(row,col) = 1;
            dnsArea = dnsArea+1;
        end
    end
end
mask = imcomplement(mask);