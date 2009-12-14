function p = antennaModelGeom(distance,angle)

warning('Using Ideal Model');

if(distance < 0.5)
   p = 0.7; 
   return
end

if (abs(angle)*2 > pi/180*100)
    p = 0;
    return
elseif(distance > 4)
    p = 0;
    return
else
    p = 0.9;
end

