function newSet = scaleParticuleSet(set,scale)

newSet = set;

for i = 1:length(set)
    newSet(i).weight = newSet(i).weight * scale;
end