%
% robotParticule = struct('position',[0 0 0],'weight',1/numberParticulesRobot);
% particuleSet = repmat(robotParticule,1,numberParticulesRobot);
% robotByParticules = struct('particuleSet',particuleSet,'position',[0 0 0]);

clear all


antennas = 8;

numberParticulesRobot = 100;
numberParticulesTag = 1;

inertiaRobot = 0.95;



movementSimulation= struct('robotPosition', [5 5 pi],'rflexPosition',[0 0 0]);


robotParticule = struct('position',[0 0 0],'weight',1/numberParticulesRobot);
particuleSet = repmat(robotParticule,1,numberParticulesRobot);
robotByParticules = struct('particuleSet',particuleSet,'position',[0 0 0]);




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

tagParticule = struct('position',realTags(1).position,'weight',1/numberParticulesTag);
particuleSet = repmat(tagParticule,1,numberParticulesTag);
tagByParticules = struct('tagId',realTags(1).tagId,'particuleSet',particuleSet,'position',realTags(1).position);

inferingTags = repmat(tagByParticules,1,length(realTags));

for i = 2:length(realTags)

    tagParticule = struct('position',realTags(i).position,'weight',1/numberParticulesTag);
    particuleSet = repmat(tagParticule,1,numberParticulesTag);
    tagByParticules = struct('tagId',realTags(i).tagId,'particuleSet',particuleSet,'position',realTags(i).position);

    inferingTags(i) = tagByParticules;

end


piloMove = [0 0 0];
visiting = 0;

for k = 1:1000%length(robotPositions)
    display(strcat('Porcent of robotPositions = ',num2str(k/1000)))


    if((rand < 0.5) && (~isempty(inferingTags)))

        visiting = visiting + 1;
        if(length(inferingTags)<visiting)
            visiting = 1;
        end

        vector = inferingTags(visiting).position - robotByParticules.position(1:2);

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

    robotByParticules = locateRobot(polarModel,detections,movementSimulation,inferingTags,robotByParticules,numberParticulesRobot,inertiaRobot,antennas);

    % inferingTags = locateTag(polarModel,detections,inferingTags,robotByParticules,numberParticulesTag,inertiaTag,antennas);


    plotRobotEstimation(robotByParticules,inferingTags,movementSimulation.robotPosition,movementSimulation.rflexPosition)

end
