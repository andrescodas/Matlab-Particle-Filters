function [newParticuleSet,quality] = normalizeParticuleSet(particuleSet)

newParticuleSet = particuleSet;

quality = 0;

for i = 1:length(newParticuleSet)
    
   quality = quality + newParticuleSet(i).weight; 

end
if(quality ~= 0)

    for i = 1:length(newParticuleSet)
    
        newParticuleSet(i).weight =newParticuleSet(i).weight / quality; 

    end
else

    weight = 1/length(newParticuleSet);
    
    for i = 1:length(newParticuleSet)
    
        newParticuleSet(i).weight = weight; 

    end    
    
end
