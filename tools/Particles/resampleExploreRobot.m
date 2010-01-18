function newParticuleSet = resampleExploreRobot(particuleSet,polarModel,inertia,tags,detections,numberParticules,antennas)

if(inertia == 1)
    newParticuleSet=particuleSet ;
    return;
else
    particuleWeight = 1/numberParticules;
    newParticule = struct('position',[-inf -inf -inf],'weight',particuleWeight);
    newParticuleSet = repmat(newParticule,1,numberParticules);
    if(isempty(particuleSet))
        makeResample = 0;
    else
        makeResample = 1;
        cumulativeParticuleSet = cumulativeWeights(particuleSet);
    end
end

makeExploration = 0;
for td = 1:length(detections)
    if(detections(td).detected)
        makeExploration = 1;
        exploringParticlesInited = 0;
        break
    end
end

if (makeExploration && makeResample)
    for k = 1:numberParticules
        if (rand < inertia)
            newParticuleSet(k).position = particuleSet(searchParticule(cumulativeParticuleSet,rand)).position;
        else
            if(~exploringParticlesInited)
                exploringParticlesInited = 1;
                exploringParticleSet = newRobotParticules(polarModel,tags,detections,numberParticules,antennas);
            end
            newParticuleSet(k).position = exploringParticleSet(randInteger(length(exploringParticleSet))).position;
        end
    end
elseif(makeResample)
    for k = 1:numberParticules
        newParticuleSet(k).position = particuleSet(searchParticule(cumulativeParticuleSet,rand)).position;
    end
else
    exploringParticleSet = newRobotParticules(polarModel,tags,detections,numberParticules,antennas);
    for k = 1:numberParticules
        newParticuleSet(diferentParticulesNumber).position = exploringParticleSet(randInteger(length(exploringParticleSet))).position;
    end
end
