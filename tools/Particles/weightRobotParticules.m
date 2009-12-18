function [newParticuleSet quality] = weightRobotParticules(particuleSet,detections,inferingTags,antennas,polarDetectionModel,excludeDetection)

newParticuleSet = particuleSet;

quality = 0;

if(nargin < 6) % excludeDetection not defined
    
    for k = 1:length(newParticuleSet)
    
        [p,localQuality] = getSimilarityProbability(detections, particuleSet(k).position, inferingTags,antennas,polarDetectionModel);
    
        newParticuleSet(k).weight = newParticuleSet(k).weight*p;
        
        quality = quality + localQuality;
    end
    
else
    
    for k = 1:length(newParticuleSet)
    
        [p,localQuality] = getSimilarityProbability(detections, particuleSet(k).position, inferingTags,antennas,polarDetectionModel,excludeDetection);
      
        newParticuleSet(k).weight = newParticuleSet(k).weight*p;
   
        quality = quality + localQuality;
    end 
end

quality = quality/length(newParticuleSet);