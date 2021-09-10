% This sub-function of the regGrow is used to add neighbouring pixels (3x3
% window) to the RG algorithm. It will mark them as they are selected to
% avoid the selection of the same pixel twice while the RG is run.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PARAMETERS                                                    %
%   pPX = vector of pixels waiting for the RG [x1,y1,...,xn,yn] %
%   marked = binary 2D matrix for the selected pixels           %
% RETURNS                                                       %
%	updated pPX and marked                                      %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [pPX, marked] = rgAddNext(pPX, marked)

if pPX(1) > 1 % check top edge of the image
    if pPX(2) > 1 % check left edge of the image
        % top-left px (in the 3x3 neighbour window)
        if marked(pPX(1)-1, pPX(2)-1) ~= 0
            pPX = [pPX, pPX(1)-1, pPX(2)-1];
            marked(pPX(1)-1, pPX(2)-1) = 0;
        end
    end
    % top-center px
    if marked(pPX(1)-1, pPX(2)) ~= 0
        pPX = [pPX, pPX(1)-1, pPX(2)];
        marked(pPX(1)-1, pPX(2)) = 0;
    end
    % top-right px
    if marked(pPX(1)-1, pPX(2)+1) ~= 0
        pPX = [pPX, pPX(1)-1, pPX(2)+1];
        marked(pPX(1)-1, pPX(2)+1) = 0;
    end
end

if pPX(2) > 1 % check left edge of the image
    % center-left px
    if marked(pPX(1), pPX(2)-1) ~= 0
        pPX = [pPX, pPX(1), pPX(2)-1];
        marked(pPX(1), pPX(2)-1) = 0;
    end
end
% center-right px
if marked(pPX(1), pPX(2)+1) ~= 0
    pPX = [pPX, pPX(1), pPX(2)+1];
    marked(pPX(1), pPX(2)+1) = 0;
end

if pPX(2) > 1 % check left edge of the image
    % bottom-left px
    if marked(pPX(1)+1, pPX(2)-1) ~= 0
        pPX = [pPX, pPX(1)+1, pPX(2)-1];
        marked(pPX(1)+1, pPX(2)-1) = 0;
    end
end
% bottom-center px
if marked(pPX(1)+1, pPX(2)) ~= 0
    pPX = [pPX, pPX(1)+1, pPX(2)];
    marked(pPX(1)+1, pPX(2)) = 0;
end
% bottom-right px
if marked(pPX(1)+1, pPX(2)+1) ~= 0
    pPX = [pPX, pPX(1)+1, pPX(2)+1];
    marked(pPX(1)+1, pPX(2)+1) = 0;
end