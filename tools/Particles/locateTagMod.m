function inferingTags = locateTag(polarModel,detections,inferingTags,robotByParticules,numberParticules,inertia,antennas)


if (nargin<7)
    antennas = 8;
    if (nargin<6)
        inertia = 0.99;
        if (nargin<5)
            numberParticules = 500;
            if (nargin<4)
                robotByParticules = struct('particuleSet',0,'position',[(rand-0.5)*6 (rand-0.5)*6 (rand-0.5)*2*pi]);
                if(nargin<3)
                    inferingTags = [];
                    if(nargin<2)
                        tag = struct('tagId','xxx','position',[-inf -inf]);
                        realTags = repmat(tag,1,1);

                        tag.tagId = 'a';
                        tag.position = [0 0];
                        realTags(1) = tag;

                        tag.tagId = 'b';
                        tag.position = [4 -2];
                        realTags(2) = tag;

                        tag.tagId = 'c';
                        tag.position = [2 -1];
                        realTags(3) = tag;

                        tag.tagId = 'd';
                        tag.position = [3 1];
                        realTags(4) = tag;
                        
                        detections = rfidSimulation(robotByParticules.position,realTags,polarmodel);
                        if(nargin<1)
                            load polarModel
                        end
                    end
                end
            end
        end
    end
end


tagParticule = struct('position',[-inf -inf],'weight',-1);


for tagIndex = 1:length(inferingTags);

    explorationParticules = repmat(tagParticule,1,numberParticules*antennas);
    explorationCount = 0;
    globalQuality = 0;

    for antenna = 0:antennas-1

        ta = searchDetection(detections,inferingTags(tagIndex).tagId,antenna);

        if(ta == 0)
            [inferingTags(tagIndex).particuleSet quality] = weightTagParticules(  polarModel, ...
                inferingTags(tagIndex).particuleSet, ...
                robotByParticules.position, ...
                antenna, ...
                0);        
        elseif(detections(ta).detected)
            [inferingTags(tagIndex).particuleSet quality] = weightTagParticules(	polarModel, ...
                inferingTags(tagIndex).particuleSet, ...
                robotByParticules.position, ...
                antenna, ...
                1);

            newExplorationParticuleSet = initParticules(	polarModel, ...
                numberParticules, ...
                robotByParticules.position, ...
                antenna);

            explorationCount = explorationCount+1;
            explorationParticules(numberParticules*(explorationCount-1)+1:numberParticules*(explorationCount)) = newExplorationParticuleSet;

        else
            [inferingTags(tagIndex).particuleSet quality] = weightTagParticules(  polarModel, ...
                inferingTags(tagIndex).particuleSet, ...
                robotByParticules.position, ...
                antenna, ...
                0);
        end
        globalQuality = globalQuality+quality;
    end
    globalQuality = globalQuality/antennas;
    explorationParticules = explorationParticules(1:numberParticules*explorationCount);
    inferingTags(tagIndex).particuleSet = mergeParticules(inferingTags(tagIndex).particuleSet,inertia+(1-inertia)*globalQuality,explorationParticules,(1-inertia)*(1-globalQuality)/explorationCount);
    inferingTags(tagIndex).particuleSet = resampleParticuleSetUnionPosition(inferingTags(tagIndex).particuleSet,numberParticules);
end

for j = 1:length(detections)
    if(detections(j).detected)
        tagIndex = searchTag(inferingTags,detections(j).tagId);
        if(tagIndex == 0)
            particuleSet = repmat(tagParticule,1,numberParticules);
            tagByParticules = struct('tagId','xxx','particuleSet',particuleSet,'position',[-inf -inf]);
            newTag = detections(j).tagId;
            explorationParticules = repmat(tagParticule,1,numberParticules*antennas);
            explorationCount = 0;
            for antenna = 0:antennas-1
                ta = searchDetection(detections,newTag,antenna);
                if(detections(ta).detected)
                    tagByParticules.tagId = newTag;
                    newExplorationParticuleSet = initParticules(  polarModel, ...
                        numberParticules, ...
                        robotByParticules.position, ...
                        antenna);
                    explorationCount = explorationCount+1;
                    explorationParticules(numberParticules*(explorationCount-1)+1:numberParticules*(explorationCount)) = newExplorationParticuleSet;

                end
            end
            explorationParticules = explorationParticules(1:numberParticules*explorationCount);
            
            for antenna = 0:antennas-1

                ta = searchDetection(detections,detections(j).tagId,antenna);

                if(detections(ta).detected)  
                    
                        [explorationParticules quality] = weightTagParticules(  polarModel, ...
                        explorationParticules, ...
                        robotByParticules.position, ...
                        antenna, ...
                        1);
                else
                    [explorationParticules quality] = weightTagParticules(  polarModel, ...
                        explorationParticules, ...
                        robotByParticules.position, ...
                        antenna, ...
                        0);
                end
            end
            explorationParticules = normalizeParticuleSet(explorationParticules);
            tagByParticules.particuleSet = resampleParticuleSet(explorationParticules,numberParticules);
            inferingTags = [inferingTags tagByParticules];

        end
    end
end

for tagIndex = 1:length(inferingTags);
    inferingTags(tagIndex).position = estimateTagPosition(inferingTags(tagIndex).particuleSet);
end

if (nargout < 1)
    plotTagsEstimation(inferingTags,robotByParticules.position)
end
