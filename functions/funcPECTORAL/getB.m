% This algorithm extrudes a line to the left edge of the image, and returns
% the intersection point of the line and the edge.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PARAMETERS                                            %
%	A = point 1 of straight line (2x1 int)              %
%	D = point 2 of straight line (2x1 int)              %
% RETURNS                                               %
%   B = intersection at left vertical edge (2x1 int)    %
%   m = slope of AD                                     %
%   b = coefficient of AD  (y=mx+b)                     %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [B, m, b] = getB(A, D)

A = double(A);
D = double(D);

% Find coefficient and slope for line AD (m and b in y=mx+b)
coefs = polyfit([A(2), D(2)], [A(1), D(1)], 1);
m = coefs(1);   % slope m
b = coefs(2);   % coefficient b

xB = 1;     % B is at Left edge
yB = m + b;	% apply straight line formula for x=1

if yB <= 0
    yB = 1;
end

B = uint32([yB, xB]);