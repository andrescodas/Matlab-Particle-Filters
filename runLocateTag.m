%
inferingTags = [];
% robotParticule = struct('position',[0 0 0],'weight',1/numberParticulesRobot);
% particuleSet = repmat(robotParticule,1,numberParticulesRobot);
% robotByParticules = struct('particuleSet',particuleSet,'position',[0 0 0]);
close all

movementSimulation= struct('robotPosition', [5 5 pi],'rflexPosition',[5 5 pi]);

antennas = 8;

numberParticulesRobot = 1;
numberParticulesTag = 500;

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

robotParticule = struct('position',movementSimulation.robotPosition,'weight',1/numberParticulesRobot);
particuleSet = repmat(robotParticule,1,numberParticulesRobot);
robotByParticules = struct('particuleSet',particuleSet,'position',movementSimulation.robotPosition);



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

%    robotByParticules = locateRobot(polarModel,detections,movementSimulation,inferingTags,robotByParticules,numberParticulesRobot,inertiaRobot,antennas);
    robotByParticules.particuleSet(1).position = movementSimulation.robotPosition;
    robotByParticules.position = movementSimulation.robotPosition;

    inferingTags = locateTagMod(polarModel,detections,inferingTags,robotByParticules,numberParticulesTag,inertiaTag,antennas);
                
    plotTagsEstimation(inferingTags,robotByParticules.position,realTags)

end
