function [inGroup,outGroup] = sortDetectionsByTagId(detections,tagId)

inGroup = detections;
outGroup = detections;

inGroupCount = 0;
outGroupCount = 0;

for j = 1:length(detections);

    if(strcmp(tagId,detections(j).tagId))
        inGroupCount = inGroupCount + 1;
        inGroup(inGroupCount) = detections(j);
    else
        outGroupCount = outGroupCount + 1;
        outGroup(outGroupCount) = detections(j);

    end
end


inGroup = inGroup(1:inGroupCount);
outGroup = outGroup(1:outGroupCount);