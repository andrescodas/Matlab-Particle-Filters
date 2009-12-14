function [distance,angleRadians] = getProbablePositionPolar(polarDetectionModel)
 %
 %[distance,angleRadians] = getProbablePositionPolar(polarDetectionModel) 
 %
 %Tag is assumed in position [0 0]
 %

[distanceIndex,angleIndexPlusOne] = size(polarDetectionModel.positionLikelihood);
 
aleatoryNumber = rand;
bottomIndex = 1;

if( aleatoryNumber < polarDetectionModel.positionLikelihood(1,1))
    distanceIndex = 1;
elseif( aleatoryNumber > polarDetectionModel.positionLikelihood(distanceIndex,1) )
	warning('Bad top index');
else
    while(distanceIndex - bottomIndex > 1)
        currentIndex = floor((distanceIndex + bottomIndex)/2);

        if(polarDetectionModel.positionLikelihood(currentIndex,1) < aleatoryNumber);
            bottomIndex = currentIndex;
        else
            distanceIndex = currentIndex;
        end
    end
end
 
aleatoryNumber = rand;
bottomIndex = 2;

if( aleatoryNumber < polarDetectionModel.positionLikelihood(distanceIndex,2))
    angleIndexPlusOne = 2;
elseif( aleatoryNumber > polarDetectionModel.positionLikelihood(distanceIndex,angleIndexPlusOne) )
	warning('Bad top index');
else
    while(angleIndexPlusOne - bottomIndex > 1)
        currentIndex = floor((angleIndexPlusOne + bottomIndex)/2);

        if(polarDetectionModel.positionLikelihood(distanceIndex,currentIndex) < aleatoryNumber);
            bottomIndex = currentIndex;
        else
            angleIndexPlusOne = currentIndex;
        end
    end
end

distance = (distanceIndex-1+rand)*polarDetectionModel.stepDistance;
angleRadians = (angleIndexPlusOne-2+rand)*polarDetectionModel.stepAngle;
  
if(rand > 0.5)
	angleRadians = -angleRadians;
end
      
