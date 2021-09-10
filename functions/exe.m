% Main algorithm to determine the density value of a Breast, segmenting the
% pectoral muscle on MLO view images.
% Scheme for the Pectoral Muscle removal:
% C--------A---|
% |      /     |
% |     /      |
% |   D        |
% | /          |
% |/           |
% B            |
% |____________|

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PARAMETERS                                                %
%   null                                                    %
% RETURNS                                                   %
%	brsArea = total Area of the Breast                      %
%   pecArea = Area of the pectoral Muscle                   %
%   dnsArea = Area of the Dense Region                      %
%   needFlip = (bool) wether image is right or left sided   %
%   isMLO = (bool) wether image is CC or MLO view        	%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [brsArea, pecArea, dnsArea, needFlip, isMLO] = exe(opt)

% Load desired image onto workspace
myDir = '.\expected\'; 
jpgs = dir(fullfile(myDir,'*.jpg')); %gets jpg files in dir
pngs = dir(fullfile(myDir,'*.png')); %gets png files in dir
myFiles = cat(1,jpgs,pngs);
% reads "all" the files in the folder, but it is supposed to be just one
for k = 1:length(myFiles)
	baseFileName = myFiles(k).name;
	fullFileName = fullfile(myDir, baseFileName);   % full path = path+filename
    I0 = imread(fullFileName);                      % get image from path
    
    %% PREPROCESSING %%
    pecArea = 0;    % initialize pectoral area value, in pixels
    I0 = imresize(I0,.5); % faster algorythm, less accuracy on "density"
    % Breast Area segmentation
    [I, mask] = segBreastArea(I0);
    imwrite(I, './result/1segBreast/segBreast.jpg');
    
    % Orientation of the image.
    % needFlip = 0 Chest is on the left
    %          = 1 on the right, and img needs to be flipped horizontally
	needFlip = getOrientation(I);
    if needFlip
        I = flip(I ,2);         % Image horizontal flip 
        mask = flip(mask ,2);	% Mask horizontal flip 
    end
    
    % Cut margins (5px) to avoid intensity variances caused by previous filtering
    [rows, cols] = size(I);
    I = imcrop(I, [5 5 cols-5 rows-5]);
    mask = imcrop(mask, [5 5 cols-5 rows-5]);
    
    % Get total Area value of breast (including pectoral)
    v = nonzeros(I);
    brsArea = length(v);
    
    % Determine if image is CC or MLO view
    isMLO = getView(I);
    
    %% MLO PECTORAL MUSCLE REMOVAL %%
    if isMLO
        % FIND POINTS A, B, D
        %   A is the edge point of pectoral at 1st row
        %   D is the tangent point from A to the MIC
        %   B is the point at 1st row (ABD in the same line)
        A = getA(I);
        
        % B is found using a Maximum Inscribed Circle inside the Breast and
        % the tangent line from point A to the MIC
        perim = getPerimeter(mask);  % Get the perimeter of the Breast
        [R, cx, cy, Xc, Yc, coss, sins] = max_inscribed_circ(perim); % find MIC
        O1 = [cx, cy];	% O is center ot the MIC
        D = tangentPointCircle(A, O1, R);
        [B, m, b] = getB(A, D); % Enlarges the tangent line to 1st column
        
        % Shift the line AB to the right to include pixels of concave pectorals
        divisor = 100; % Higher value, less extrusion
        [A2, B2] = lineShift(B, m, b, divisor);
        
        % Plot all geometries
        Im = I;
        figure('visible', 'off'); imshow(Im);
        hold on
        plot(Xc, Yc, 'r', 'LineWidth', 1.5);
        plot(coss, sins, 'g', 'LineWidth', 1.5);
        plot(cx, cy, 'xg');
        plot(A, B, 'b', 'LineWidth', 1)
        plot(A2, B2, '--y', 'LineWidth', 1);
        plot(D(2), D(1), '.y', 'LineWidth', 2);
        hold off
        saveas(gcf,'.\result\3geometries\geometries.jpg');

        % APPLY RG METHOD
        
        % GreyWolf Optimization process, gets optimal th value for Region Growing
        if ~isempty(opt)    % opt is the selected function in the interface
            addpath(genpath('.\functions\GWO'),'-end');
            main();
        else
            Best_pos = 0.34; % Set default threshold if not optimized
        end
        
        if A(2) > 1 % Only if pectoral muscle is found
            % Region Growing and curve fixing
            pMask = regGrow(I, A2, B2, m, Best_pos);
            pMask = pectoralCurveFix(pMask);
            [pMask, mask2, pecArea] = pectoralRegression(pMask,A);

            I = immultiply(I, uint8(pMask));
            imwrite(I, './result/4segPectoral/segPectoral.jpg');
            
            % Mask used in evaluation, this can be removed
            s = strcat('./result/pMask/',baseFileName);
            imwrite(mask2,s);
        end
    end
    
    %% DENSE AREA SEGMENTATION %%
    if isMLO
        pecIns = pectoralIntensity(Im, pMask);
        [dMask, dnsArea] = denseSegmentation(I, pecIns);
    else
        [dMask, dnsArea] = denseSegmentationCC(I);
    end
    
    Id = immultiply(I, dMask);
    J = imfuse(I, Id, 'ColorChannels', [1 2 2]);
    imwrite(J, './result/5segDense/denseArea.jpg');
end