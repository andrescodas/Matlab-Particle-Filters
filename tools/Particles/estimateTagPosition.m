function [position] = estimateTagPosition(particuleSet)

position = zeros(size(particuleSet(1).position));

for i = 1:length(particuleSet)
    position = position + particuleSet(i).position*particuleSet(i).weight;
end
%position = position/i;
 
