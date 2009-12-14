function new = smoothMatrix(lkh)

new = -2*ones(size(lkh,1),size(lkh,2));
lkhIter = lkh;

pairs = -ones(size(lkh,1)*size(lkh,2),2);
pairsIter = 0;

for i = 1:size(lkh,1)
    for j = 1:size(lkh,2)
        if(lkh(i,j) == -1)
            pairsIter = pairsIter + 1;
            pairs(pairsIter,:) = [i j];
        end
    end
end

totalPairs = pairsIter;
pairs = pairs(1:totalPairs,1:2);

criterium = 1;
while (criterium)
    
    criterium = 0;
    
    for k = 1:totalPairs
    
        sumNeighbor = 0;
        sumNumber = 0;
        i = pairs(k,1);
        j = pairs(k,2);
        
        
        for ii = -1:1
                
            for jj = -1:1
        
                si = i + ii;
                
                if (si < 1)
                    break;
                elseif (si > size(lkhIter,1)) 
                    break;
                end
                
                sj = j + jj;
                
                if (sj < 1)
                  
                elseif (sj > size(lkhIter,2)) 
                
                elseif (lkhIter(si,sj) < 0)
                    
                else
                    
                    sumNeighbor = sumNeighbor + lkhIter(si,sj);
                    sumNumber = sumNumber + 1;
                    
                end
                
                        
            end
        end
        
        if sumNumber > 0
        
            if(abs(new(i,j) - sumNeighbor/sumNumber) > 0.000001)
                criterium = 1;
            end 
            new(i,j) = sumNeighbor/sumNumber;
            lkhIter(i,j) = sumNeighbor/sumNumber;
        end
        if(new(i,j) < 0)
                criterium = 1;
        end
       
    end 
end
