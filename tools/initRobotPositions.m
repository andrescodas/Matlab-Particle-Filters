function newParticuleSet = initRobotPositions(polarDetectionModel,tag,antenna,numberParticulesRobot)

robotParticule = struct('position',[-inf -inf -inf],'weight',1/numberParticulesRobot);
newParticuleSet = repmat(robotParticule,1,numberParticulesRobot);

for i = 1:numberParticulesRobot

    [distance,angleRadians] = getProbablePositionPolar(polarDetectionModel);
    anglePolar = angleWrap((rand-0.5)*2*pi);
    
    newParticuleSet(i).position = calculateRobotPosition(tag,antenna,distance,anglePolar,angleRadians);

end