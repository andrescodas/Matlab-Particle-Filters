function explorationParticuleSet = newRobotParticules(polarDetectionModel,inferingTags,detections,numberParticulesRobot,antennas)

numberDetected = 0;
detectionIndex = zeros(2,length(detections));
for j = 1:length(detections)
    if(detections(j).detected == 1)
        k = searchTag(inferingTags,detections(j).tagId);
        if(k>0)
            numberDetected = numberDetected + 1;
            detectionIndex(1,numberDetected) = j;
            detectionIndex(2,numberDetected) = k;
        end
    end
end

if(numberDetected > 0)
    numberParticulesRobot = ceil(numberParticulesRobot/numberDetected);
else
    numberParticulesRobot = 0;
end
explorationParticule = struct('position',[-inf -inf -inf],'weight',-1);

explorationParticuleSet = repmat(explorationParticule,1,numberDetected*numberParticulesRobot);

if(numberDetected>0)
    for d = 1:numberDetected;
        j = detectionIndex(1,d);
        k = detectionIndex(2,d);

        newexplorationParticuleSet = initRobotPositions(polarDetectionModel,inferingTags(k),detections(j).antenna,numberParticulesRobot);

        explorationParticuleSet(numberParticulesRobot*(d-1)+1:numberParticulesRobot*(d)) = newexplorationParticuleSet;

    end

    explorationParticuleSet = explorationParticuleSet(1:numberParticulesRobot*(numberDetected));

    weight = 1/(numberParticulesRobot*numberDetected);

    for j = 1:(numberParticulesRobot*numberDetected)
        explorationParticuleSet(j).weight = weight;
    end

    explorationParticuleSet = weightRobotParticules(explorationParticuleSet,detections,inferingTags,antennas,polarDetectionModel);

end

explorationParticuleSet = normalizeParticuleSet(explorationParticuleSet);

explorationParticuleSet = resampleParticuleSet(explorationParticuleSet,numberParticulesRobot*numberDetected);