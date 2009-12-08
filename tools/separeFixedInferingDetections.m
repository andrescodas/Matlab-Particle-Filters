function [fixedTagDetections,inferingTagDetections] = separeFixedInferingDetections(detections,fixedTags)

fixedTagDetections = detections;
inferingTagDetections = detections;

fixedCount = 0;
inferingCount = 0;

currentTagId = 'zzz';

for j = 1:length(detections);

    if(strcmp(currentTagId,detections(j).tagId))

    else
        k = searchTag(fixedTags,detections(j).tagId);
        currentTagId = detections(j).tagId;
    end

    if (k ~= 0)
        fixedCount = fixedCount + 1;
        fixedTagDetections(fixedCount) = detections(j);
    else
        inferingCount = inferingCount + 1;
        inferingTagDetections(inferingCount) = detections(j);
    end
end
