function [newParticuleSet] = resampleParticuleSet(particuleSet,numberParticules)

if(isempty(particuleSet))
    newParticuleSet = particuleSet;
else
    newParticule = particuleSet(1);
    newParticule.weight = 1/numberParticules;

    newParticuleSet = repmat(newParticule,1,numberParticules);

    cumulativeParticuleSet = cumulativeWeights(particuleSet);

    aleatoryClass = rand(1,numberParticules);

    for k = 1:numberParticules

        particuleIndex = searchParticule(cumulativeParticuleSet,aleatoryClass(k));

        newParticuleSet(k).position = particuleSet(particuleIndex).position;

    end
end