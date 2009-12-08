function newInferingTags = clearInferingTagsWeight(inferingTags)

newInferingTags =inferingTags;

for t = length(newInferingTags)
    for p = length(newInferingTags(t).particuleSet)
        newInferingTags(t).particuleSet(p).weight = 0;
    end
end