function [newParticuleSet] = resampleParticuleSetUnionPosition(particuleSet,numberParticules)

newParticule = particuleSet(1);
particuleWeight = 1/numberParticules ;

newParticule.weight = particuleWeight;

newParticuleSet = repmat(newParticule,1,numberParticules);

cumulativeParticuleSet = cumulativeWeights(particuleSet);

diferentParticulesNumber = 0;

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
newParticuleSet = newParticuleSet(1:diferentParticulesNumber);