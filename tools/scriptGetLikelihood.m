function positionLikelihood = getPositionLikelihoodModel(polarDetectionModel)

stepDistance = polarDetectionModel.stepDistance;
stepAngle = polarDetectionModel.stepAngle;
maxDistance = size(polarDetectionModel.likelihood,1)*stepDistance;

distanceSet = 0:stepDistance:maxDistance;
angleSet = 0:stepAngle:(pi-stepAngle);

detectionMatrix = zeros(length(distanceSet),length(angleSet)+1);

for d = 1:length(distanceSet)
    
    sumLikelihoodAngle = 0;
    for a = 1:length(angleSet)
        detectionMatrix(d,a+1) =  getLikelihoodInDistanceAngle(polarModel,distanceSet(d),stepDistance,angleSet(a),stepAngle);
        sumLikelihoodAngle = sumLikelihoodAngle + detectionMatrix(d,a+1);
    end

    detectionMatrix(d,:) = detectionMatrix(d,:)/sumLikelihoodAngle;
    
   
    sumLikelihoodDistance = 0;
   detectionMatrix(d,1) = getLikelihoodInDistance(polarModel,distanceSet(d),stepDistance);
   sumLikelihoodDistance = sumLikelihoodDistance + detectionMatrix(d,1);

end
   
detectionMatrix(:,1) = detectionMatrix(:,1) / sumLikelihoodDistance; 

for d = 1:length(distanceSet)
    
    sumLikelihoodAngle = 0;
    for a = 1:length(angleSet)
        sumLikelihoodAngle = sumLikelihoodAngle + detectionMatrix(d,a+1);
        detectionMatrix(d,a+1) = sumLikelihoodAngle ;
    end

   sumLikelihoodDistance = 0;
    sumLikelihoodDistance = sumLikelihoodDistance + detectionMatrix(d,1);
   detectionMatrix(d,1) = sumLikelihoodDistance;
  

end