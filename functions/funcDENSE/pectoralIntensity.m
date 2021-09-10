% This function gets the intensity average of the segmented Pectoral Muscle

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PARAMETERS                                        %
%	I = greyscale Image                             %
%	mask = binary Image of the Pectoral Area        %
% RETURNS                                           %
%	intnsity = scalar value of pectoral intensity   %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [intensity] = pectoralIntensity(I,mask)

mask = imcomplement(mask);
J = immultiply(I,mask);

%% Get average value of pectoral pixels
v = double(nonzeros(J));
intensity = sum(v)/length(v);