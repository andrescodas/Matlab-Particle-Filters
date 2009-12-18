function newRobotByParticules = updateRobotParticules(robotByParticules,inferingTags,detections,numberParticulesRobot,inertia,antennas,polarDetectionModel)

[newParticuleSet,quality] = weightRobotParticules(robotByParticules.particuleSet,detections,inferingTags,antennas,polarDetectionModel);

quality = round(quality*10000)/10000;

newParticuleSet = normalizeParticuleSet(newParticuleSet);

if(quality == 1)
    
elseif(quality > 1)
    warning('There is a bug')
else

    newParticuleSet = resampleExploreRobot(newParticuleSet,polarDetectionModel,inertia+(1-inertia)*quality,inferingTags,detections,numberParticulesRobot,antennas);

end

position = estimateRobotPosition(newParticuleSet);
%     printParticuleSet(newParticuleSet,'go')

newRobotByParticules = struct('particuleSet',newParticuleSet,'position',position);

