function [position] = estimateTagPosition(particuleSet)

position = [0 0];

for i = 1:length(particuleSet)
    position = position + particuleSet(i).position*particuleSet(i).weight;
end
%position = position/i;
 
