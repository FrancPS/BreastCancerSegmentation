function [I2] = exeSeg(threshold)
addpath(genpath('./functions/'), '-end');
myDir = '.\expected\'; 
jpgs = dir(fullfile(myDir,'*.jpg')); %gets jpg files in dir
pngs = dir(fullfile(myDir,'*.png')); %gets png files in dir
myFiles = cat(1,jpgs,pngs);
for k = 1:length(myFiles)
	baseFileName = myFiles(k).name;
	fullFileName = fullfile(myDir, baseFileName);   % full path = path+filename
    I0 = imread(fullFileName);                      % get image from path
    I0 = imresize(I0, .5);
    %% PREPROCESSING %%
    divisor = 100;
    pecArea = 0;
    [I, mask] = segBreastArea(I0);  % ROI segmentation
    
	needFlip = getOrientation(I);
    if needFlip
        I = flip(I ,2);         % Image horizontal flip 
        mask = flip(mask ,2);	% Mask horizontal flip 
    end
    
    % Cut margins (5px) to avoid intensity variances caused by previous filtering
    [rows, cols] = size(I);
    I = imcrop(I, [5 5 cols-5 rows-5]);
    mask = imcrop(mask, [5 5 cols-5 rows-5]);
    
    isMLO = getView(I); % CC or MLO
    
    %% MLO PECTORAL MUSCLE REMOVAL %%
        % FIND POINTS A, B, C, D
    if isMLO
        A = getA(I);	% A is the edge point of pectoral at 1st row
        
        % Maximum Inscribed Circle
        perim = getPerimeter(mask);  % Get the perimeter of the mask
        [R, cx, cy, ~, ~, ~, ~] = max_inscribed_circ(perim); % find MIC
        O1 = [cx, cy];	% O is center ot the MIC
        D = tangentPointCircle(A, O1, R);

        [B, m, b] = getB(A, D);
        [A2, B2] = lineShift(B, m, b, divisor);
        
        % APPLY RG METHOD
        if A(2) > 1
            
            pMask = regGrow(I, A2, B2, m, threshold);

            pMask = pectoralCurveFix(pMask);
            [pMask,~, ~] = pectoralRegression(pMask,A);
            
        end
        
        I2 = immultiply(I,pMask);
    end
end
