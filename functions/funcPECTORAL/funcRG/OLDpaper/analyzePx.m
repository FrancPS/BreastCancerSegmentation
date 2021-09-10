function [bool] = analyzePx(I, row, col, th1, th2)

% Get avergage of 15x15 window
if row <= 7 && col <= 7
    wind = I( (1:row+7), (1:col+7) );
elseif col <= 7 && row > 7
    wind = I( (row-7:row+7), (1:col+7) );
elseif row <= 7 && col > 7
    wind = I( (1:row+7), (col-7:col+7) );
else
    wind = I( (row-7:row+7), (col-7:col+7) );
end

iAvg = mean2(wind);

if (th1 < iAvg) && (iAvg < th2)
    bool = 1;
else
    bool = 0;
end





