function polarModel = getPositionLikelihoodModel(polarDetectionModel)
%
% function positionLikelihood =
% getPositionLikelihoodModel(polarDetectionModel)
%

polarModel = polarDetectionModel;

stepDistance = polarDetectionModel.stepDistance;
stepAngle = polarDetectionModel.stepAngle;
maxDistance = size(polarDetectionModel.likelihood,1)*stepDistance;

distanceSet = 0:stepDistance:(maxDistance-stepDistance);
angleSet = 0:stepAngle:(pi-stepAngle);

positionLikelihood = zeros(length(distanceSet),length(angleSet)+1);

sumLikelihoodDistance = 0;
for d = 1:length(distanceSet)
    
    sumLikelihoodAngle = 0;
    for a = 1:length(angleSet)
        positionLikelihood(d,a+1) =  getLikelihoodInDistanceAngle(polarDetectionModel,distanceSet(d),stepDistance,angleSet(a),stepAngle);
        sumLikelihoodAngle = sumLikelihoodAngle + positionLikelihood(d,a+1);
    end

    if(sumLikelihoodAngle ~= 0)   
        positionLikelihood(d,:) = positionLikelihood(d,:)/sumLikelihoodAngle;
    else
        positionLikelihood(d,:) = 1 / (size(positionLikelihood,2)-1);
    end
    
	positionLikelihood(d,1) = getLikelihoodInDistance(polarDetectionModel,distanceSet(d),stepDistance);
	sumLikelihoodDistance = sumLikelihoodDistance + positionLikelihood(d,1);

end

if(sumLikelihoodDistance ~= 0)   
    positionLikelihood(:,1) = positionLikelihood(:,1) / sumLikelihoodDistance;
else
    positionLikelihood(:,1) = 1 / size(positionLikelihood,1);
end

sumLikelihoodDistance = 0;
for d = 1:length(distanceSet)
    
    sumLikelihoodAngle = 0;
    for a = 1:length(angleSet)
        sumLikelihoodAngle = sumLikelihoodAngle + positionLikelihood(d,a+1);
        positionLikelihood(d,a+1) = sumLikelihoodAngle ;
    end
    
   sumLikelihoodDistance = sumLikelihoodDistance + positionLikelihood(d,1);
   positionLikelihood(d,1) = sumLikelihoodDistance;
  
end

polarModel.positionLikelihood = positionLikelihood; 