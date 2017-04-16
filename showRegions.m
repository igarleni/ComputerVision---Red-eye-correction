for i = 1:size(labeledRegions,1)
    for j= 1:size(labeledRegions,2)
        if (labeledRegions(i,j) == 1) 
                regionImg(i,j,1) = 255; 
                regionImg(i,j,2) = 0; 
                regionImg(i,j,3) = 0;
        elseif (labeledRegions(i,j) == 2) 
                regionImg(i,j,1) = 0; 
                regionImg(i,j,2) = 255; 
                regionImg(i,j,3) = 0;
        elseif (labeledRegions(i,j) == 3) 
                regionImg(i,j,1) = 0; 
                regionImg(i,j,2) = 0; 
                regionImg(i,j,3) = 255;
        elseif (labeledRegions(i,j) == 4) 
                regionImg(i,j,1) = 255; 
                regionImg(i,j,2) = 255; 
                regionImg(i,j,3) = 0;
        elseif (labeledRegions(i,j) == 5) 
                regionImg(i,j,1) = 255; 
                regionImg(i,j,2) = 0; 
                regionImg(i,j,3) = 255;
        elseif (labeledRegions(i,j) == 6) 
                regionImg(i,j,1) = 0; 
                regionImg(i,j,2) = 255; 
                regionImg(i,j,3) = 255;
        end
    end
end