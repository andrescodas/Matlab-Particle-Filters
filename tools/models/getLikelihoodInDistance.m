function p =  getLikelihoodInDistance(polarModel,distance,stepDistance)
%
%  This function only gives a proportional results, later it is necessary
%  to scale its value for the "detectionMatrix" sum up to 1
% 
%  p =  getLikelihoodInDistance(polarModel,distance,stepDistance)

if(stepDistance ~= polarModel.stepDistance)
    error('Not suitable step Distance');
end


d = floor(distance/stepDistance)+1;


p = 0;

for i = 1:size(polarModel.likelihood,2)

    p = p + polarModel.likelihood(d,i);
    
end

p = p*areaCircleSection(distance,stepDistance);
