function [pPX, marked] = rgAddNext(I, pPX, marked, th1, th2)

if pPX(1) > 1
    if pPX(2) > 1
        if marked(pPX(1)-1, pPX(2)-1) ~= 0      %top-left
            if analyzePx(I, pPX(1)-1, pPX(2)-1, th1, th2)
                pPX = [pPX, pPX(1)-1, pPX(2)-1];
            end
            marked(pPX(1)-1, pPX(2)-1) = 0;
        end
    end
    if marked(pPX(1)-1, pPX(2)) ~= 0       %top-center
        if analyzePx(I, pPX(1)-1, pPX(2), th1, th2)
            pPX = [pPX, pPX(1)-1, pPX(2)];
        end
        marked(pPX(1)-1, pPX(2)) = 0;
    end
    if marked(pPX(1)-1, pPX(2)+1) ~= 0       %top-right
        if analyzePx(I, pPX(1)-1, pPX(2)+1, th1, th2)
            pPX = [pPX, pPX(1)-1, pPX(2)+1];
        end
        marked(pPX(1)-1, pPX(2)+1) = 0;
    end
end

if pPX(2) > 1
    if marked(pPX(1), pPX(2)-1) ~= 0      %cent-left
        if analyzePx(I, pPX(1), pPX(2)-1, th1, th2)
            pPX = [pPX, pPX(1), pPX(2)-1];
        end
        marked(pPX(1), pPX(2)-1) = 0;
    end
end
if marked(pPX(1), pPX(2)+1) ~= 0       %cent-right
    if analyzePx(I, pPX(1), pPX(2)+1, th1, th2)
        pPX = [pPX, pPX(1), pPX(2)+1];
    end
    marked(pPX(1), pPX(2)+1) = 0;
end

if pPX(2) > 1
    if marked(pPX(1)+1, pPX(2)-1) ~= 0       %bottom-left
        if analyzePx(I, pPX(1)+1, pPX(2)-1, th1, th2)
            pPX = [pPX, pPX(1)+1, pPX(2)-1];
        end
        marked(pPX(1)+1, pPX(2)-1) = 0;
    end
end
if marked(pPX(1)+1, pPX(2)) ~= 0       %bottom-center
    if analyzePx(I, pPX(1)+1, pPX(2), th1, th2)
        pPX = [pPX, pPX(1)+1, pPX(2)];
    end
    marked(pPX(1)+1, pPX(2)) = 0;
end
if marked(pPX(1)+1, pPX(2)+1) ~= 0       %bottom-right
    if analyzePx(I, pPX(1)+1, pPX(2)+1, th1, th2)
        pPX = [pPX, pPX(1)+1, pPX(2)+1];
    end
    marked(pPX(1)+1, pPX(2)+1) = 0;
end