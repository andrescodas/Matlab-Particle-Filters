%
inferingTags = [];
% robotParticule = struct('position',[0 0 0],'weight',1/numberParticulesRobot);
% particuleSet = repmat(robotParticule,1,numberParticulesRobot);
% robotByParticules = struct('particuleSet',particuleSet,'position',[0 0 0]);
close all

%exploringRobotParticles = 0;

movementSimulation= struct('robotPosition', [5 5 pi],'rflexPosition',[5 5 pi]);

antennas = 8;
robotRadius =0.35;
numberParticulesRobot = 200;
numberParticulesTag = 100;
inertiaRobot = 1;
inertiaTag = 0.98;


initialParticlesPosition = movementSimulation.robotPosition;

robotParticule = struct('position',initialParticlesPosition,'weight',1/numberParticulesRobot);
particuleSet = repmat(robotParticule,1,numberParticulesRobot);
robotByParticules = struct('particuleSet',particuleSet,'position',initialParticlesPosition);

load polarModel

tag = struct('tagId','xxx','position',[-inf -inf]);


%realTags = repmat(tag,1,5);
% 
% tag.tagId = 'a';
% tag.position = [10 10];
% realTags(1) = tag;
% 
% tag.tagId = 'b';
% tag.position = [10 -10];
% realTags(2) = tag;
% 
% tag.tagId = 'c';
% tag.position = [-10 10];
% realTags(3) = tag;
% 
% tag.tagId = 'd';
% tag.position = [-10 -10];
% realTags(4) = tag;
% 
% tag.tagId = 'e';
% tag.position = [0 0];
% realTags(5) = tag;
% 
% tag.tagId = 'f';
% tag.position = [5 5];
% realTags(6) = tag;
% 
% fixedTags = realTags(1:4);

realTags = realTagsPosition(1);
fixedTags = realTagsPosition(1);


robotPath = getRobotPath();
%visiting = 0;
totalSteps = 300;

rflexData = zeros(totalSteps,3);
robotPositionData = zeros(totalSteps,3);
rfidData = zeros(totalSteps,3);

piloMove = [0 0 0];

visiting = 0;
for k = 1:totalSteps%length(robotPositions)
    display(strcat('Porcent of robotPositions = ',num2str(k/totalSteps)))

%     if((rand < 0.9) && (~isempty(fixedTags)))
% 
%         visiting = visiting + 1;
%         if(length(fixedTags)<visiting)
%             visiting = 1;
%         end
% 
%         vector = fixedTags(visiting).position - movementSimulation.robotPosition(1:2);
% 
%         rotatingAngle = atan2(vector(2),vector(1)) + pi/2;
% 
%         rotResult = rotation([2 0],rotatingAngle);
% 
%         piloMove(1:2) = vector + rotResult;
%         piloMove(3) = (rand-0.5)*2*pi;
%     else
%         piloMove = [(rand-0.5)*12 (rand-0.5)*12 (rand-0.5)*2*pi] - movementSimulation.robotPosition;
%     end
% 
%     piloMove = rotation(piloMove,-movementSimulation.robotPosition(3));
% 
%     movementSimulation = simulateMovement(piloMove,movementSimulation.robotPosition,movementSimulation.rflexPosition);

   if(visiting > length(realTags))
        visiting = 1;
    else
        visiting = visiting + 1;
    end
    piloMove(1:2) = robotPath(visiting,:);
    piloMove(3) =  (rand-0.5)*2*pi ;
    piloMove = piloMove - movementSimulation.robotPosition;
    
    piloMove = rotation(piloMove,-movementSimulation.robotPosition(3));

    movementSimulation = simulateMovement(piloMove,movementSimulation.robotPosition,movementSimulation.rflexPosition);

    detections = rfidSimulation(movementSimulation.robotPosition,realTags,polarModel);

    
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

    for nit =  1:length(newInferingTagsDetection)
        if(searchTag(inferingTags,newInferingTagsDetection(nit).tagId) == 0)
            newTagDetections = sortDetectionsByTagId(newInferingTagsDetection,newInferingTagsDetection(nit).tagId);
            particuleSet = resampleExplore([],polarModel,newTagDetections,robotRadius,0,robotByParticules.particuleSet,numberParticulesTag);
            inferingTags = [inferingTags struct('tagId',newInferingTagsDetection(nit).tagId,'particuleSet',particuleSet,'position',[-inf -inf])];

        end
    end

    for tagIndex = 1:length(inferingTags);
        inferingTags(tagIndex).position = estimateTagPosition(inferingTags(tagIndex).particuleSet);
    end


    plotSlamEstimation(inferingTags,robotByParticules,movementSimulation.robotPosition,realTags)
    
    rflexData(k,:) = movementSimulation.rflexPosition;
    robotPositionData(k,:) = movementSimulation.robotPosition;
    rfidData(k,:) = robotByParticules.position;

end

plotResults(robotPositionData,rflexData,rfidData);