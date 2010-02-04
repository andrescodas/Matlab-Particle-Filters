function [posData,tagData] = modifiedSlam(inferingTags,movementSimulations,detectionsList,initialParticlesPosition,numberParticulesRobot,numberParticulesTag,inertiaRobot,inertiaTag,polarModel)

antennas = 8;
robotRadius =0.35;

robotParticule = struct('position',initialParticlesPosition,'weight',1/numberParticulesRobot);
particuleSet = repmat(robotParticule,1,numberParticulesRobot);
robotByParticules = struct('particuleSet',particuleSet,'position',initialParticlesPosition);

fixedTags = realTagsPosition(-1);

totalSteps = length(movementSimulations);

posData = zeros(totalSteps,3);
tagData = zeros(totalSteps,2);

for k = 1:totalSteps%length(robotPositions)
    
    display(strcat('Porcent of robotPositions = ',num2str(k/totalSteps)))

    movementSimulation = movementSimulations(k);

    detections = detectionsList(k).detections;
 
    [fixedTagDetections,inferingTagDetections] = sortDetectionsByTag(detections,fixedTags);

    %     tic
    robotByParticules = locateRobot(polarModel,fixedTagDetections,movementSimulation,fixedTags,robotByParticules,numberParticulesRobot,inertiaRobot,antennas);

    %     display('---------------------')
    %     display('Locate Robot')
    %     toc
    %     display('---------------------')
    [knownInferingTagsDetection,newInferingTagsDetection] = sortDetectionsByTag(inferingTagDetections,inferingTags);

    for it = 1:length(inferingTags)

        tagItDetections = sortDetectionsByTag(knownInferingTagsDetection,inferingTags(it));
        %         tic
        [weightedTags,quality] = weightNormalizeTags(   polarModel,...
            tagItDetections,...
            inferingTags(it),...
            robotByParticules,...
            antennas);

        %         display('---------------------')
        %         display('Weight Normalize Tags')
        %         toc
        %         display('---------------------')


        if(quality>1)
            warning('quality > 1')
            warn = input('quality with strange value')
        else
            display(strcat('quality = ',num2str(quality)))
        end
        inferingTags(it).particuleSet = resampleExplore(weightedTags.particuleSet,polarModel,tagItDetections,robotRadius,inertiaTag+(1-inertiaTag)*quality,robotByParticules.particuleSet,numberParticulesTag);
    end
% 
%     for nit =  1:length(newInferingTagsDetection)
%         if(searchTag(inferingTags,newInferingTagsDetection(nit).tagId) == 0)
%             newTagDetections = sortDetectionsByTagId(newInferingTagsDetection,newInferingTagsDetection(nit).tagId);
%             particuleSet = resampleExplore([],polarModel,newTagDetections,robotRadius,0,robotByParticules.particuleSet,numberParticulesTag);
%             inferingTags = [inferingTags struct('tagId',newInferingTagsDetection(nit).tagId,'particuleSet',particuleSet,'position',[-inf -inf])];
% 
%         end
%     end

    for tagIndex = 1:length(inferingTags);
        inferingTags(tagIndex).position = estimateTagPosition(inferingTags(tagIndex).particuleSet);  %% only for one tag!
        tagData(k,:) = inferingTags(1).position;
    end
    
    posData(k,:) = robotByParticules.position;
  

end