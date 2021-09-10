% This function calculates a Weighted Linear Regression (center weighted)
% for the pectoral edge points, used to cut possible oversegmentation
% afterwards. This cutting is done by eliminating the pixels of the
% pectoral mask that are on the right side (higher "column" value) of the
% resulting straight line

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PARAMETERS                    %
%   mask = input binary Image	%
% RETURNS                       %
%	mask (updated)              %
%   mask2
%	area of the Pectoral muscle %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [mask, mask2, area] = pectoralRegression(mask,A)

J = edge(mask);
[Rows, Cols] = size(J);

rs = [];
cs = [];
T = 0;  % C-A distance, used to shift the straight line afterwards

%% Get vectors for the X and Y values of the edge points
for row = 1:Rows
    for col = 1:Cols
        if J(row, col) == 1
            if row == 1
                T = col;
            end
            rs = [rs, row];     % RowS values
            cs = [cs, col];     % ColumnS values
            break;
        end
    end
end

cs(1) = A(2);   %Force 1st edge point at point A

%% Define Weight value for each point
[~, len] = size(rs);
w = zeros([1, len]);
q1 = uint32(len/10*2); % 20% of length
q3 = uint32(len/10*8); % 80% of length

% Center points have high weight, edging 20% points have low weight
% ("w" values are inverted in the WLR function)
w(1) = 1;
for n = 2:len
    if n < q1
        w(n) = 3;
    elseif n < q3
        w(n) = 1;
    else
        w(n) = 3;
    end
end

%% Regression
[m,b] = lsqfityw(cs, rs, w); % Weighted Linear Regression

%% Force line to start at point A
yA = double(m*A(2)+b);  % distance to slide
b = b+yA;               % sliding

%% Cut mask
for row = 1:Rows
    x = (row-b)/m;
    for col = 1:Cols
        if col > x
            mask(row,col) = 1;
        end
    end
end

mask2 = imcomplement(mask);

v = nonzeros(mask2);
area = length(v);


            