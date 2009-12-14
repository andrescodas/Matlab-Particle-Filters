function p =  getLikelihoodInDistanceAngle(polarModel,distance,stepDistance,angle,stepAngle)
%
%  This function only gives a proportional results, later it is necessary
%  to scale its value for the "detectionMatrix" sum up to 1
% 
% detectionMatrix(d,a+1) =
% getLikelihoodInDistanceAngle(polarModel,distanceSet(d),stepDistance,angleSet(a),stepAngle)

if(stepDistance ~= polarModel.stepDistance)
    error('Not suitable step Distance');
elseif(stepAngle ~= polarModel.stepAngle)
    error('Not suitable step Angle');
end


d = floor(distance/stepDistance)+1;
a = floor(abs(angle/stepAngle))+1;


p = polarModel.likelihood(d,a);