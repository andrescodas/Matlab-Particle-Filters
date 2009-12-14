function [inGroup,outGroup] = sortDetectionsByTag(detections,tagGroup)

inGroup = detections;
outGroup = detections;

inGroupConut = 0;
outGroupConut = 0;

currentTagId = 'zzz';

for j = 1:length(detections);

    if(strcmp(currentTagId,detections(j).tagId))

    else
        k = searchTag(tagGroup,detections(j).tagId);
        currentTagId = detections(j).tagId;
    end

    if (k ~= 0)
        inGroupConut = inGroupConut + 1;
        inGroup(inGroupConut) = detections(j);
    else
        outGroupConut = outGroupConut + 1;
        outGroup(outGroupConut) = detections(j);
    end

end
