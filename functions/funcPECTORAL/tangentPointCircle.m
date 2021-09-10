% This algorithm finds the tangent point of a given Circle and a Straight
% Line starting at a given Point

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PARAMETERS                                    %
%	A = start point of straight line (1x2 int)  %
%   O = center of given Circle (1x2 int)        %
%   R = radius of given circle (int)            %
% RETURNS                                       %
%   D = leftmost tangent point in the circle    %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [D] = tangentPointCircle(A, O, R)

a = A;
A = [a(2), a(1)]; % (row, col) -> (x,y)

%% Middle point between A-O
AO = [O(1)-A(1), O(2)-A(2)];                        % AO vector from A to O
O2 = double([A(1) + (AO(1)/2), A(2) + (AO(2)/2)]);	% O2 middle point in AO

%% Find the tangent points
% C2 is the circle at center O2 with diameter AO that cuts the MIC in two
% points, the tangent points.
R2 = norm(double(AO))/2;    % Radius of C2
[xout,yout] = circcirc(O(1),O(2),R, O2(1),O2(2),R2);

%% Get leftmost tangent point
if xout(1) < xout(2)
    x = round(xout(1));
    y = round(yout(1));
    D = uint32([y, x]);
else
    x = round(xout(2));
    y = round(yout(2));
    D = uint32([y, x]);
end
