function [estimatedPosition] = estimateRobotPosition(particuleSet)


estimatedPosition = [0 0 0];
sinEstimated = 0;
cosEstimated = 0;

for i = 1:length(particuleSet)
   
    estimatedPosition = estimatedPosition + particuleSet(i).position;
    sinEstimated = sinEstimated + sin(particuleSet(i).position(3));
    cosEstimated = cosEstimated + cos(particuleSet(i).position(3));
end

 estimatedPosition = estimatedPosition/i;
 
 sinEstimated = sinEstimated/i;
 cosEstimated = cosEstimated/i;
  
estimatedPosition(3) = angleWrap(atan2(sinEstimated,cosEstimated)); 