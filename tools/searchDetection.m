function k = searchDetection(detections,tagId,antenna)

for k = 1:length(detections)

    if(antenna == detections(k).antenna)
        if (strcmp(detections(k).tagId,tagId))
            return;
        end
    end        
end


k = 0;
