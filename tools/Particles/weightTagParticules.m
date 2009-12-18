function [newParticuleSet quality] = weightTagParticules(detectionModel,particuleSet,robotPosition,antenna,detectionBool)

newParticuleSet = particuleSet;

for k = 1:length(newParticuleSet)
   
    [distance,angleRadians] =  getRelativePosition(robotPosition,newParticuleSet(k).position,antenna);
    
    p = getDetectionProbabilityPolar(detectionModel,distance,angleRadians);
    
    if(~detectionBool)
        p = 1 - p;
    end
    
    newParticuleSet(k).weight = newParticuleSet(k).weight*p;
    
end

    [newParticuleSet,quality] = normalizeParticuleSet(newParticuleSet);
    
    quality = round(quality*100000)/100000;
       