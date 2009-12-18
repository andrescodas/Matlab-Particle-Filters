function k = randInteger(maxInteger)

aleatory = rand;
k = 0;
if (maxInteger == 0)
    warning('maxInteger == 0')
    return
end
for j = 1/maxInteger:1/maxInteger:1
    k = k + 1;
    
    if(j >= aleatory)
       break; 
    end
    
    
end