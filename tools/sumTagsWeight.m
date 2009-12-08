function newInferingTags = sumTagsWeight(weightedTags,newInferingTags)

for t = 1:length(newInferingTags)
    for p = 1:length(newInferingTags(t).particuleSet)
            newInferingTags(t).particuleSet(p).weight = newInferingTags(t).particuleSet(p).weight + weightedTags(t).particuleSet(p).weight; 
    end
end