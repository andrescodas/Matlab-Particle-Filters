function particuleSet = initParticules(polarDetectionModel,numberParticules,robotPosition,antenna)


tagParticule = struct('position',[-inf -inf],'weight',1/numberParticules);

particuleSet = repmat(tagParticule,1,numberParticules);

for k = 1:numberParticules

    [distance,angleRadians] = getProbablePositionPolar(polarDetectionModel);
       
    particuleSet(k).position = [cos(angleRadians) sin(angleRadians)]*distance;
    
    particuleSet(k).position = rotation(particuleSet(k).position,getAntennaAngle(antenna) + robotPosition(3));
    
    particuleSet(k).position = particuleSet(k).position + robotPosition(1:2);
    
end
