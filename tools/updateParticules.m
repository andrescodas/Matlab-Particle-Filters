function [newParticuleSet estimatedPosition] = updateParticules(detectionModel,particuleSet,robotPosition,antenna,detectionBool,numberParticules,inertia)

% figure(1)
% hold off
% 
% 
% printParticuleSet(particuleSet)
% 
% xlim([-4 4])
% ylim([-4 4])
% hold all
% corrected = 0 ;

 newParticuleSet = particuleSet;

for k = 1:length(newParticuleSet)
   
    [distance,angleRadians] =  getRelativePosition(robotPosition,newParticuleSet(k).position,antenna);
    
    p = getDetectionProbabilityPolar(detectionModel,distance,angleRadians);
    
    if(~detectionBool)
        p = 1 - p;
    end
    
%     if(p == 0)
%         hold all
%         plot(newParticuleSet(k).position(1),newParticuleSet(k).position(2),'rx')
%         corrected =1;
%     end
%     
    newParticuleSet(k).weight = newParticuleSet(k).weight*p;
    
end

    [newParticuleSet,quality] = normalizeParticuleSet(newParticuleSet);
    
    quality = round(quality*10000)/10000;
    
%    display(strcat('Particle set quality = ',num2str(quality)))

%     if(detectionBool)
%         if (quality ~= 1)
%             quality
%         end
%     end


if (detectionBool)
   explorationParticuleSet = initParticules(detectionModel,numberParticules,robotPosition,antenna);
   
   newParticuleSet = mergeParticules(newParticuleSet,inertia+(1-inertia)*quality,explorationParticuleSet,(1-inertia)*(1-quality));

end
   
%     if (corrected)
%      corrected = 0;
%     end
    newParticuleSet  = resampleParticuleSetUnionPosition(newParticuleSet,numberParticules);
    estimatedPosition = estimateTagPosition(newParticuleSet);
    
    %     printParticuleSet(newParticuleSet,'go')

    

% if (detectionBool)
% 
%  newParticulesNumber = particlesIntersection(newParticuleSet,explorationParticuleSet);
%  
%     if( newParticulesNumber> ceil(numberParticules*(1-inertia)*(1-quality)))
%         display(strcat('NewParticules = ',num2str( newParticulesNumber)))
%         display(strcat('Expecting = ',num2str( numberParticules*(1-inertia)*(1-quality))))
%         
%     end
%     
%  end
   