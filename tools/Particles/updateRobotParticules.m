function newRobotByParticules = updateRobotParticules(robotByParticules,inferingTags,detections,numberParticulesRobot,inertia,antennas,polarDetectionModel)


    newParticuleSet = weightRobotParticules(robotByParticules.particuleSet,detections,inferingTags,antennas,polarDetectionModel);

	[newParticuleSet,quality] = normalizeParticuleSet(newParticuleSet);
    
	quality = round(quality*10000)/10000;
       
     if(quality < 1)
     
     	explorationParticuleSet = newRobotParticules(polarDetectionModel,inferingTags,detections,numberParticulesRobot,antennas);
        
        newParticuleSet = mergeParticules(newParticuleSet,inertia+(1-inertia)*quality,explorationParticuleSet,(1-inertia)*(1-quality));
     end
%     if (corrected)
%      corrected = 0;
%     end
      newParticuleSet = resampleParticuleSet(newParticuleSet,numberParticulesRobot);
      position = estimateRobotPosition(newParticuleSet);
%     printParticuleSet(newParticuleSet,'go')

     newRobotByParticules = struct('particuleSet',newParticuleSet,'position',position);
    
