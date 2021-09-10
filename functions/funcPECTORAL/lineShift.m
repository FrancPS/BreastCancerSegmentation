% This function shifts to the right the line defined by two given points.
% Given point must have an x value of 1. The return points will also have
% an x value of 1 for the first point and a y value of 1 for the second
% point.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PARAMETERS                            %
%   B = point of the line               %
%   m = slope of the line               %
%   b = coefficient of the line         %
% RETURNS                               %
%   Ap, Bp = Points of the shifted line %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [Ap, Bp] = lineShift(B, m, b, divisor)

T = B(1)/divisor;
b = b + T; % shifting

% y=mx+b, y of Ap is 1, x of Bp is 1
xA = (1+b)/-m;
yB = (m + b);

Ap = [1, uint32(xA)];
Bp = [uint32(yB), 1];

