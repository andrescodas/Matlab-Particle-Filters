function [inGroup,outGroup] = sortDetectionsByTag(detections,tagGroup)

inGroup = detections;
outGroup = detections;

inGroupCount = 0;
outGroupCount = 0;

currentTagId = 'zzz';

for j = 1:length(detections);

    if(strcmp(currentTagId,detections(j).tagId))

    else
        k = searchTag(tagGroup,detections(j).tagId);
        currentTagId = detections(j).tagId;
    end

    if (k ~= 0)
        inGroupCount = inGroupCount + 1;
        inGroup(inGroupCount) = detections(j);
    else
        outGroupCount = outGroupCount + 1;
        outGroup(outGroupCount) = detections(j);
    end

end

inGroup = inGroup(1:inGroupCount);
outGroup = outGroup(1:outGroupCount);