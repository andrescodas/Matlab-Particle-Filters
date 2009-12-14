function [position] = estimateRobotPosition(particuleSet)


position = [0 0 0];
sinEstimated = 0;
cosEstimated = 0;

for i = 1:length(particuleSet)
   
    position = position + particuleSet(i).position;
    sinEstimated = sinEstimated + sin(particuleSet(i).position(3));
    cosEstimated = cosEstimated + cos(particuleSet(i).position(3));
end

 position = position/i;
 
 sinEstimated = sinEstimated/i;
 cosEstimated = cosEstimated/i;
  
position(3) = angleWrap(atan2(sinEstimated,cosEstimated)); 
