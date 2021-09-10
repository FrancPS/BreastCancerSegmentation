% This function smoothes the edge of the pectoral mask for those pixels
% that have a higher "column" value than the edge-pixel of the previous
% row, giving the pectoral curve always a positive slope.
% GET READY...

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PARAMETERS                    %
%	mask = input binary Image	%
% RETURNS                       %
%	mask (updated)              %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [mask] = pectoralCurveFix(mask)

% mask is complementary. object is 0's and background is 1's
mask = imcomplement(mask);
mask = bwareafilt(mask, 1);     % Get the biggest object in the mask
mask = imfill(mask, 'holes');	% Fill holes of the object
mask = imcomplement(mask);

[Rows, Cols] = size(mask);

cAnt = 9999; % column limit
exit = 0;    % finish loop

for row = 1:Rows
    for col = Cols:-1:1 % gets to the edge from the right
        
        if mask(row,col) == 0 % at the edge point ...
            
            if col <= cAnt  % if column is lower than limit, update column limit
                cAnt = col;
                
            else            % if column is higher, erase leftover pixels
                for ce = col:-1:cAnt
                    mask(row, ce) = 1;
                end
            end
            % fill pixels between the pectoral edge and the left edge of the image
            for cl = 1:cAnt
                mask(row, cl) = 0;
            end
            break;
            
        end
        % if we get to the 1st column, pectoral area is over
        if col == 1
            cAnt = col;
            exit = 1;
        end
    end
    if exit
        break;
    end
end
