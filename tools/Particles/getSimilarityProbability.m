function [p quality] = getSimilarityProbability(detections, robotPosition, inferingTags,antennas,polarDetectionModel,excludeDetection)

varDetections = detections;

p = 1;

quality = 0;
if(nargin < 6) % excludeDetection not defined

    for it = 1:length(inferingTags)
        for a = 0:antennas-1

            [distance,angleRadians] =  getRelativePosition(robotPosition,inferingTags(it).position,a);

            likelihoodAntennaTag = getDetectionProbabilityPolar(polarDetectionModel,distance,angleRadians);

            k =  searchDetection(varDetections,inferingTags(it).tagId,a);

            if(k == 0)
                p = p*(1 - likelihoodAntennaTag);
            elseif(varDetections(k).detected)
                p = p*likelihoodAntennaTag;
            else
                p = p*(1 - likelihoodAntennaTag);
            end

            if(p == 0)
                quality = 0;
                return;

            else
                quality = quality + p;
            end

            varDetections = [varDetections(1:k-1) varDetections(k+1:length(varDetections))];
        end
    end
    quality = quality/antennas/length(inferingTags);
else

    for it = 1:length(inferingTags)
        for a = 0:antennas-1

            k =  searchDetection(varDetections,inferingTags(it).tagId,a);

            if(~((inferingTags(it).tagId == excludeDetection.tagId) && (a == excludeDetection.antenna)))

                [distance,angleRadians] =  getRelativePosition(robotPosition,inferingTags(it).position,a);

                likelihoodAntennaTag = getDetectionProbabilityPolar(polarDetectionModel,distance,angleRadians);

                if(varDetections(k).detected)
                    p = p*likelihoodAntennaTag;
                else
                    p = p*(1 - likelihoodAntennaTag);
                end

                if(p == 0)
                    quality = 0;
                    return;

                else
                    quality = quality + p;
                end

            end
            varDetections = [varDetections(1:k-1) varDetections(k+1:length(varDetections))];
        end
    end
    quality = quality/(antennas*length(inferingTags)-1);
end


for vD = 1:length(varDetections)

    if(varDetections(vD).detected)
        display(strcat('New unknown tag = ',varDetections(vD).tagId))
    end

end


