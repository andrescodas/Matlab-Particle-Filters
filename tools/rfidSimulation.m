function detections = rfidSimulation(robotPosition,tags,polarModel)

antennas = 8;
tagsLength = length(tags);

detection = struct('tagId','0','antenna',99,'detected',-1);
detections = repmat(detection,1,antennas*tagsLength);

detectionCount = 0;

for t = 1:tagsLength
    for a = 0:antennas-1
    
        aleatoryNumber = rand;
        
        [distance,angleRadians] = getRelativePosition(robotPosition,tags(t).position,a);
        
        if(nargin <3)
            p = antennaModelGeom(distance,angleRadians);
        else
            p = getDetectionProbabilityPolar(polarModel,distance,angleRadians);
        end
        
        if(aleatoryNumber <= p)
            d = 1;
        else
            d = 0;
        end
        
        detectionCount = detectionCount + 1;
            
        detection.tagId = tags(t).tagId;
        detection.antenna = a;
        detection.detected = d;
        
        detections(detectionCount) = detection;
            
        
    end
end

detections = detections(1:detectionCount);