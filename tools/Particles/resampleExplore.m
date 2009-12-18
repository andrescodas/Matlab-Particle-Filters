function newParticuleSet = resampleExplore(particuleSet,polarModel,tagItDetections,robotRadius,inertia,offsetParticleSet,numberParticules)


if(inertia == 1)
    newParticuleSet=particuleSet ;
    return;
else
    particuleWeight = 1/numberParticules;
    newParticule = struct('position',[-inf -inf],'weight',particuleWeight);
    newParticuleSet = repmat(newParticule,1,numberParticules);

    if(isempty(particuleSet))
        makeResample = 0;
    else
        makeResample = 1;
        cumulativeParticuleSet = cumulativeWeights(particuleSet);
    end
end


makeExploration = 0;
for td = 1:length(tagItDetections)
    if(tagItDetections(td).detected)
        makeExploration = 1;
        exploringParticlesInited = 0;
        break
    end
end


diferentParticulesNumber = 0;

newParticlesnumber = 0;

if (makeExploration && makeResample)
    for k = 1:numberParticules
        if (rand < inertia)

            particuleIndex = searchParticule(cumulativeParticuleSet,rand);
            newPosition = particuleSet(particuleIndex).position;

            founded = 0;
            for j = 1:diferentParticulesNumber
                if(newParticuleSet(j).position == newPosition)
                    founded = 1;
                    newParticuleSet(j).weight = newParticuleSet(j).weight + particuleWeight;
                    break;
                end
            end
            if(~founded)
                diferentParticulesNumber = diferentParticulesNumber + 1;
                newParticuleSet(diferentParticulesNumber).position = newPosition;
            end


        else
            if(~exploringParticlesInited)
                exploringParticlesInited = 1;
                exploringParticleSet = initStandardTagParticules(polarModel,1000,tagItDetections,robotRadius);
            end
            newPosition = exploringParticleSet(randInteger(length(exploringParticleSet))).position;
            fromParticle = offsetParticleSet(randInteger(length(offsetParticleSet)));

            newPosition = rotation(newPosition,fromParticle.position(3));
            newPosition = newPosition + fromParticle.position(1:2);

            newParticlesnumber = newParticlesnumber + 1;
            diferentParticulesNumber = diferentParticulesNumber + 1;
            newParticuleSet(diferentParticulesNumber).position = newPosition;
        end

    end

elseif(makeResample)
    for k = 1:numberParticules
        particuleIndex = searchParticule(cumulativeParticuleSet,rand);
        newPosition = particuleSet(particuleIndex).position;

        founded = 0;
        for j = 1:diferentParticulesNumber
            if(newParticuleSet(j).position == newPosition)
                founded = 1;
                newParticuleSet(j).weight = newParticuleSet(j).weight + particuleWeight;
                break;
            end
        end
        if(~founded)
            diferentParticulesNumber = diferentParticulesNumber + 1;
            newParticuleSet(diferentParticulesNumber).position = newPosition;
        end
    end

else
    exploringParticleSet = initStandardTagParticules(polarModel,1000,tagItDetections,robotRadius);
    for k = 1:numberParticules

        newPosition = exploringParticleSet(randInteger(length(exploringParticleSet))).position;
        fromParticle = offsetParticleSet(randInteger(length(offsetParticleSet)));

        newPosition = rotation(newPosition,fromParticle.position(3));
        newPosition = newPosition + fromParticle.position(1:2);

        newParticlesnumber = newParticlesnumber + 1;
        diferentParticulesNumber = diferentParticulesNumber + 1;
        newParticuleSet(diferentParticulesNumber).position = newPosition;

    end
end


display(strcat('number new particles = ',num2str(newParticlesnumber)));
newParticuleSet = newParticuleSet(1:diferentParticulesNumber);