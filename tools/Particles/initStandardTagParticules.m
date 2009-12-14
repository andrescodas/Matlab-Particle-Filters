function particuleSet = initStandardTagParticules(polarModel,numberParticules,detectionFromAntennas,robotRadius)

numDetections = sum(detectionFromAntennas);

tagParticule = struct('position',[-inf -inf],'weight',1);
particuleSet = repmat(tagParticule,1,numberParticules*numDetections);

i = 0;
for da = 0:length(detectionFromAntennas)-1
    if(detectionFromAntennas(da+1))
        for k = 1:numberParticules
            i = i+1;

            [distance,angleRadians] = getProbablePositionPolar(polarModel);

            particuleSet(i).position = [cos(angleRadians) sin(angleRadians)]*distance + [robotRadius 0];

            particuleSet(k).position = rotation(particuleSet(k).position,getAntennaAngle(da));

        end
    end
end

for antenna = 0:length(detectionFromAntennas)-1

    if(detectionFromAntennas(antenna+1))

        [particuleSet quality] = weightTagParticules(  polarModel, ...
            particuleSet, ...
            [0 0 0], ...
            antenna, ...
            1);
    else
        [particuleSet quality] = weightTagParticules(  polarModel, ...
            particuleSet, ...
            [0 0 0], ...
            antenna, ...
            0);
    end
end
particuleSet = normalizeParticuleSet(particuleSet);
particuleSet = resampleParticuleSet(particuleSet,numberParticules);