function [weightedTag,globalQuality] = weightNormalizeTags(polarModel,detections,inferingTag,robotByParticles,antennas)


weightedTag = clearInferingTagsWeight(inferingTag);
globalQuality = 0;

for rp = 1:length(robotByParticles.particuleSet);
    localQuality = 0;
    weightedTagAux = inferingTag;
    for antenna = 0:antennas-1
        ta = searchDetection(detections,weightedTagAux.tagId,antenna);

        if(ta < 1)
            [weightedTagAux.particuleSet quality] = weightTagParticules(  polarModel, ...
                weightedTagAux.particuleSet, ...
                robotByParticles.particuleSet(rp).position, ...
                antenna, ...
                0);
        elseif(detections(ta).detected)
            [weightedTagAux.particuleSet quality] = weightTagParticules(	polarModel, ...
                weightedTagAux.particuleSet, ...
                robotByParticles.particuleSet(rp).position, ...
                antenna, ...
                1);

        else
            [weightedTagAux.particuleSet quality] = weightTagParticules(  polarModel, ...
                weightedTagAux.particuleSet, ...
                robotByParticles.particuleSet(rp).position, ...
                antenna, ...
                0);
        end


        if(quality > 1)
            warning('quality > 1');
        end


        if(quality == 0)
            localQuality = 0;
            break;
        end

        localQuality = localQuality + quality;

    end
    weightedTag = sumTagsWeight(weightedTag,weightedTagAux);
    globalQuality = globalQuality + localQuality;
end

weightedTag.particuleSet = scaleParticuleSet(weightedTag.particuleSet,1/length(robotByParticles.particuleSet));

globalQuality = globalQuality/length(robotByParticles.particuleSet)/antennas;

if (nargout < 1)
    plotTagsEstimation(weightedTags,robotPosition)
end