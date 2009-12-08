clear all
close all

dist = 6;
stepDist = 0.01;
ang = pi/4;
stepAngle = pi/180*1;

antennas = 8;

scriptRealTagsPosition

robotPosition = struct('robotPosition',[-inf -inf -inf]);

robotPositions = repmat(robotPosition,1,dist/stepDist*ang/stepAngle);

robotPositionCount = 0;
for x = stepDist:stepDist:dist
    for angle = stepAngle:stepAngle:ang
        
        robotPositionCount = robotPositionCount + 1;
        robotPositions(robotPositionCount).robotPosition = [x 0 angle];
       
    end
end

evaluation = struct('distance',0,'angleRadians',0,'detected',0);

evaluations = repmat(evaluation,1,length(robotPositions)*length(tags)*antennas);
evaluationCount = 0;

for k = 1:length(robotPositions)
    
    detectionsIt = rfidSimulation(robotPositions(k).robotPosition,tags);
    
    for j = 1:length(detectionsIt)
       
        evaluationCount = evaluationCount + 1;
        
        
        tagIndex = searchTag(tags,detectionsIt(j).tagId);
        
        [distance,angleRadians] =  getRelativePosition(robotPositions(k).robotPosition,tags(tagIndex).position,detectionsIt(j).antenna);
       
        evaluation.distance = distance;
        evaluation.angleRadians = angleRadians;
        evaluation.detected = detectionsIt(j).detected;
        
        evaluations(evaluationCount) = evaluation;
       
    end
    
end

evaluations = evaluations(1:evaluationCount);