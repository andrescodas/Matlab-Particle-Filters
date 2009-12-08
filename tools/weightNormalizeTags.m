function [weightedTags,globalQuality] = weightNormalizeTags(polarModel,detections,inferingTags,robotPosition,antennas)

weightedTags = inferingTags;

for tagIndex = 1:length(weightedTags);

    globalQuality = 0;

    for antenna = 0:antennas-1

        ta = searchDetection(detections,weightedTags(tagIndex).tagId,antenna);

        if(detections(ta).detected)
            [weightedTags(tagIndex).particuleSet quality] = weightTagParticules(	polarModel, ...
                weightedTags(tagIndex).particuleSet, ...
                robotPosition, ...
                antenna, ...
                1);

        else
            [weightedTags(tagIndex).particuleSet quality] = weightTagParticules(  polarModel, ...
                weightedTags(tagIndex).particuleSet, ...
                robotPosition, ...
                antenna, ...
                0);
        end
        globalQuality = globalQuality+quality;
    end
    globalQuality = globalQuality/antennas;
    
end

if (nargout < 1)
    plotTagsEstimation(weightedTags,robotPosition)
end