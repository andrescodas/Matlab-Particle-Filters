function newParticulesNumber = particlesIntersection(newParticuleSet,explorationParticuleSet)
 
 newParticulesNumber = 0;

 for j =  1:length(newParticuleSet)
     for i = 1:length(explorationParticuleSet)
        if(newParticuleSet(j).position == explorationParticuleSet(i).position)
             newParticulesNumber = newParticulesNumber + 1;
            break
        end
     end
 end