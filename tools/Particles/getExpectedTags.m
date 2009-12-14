function expectedTags = getExpectedTags(polarModel,robotPosition,tags,antennas)

expectedTag = struct('tagId','xxx','antenna',-1,'probability',-1);
expectedTags = repmat(expectedTag,1,antennas*length(tags));

k=0;

for t= 1:length(tags)
    for a = 0:antennas-1
        [distance,angleRadians] =  getRelativePosition(robotPosition,tags(t).position,a);
        p = getDetectionProbabilityPolar(polarModel,distance,angleRadians);
        
        if(p>0)
            k = k + 1;
            expectedTags(k).tagId = tags(t).tagId;
            expectedTags(k).antenna = a;
            expectedTags(k).probability = p;
        else
            
        end
        
    end
end

expectedTags = expectedTags(1:k);