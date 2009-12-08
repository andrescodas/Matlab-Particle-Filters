function detectionList = evaluations2detections(evaluations)

detection = struct('tadId','xxx','antenna',-1,'detected',-1);
detectionsAtPosition = repmat(detection,1,8*7);
detectionList = struct('detectionsAtPosition',detectionsAtPosition);
detectionList = repmat(detectionList,1,length(evaluations)*8);

positionBefore = [inf -inf inf];

dL = 0;

for e = 1:length(evaluations)
    if (prod(evaluations(e).position == positionBefore))
        dP = dP+1;
        detectionsAtPosition(dP).tagId = evaluations.tagId;
        detectionsAtPosition(dP).antenna = evaluations.antenna;
        detectionsAtPosition(dP).detected = evaluations.detected;
    else

        if(dL ~= 0)

            dL = dL + 1;

            detectionsAtPosition = detectionsAtPosition(1:dP);
            detectionList(dL).detectionsAtPosition = detectionsAtPosition;
            detectionsAtPosition = repmat(detection,1,8*7);

        end

        dP = 1;

        detectionsAtPosition(dP).tagId = evaluations.tagId;
        detectionsAtPosition(dP).antenna = evaluations.antenna;
        detectionsAtPosition(dP).detected = evaluations.detected;

    end
end

dL = dL + 1;
detectionsAtPosition = detectionsAtPosition(1:dP);
detectionList(dL).detectionsAtPosition = detectionsAtPosition;

detectionList = detectionList(1:dL);