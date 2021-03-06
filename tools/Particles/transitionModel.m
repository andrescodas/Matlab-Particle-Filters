function [newRobotByParticules] = transitionModel(robotByParticules,rflexPosition,rflexPositionAnt,rflexCovariance)

newRobotByParticules = robotByParticules;
rflexCovarinaceSQRT = sqrt(rflexCovariance);


deslocInRflexBase = (rflexPosition(1:2) - rflexPositionAnt(1:2));



for i = 1:length(robotByParticules.particuleSet)
   
    distributionEstimation = (rflexCovarinaceSQRT*randn(3,1));
    newDesloc = rotation(deslocInRflexBase + distributionEstimation(1:2)',-rflexPositionAnt(3)+newRobotByParticules.particuleSet(i).position(3));
    
    newRobotByParticules.particuleSet(i).position = newRobotByParticules.particuleSet(i).position + [newDesloc 0];
    newRobotByParticules.particuleSet(i).position(3) = angleWrap(newRobotByParticules.particuleSet(i).position(3)+rflexPosition(3) - rflexPositionAnt(3)+distributionEstimation(3));
end
