% This function creates a mask for the dense area of the breast for MLO
% views, and also determines the area of it.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PARAMETERS                                %
%	I = greyscale Image                     %
% RETURNS                                   %
%	mask = binary Image of the dense Area	%
%	dnsArea = scalar value of dense Area	%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [mask, dnsArea] = denseSegmentation(I, pecIns)

[Rows, Cols] = size(I);
mask = zeros(Rows,Cols,'logical');

%% Get average value of breast pixels
v = double(nonzeros(I)); % v is all non-BG pixels without pectoral
avg = sum(v)/length(v);

%%  Set Threshold
% Based in avg intensity of the pectoral area and of the breast area, and
% the deviation of the values in the breast area. Found by experimentation.
dev = sqrt(var(v));     % deviation of breast intensities
fac = sqrt(avg*dev);
o = abs(50-fac);        % factor of average and dev breast intensities
p = (pecIns-avg);       % factor of pectoral and breast average intensities
th = pecIns - abs(p - o); % pecIns is average intensity of pectoral area

%% Grayscale filtering
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