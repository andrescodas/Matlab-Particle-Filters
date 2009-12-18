function detections = rfidSimulation(robotPosition,tags,polarModel)
%
% detections = rfidSimulation(robotPosition,tags,polarModel)
%

antennas = 8;
tagsLength = length(tags);

detection = struct('tagId','0','antenna',99,'detected',-1);
detections = repmat(detection,1,antennas*tagsLength);

localDetections = repmat(detection,1,antennas);

detectionCount = 0;

for t = 1:tagsLength
    success = 0;
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
            success = 1;
        else
            d = 0;
        end

        localDetections(a+1).tagId = tags(t).tagId;
        localDetections(a+1).antenna = a;
        localDetections(a+1).detected = d;

    end
    if(success == 1)
        detections(detectionCount+1:detectionCount+antennas) = localDetections;
        detectionCount = detectionCount + antennas;
    end
end


detections = detections(1:detectionCount);