function newInferingTags = clearInferingTagsWeight(inferingTags)

newInferingTags =inferingTags;

for t = 1:length(newInferingTags)
    for p = 1:length(newInferingTags(t).particuleSet)
        newInferingTags(t).particuleSet(p).weight = 0;
    end
end