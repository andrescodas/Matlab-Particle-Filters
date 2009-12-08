function [estimatedPosition] = estimateTagPosition(particuleSet)

estimatedPosition = [0 0];

for i = 1:length(particuleSet)
    estimatedPosition = estimatedPosition + particuleSet(i).position*particuleSet(i).weight;
end
%estimatedPosition = estimatedPosition/i;
 
