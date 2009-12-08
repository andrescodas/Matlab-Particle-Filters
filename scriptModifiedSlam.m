%
inferingTags = [];
% robotParticule = struct('position',[0 0 0],'weight',1/numberParticulesRobot);
% particuleSet = repmat(robotParticule,1,numberParticulesRobot);
% robotByParticules = struct('particuleSet',particuleSet,'estimatedPosition',[0 0 0]);
close all

movementSimulation= struct('robotPosition', [5 5 pi],'rflexPosition',[5 5 pi]);


robotParticule = struct('position',[5 5 pi],'weight',1/numberParticulesRobot);
particuleSet = repmat(robotParticule,1,numberParticulesRobot);
robotByParticules = struct('particuleSet',particuleSet,'estimatedPosition',[5 5 pi]);


antennas = 8;

numberParticulesRobot = 100;
numberParticulesTag = 500;

inertiaRobot = 0.99;
inertiaTag = 0.99;

load polarModel

tag = struct('tagId','xxx','position',[-inf -inf]);
realTags = repmat(tag,1,5);

tag.tagId = 'a';
tag.position = [10 10];
realTags(1) = tag;

tag.tagId = 'b';
tag.position = [10 -10];
realTags(2) = tag;

tag.tagId = 'c';
tag.position = [-10 10];
realTags(3) = tag;

tag.tagId = 'd';
tag.position = [-10 -10];
realTags(4) = tag;

tag.tagId = 'e';
tag.position = [0 0];
realTags(5) = tag;

fixedTags = realTags(1:4);

piloMove = [0 0 0];

visiting = 0;

for k = 1:1000%length(robotPositions)
    display(strcat('Porcent of robotPositions = ',num2str(k/1000)))


    if((rand < 0.5) && (~isempty(inferingTags)))

        visiting = visiting + 1;
        if(length(inferingTags)<visiting)
            visiting = 1;
        end

        vector = inferingTags(visiting).estimatedPosition - robotByParticules.estimatedPosition(1:2);

        rotatingAngle = atan2(vector(2),vector(1)) + pi/2;

        rotResult = rotation([2 0],rotatingAngle);

        piloMove(1:2) = vector + rotResult;
        piloMove(3) = (rand-0.5)*2*pi;
    else
        piloMove = [(rand-0.5)*12 (rand-0.5)*12 (rand-0.5)*2*pi] - movementSimulation.robotPosition;
    end

    piloMove = rotation(piloMove,-movementSimulation.robotPosition(3));

    movementSimulation = simulateMovement(piloMove,movementSimulation.robotPosition,movementSimulation.rflexPosition);

    detections = rfidSimulation(movementSimulation.robotPosition,realTags,polarModel);

    [fixedTagDetections,inferingTagDetections] = separeFixedInferingDetections(detections,fixedTags);

    robotByParticules = locateRobot(polarModel,fixedTagDetections,movementSimulation,fixedTags,robotByParticules,numberParticulesRobot,inertiaRobot,antennas);

    newInferingTags = clearInferingTagsWeight(inferingTags);

    globalQuality = 0;
    
    for rp = 1:length(robotByParticules.particuleSet)

        [weightedTags,quality] = weightNormalizeTags(   polarModel,...
                                                        inferingTagDetections,...
                                                        inferingTags,...
                                                        robotByParticules.particuleSet(rp).position,...
                                                        antennas);
                                                    
        newInferingTags = sumtagsWeight(weightedTags,newInferingTags);
        
        globalQuality = globalQuality + quality;
    end
    
    globalQuality = globalQuality/rp;
    
    newSet1 = scaleParticuleSet(weightedTags,1/rp);

    
    
    
    
    
    % [angle,translation] = iterativeClosestPoint(realTags,inferingTags);

    plotSlamEstimation(inferingTags,robotByParticules,movementSimulation.robotPosition,realTags)

end