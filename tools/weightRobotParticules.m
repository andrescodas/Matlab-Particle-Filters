function newParticuleSet = weightRobotParticules(particuleSet,detections,inferingTags,antennas,polarDetectionModel,excludeDetection)

newParticuleSet = particuleSet;


if(nargin < 6) % excludeDetection not defined
    for k = 1:length(newParticuleSet)
    
        p = getSimilarityProbability(detections, particuleSet(k).position, inferingTags,antennas,polarDetectionModel);
      
        newParticuleSet(k).weight = newParticuleSet(k).weight*p;
   
    end
    
else
    
    for k = 1:length(newParticuleSet)
    
        p = getSimilarityProbability(detections, particuleSet(k).position, inferingTags,antennas,polarDetectionModel,excludeDetection);
      
        newParticuleSet(k).weight = newParticuleSet(k).weight*p;
   
    end 
end
