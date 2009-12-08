function newAngle = angleWrap(angle)

newAngle = angle;

for i = 1:length(angle)

    while(newAngle(i) > pi)
        newAngle(i) = newAngle(i) - 2*pi;
    end
    while(newAngle(i) <= -pi)
        newAngle(i) = newAngle(i) + 2*pi ;
    end
    
    
        
end

