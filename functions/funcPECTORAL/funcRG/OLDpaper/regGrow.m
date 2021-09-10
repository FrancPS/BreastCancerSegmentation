



function [mask] = regGrow(I, A, B, m)

[Rows, Cols] = size(I);
J = zeros(Rows,Cols);
mask = ones(Rows,Cols);

iMax = 0;
% define J as the mask of the area inside the ABC triangle
c = double(A(2)+20);
for row = 1:B(1)
    for col = 1:uint32(c)
        J(row,col) = 1;
        if I(row,col) > iMax
            iMax = I(row,col); % Maximum intensity pixel inside ABC
            rMax = double(row);
            cMax = double(col);
        end
    end
    c = c + (1/m);
end


%RG
A = double(A);
N = double(sqrt( (A(1))^2 + (A(2))^2 ));
d10 = N/8;
seed = [uint8(B(1)/4), uint8(A(2)/4)];  % define seed

% seed = [uint8(A(1)), uint8(A(2)+d10)];
marked = J;             % "marked" is used to define selected pixels in RG
pPX = [seed(1), seed(2)];     % pPX is the vector of selected pixels

marked(seed(1), seed(2)) = 0; % add seed to selected px
iSeed = I(seed(1), seed(2));  % intensity value of seed point

% find K
% A = double(A);
B = double(B);
% N = double(sqrt( (A(1)-1)^2 + (A(2)-1)^2 ));
% M = double(sqrt( (B(1)-1)^2 + (B(2)-1)^2 ));
% N = double(sqrt( (A(1))^2 + (A(2))^2 ));
M = double(sqrt( (B(1))^2 + (B(2))^2 ));
d = sqrt( (rMax-A(1))^2 + (cMax-A(2))^2 );
% F = double(d/sqrt(N*M) * (iMax-iSeed));
F = double(d/sqrt(N*M));
K = 0.097 + 1.33*F;
sum = 0;
n = 0;
while ~isempty(pPX)
    
    % update average of RG included px
    n = n+1;
    sum = sum + double(I(pPX(1), pPX(2)));
    avg = sum/n;

    % TH
    th1 = avg - (0.3 + K)*avg;
    th2 = avg + (0.3 + K)*avg;

    mask(pPX(1), pPX(2)) = 0;
    
    [pPX, marked] = rgAddNext(I, pPX, marked, th1, th2);
    
    pPX(1:2) = [];
    
    
end
