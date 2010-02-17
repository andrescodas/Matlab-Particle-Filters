%
inferingTags = [];
% robotParticule = struct('position',[0 0 0],'weight',1/numberParticulesRobot);
% particuleSet = repmat(robotParticule,1,numberParticulesRobot);
% robotByParticules = struct('particuleSet',particuleSet,'position',[0 0 0]);
close all

movementSimulation= struct('robotPosition', [0 0 0],'rflexPosition',[0 0 0]);

totalSteps = 300;

antennas = 8;

numberParticulesRobot = 500;
numberParticulesTag = 200;

inertiaRobot = 0.90;
inertiaTag = 0.90;


robotParticule = struct('position',[0 0 0],'weight',1/numberParticulesRobot);
particuleSet = repmat(robotParticule,1,numberParticulesRobot);
robotByParticules = struct('particuleSet',particuleSet,'position',[0 0 0]);

performance = zeros(2,totalSteps);

load polarModel


realTags = realTagsPosition(1);
robotPath = getRobotPath();

piloMove = [0 0 0];
visiting = 0;
for k = 1:totalSteps%length(robotPositions)
    display(strcat('Porcent of robotPositions = ',num2str(k/totalSteps)))


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

    detectionsLoc = sortDetectionsByTag(detections,inferingTags);
    
    robotByParticules = locateRobot(polarModel,detectionsLoc,movementSimulation,inferingTags,robotByParticules,numberParticulesRobot,inertiaRobot,antennas);

    inferingTags = locateTagMod(polarModel,detections,inferingTags,robotByParticules,numberParticulesTag,inertiaTag,antennas);

    [angle,translation,fval] = iterativeClosestPoint(realTags,inferingTags);

    performance(1,k) = fval/length(inferingTags);
    
    costheta = cos(angle);
    sintheta = sin(angle);
    rotationMatrix = [costheta,-sintheta;sintheta,costheta]';
    
    robotPos = robotByParticules.position(1:2) * rotationMatrix + translation;
    erro = movementSimulation.robotPosition(1:2) - robotPos;
    performance(2,k) = sqrt(erro*erro');
    
    performance(:,k)
    
%   plotSlamEstimation(inferingTags,robotByParticules,movementSimulation.robotPosition,realTags,angle,translation);

end
