function merged = mergeLikelihoodSmooth(lkh,smooth)

merged = lkh;

for i = 1:size(merged,1)
    for j = 1:size(merged,2)
        if(merged(i,j) < 0)
            merged(i,j) = smooth(i,j);
        end
    end
end