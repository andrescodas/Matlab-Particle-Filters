function evaluations = detectionFile2Evaluations(detectionsFile,realTags)
%
% evaluations = detectionFile2Evaluations(detectionsFile,realTags)
%
tag = struct('tagId','32432frdes','position',[0 0],'founded',1); %%initialize founded
tags = repmat(tag,1,length(realTags));

for i = 1:length(realTags)
   tags(i).tagId = realTags(i).tagId;
   tags(i).position = realTags(i).position;
end


%% Counting total number of lines in detectection file
readingFile = fopen(detectionsFile,'r');
lineCounter = 0;
while(1)
	line = fgetl(readingFile);
        if (~ischar(line))
            break;
        else
            lineCounter = lineCounter + 1;
        end
end
totalLines = lineCounter;


%% Some variables initialization
antennas = 8;
robotPositionAnt = [-inf -inf -inf];
lineCounter = 0;

%% Creating information Structures

evaluation = struct('distance',0,'angleRadians',0,'detected',0,'tagId','xxx','antenna',-1);
evaluations = repmat(evaluation,1,totalLines*antennas*length(tags));
evalCounter = 0;

readingFile = fopen(detectionsFile,'r');
while(1)

    line = fgetl(readingFile);
    if (~ischar(line))
        break;
    else
        porcent = lineCounter / totalLines*100
        lineCounter = lineCounter + 1;
        
        tagId = char(sscanf(line,'%*f %*f %*f %s %*d %*d %*d %*d %*d %*d %*d %*d')');
        values =sscanf(line,'%f %f %f %*s %d %d %d %d %d %d %d %d');

        robotPosition = [values(1) values(2) values(3)];  %% X Y THETA
        detections = values(4:11);                        %% 1 Tag detected by antenna, 0 not detected
            
        if ((robotPosition(1) ~= robotPositionAnt(1)) || (robotPosition(2) ~= robotPositionAnt(2)) || (robotPosition(3) ~= robotPositionAnt(3)))
            %% New position, look for which TAGS have not been detected at
            %% the last position and reinitilize

            for j = 1:length(tags)
                if (~tags(j).founded)
                    for i = 0:antennas-1
                    
                        [distance,angleRadians] = getRelativePosition(robotPositionAnt,tags(j).position,i);
                        evalCounter = evalCounter + 1;
                        evaluations(evalCounter) = struct('distance',distance,'angleRadians',angleRadians,'detected',0,'tagId',tags(j).tagId,'antenna',i);
                  
                    end
                end
                tags(j).founded = 0;  
            end
            
            robotPositionAnt(1) = robotPosition(1);
            robotPositionAnt(2) = robotPosition(2);
            robotPositionAnt(3) = robotPosition(3);
        end
           
        if (strcmp(tagId,'NULL'))
        
            %% nothing detected
            
                for j = 1:length(tags)
                   for i = 0:antennas-1    
                        [distance,angleRadians] = getRelativePosition(robotPosition,tags(j).position,i);
                        evalCounter = evalCounter + 1;
                        evaluations(evalCounter) = struct('distance',distance,'angleRadians',angleRadians,'detected',0,'tagId',tagId,'antenna',i);
                   end
                   tags(j).founded = 1;
                end
            
        else
           %% A Tag was detected by some antenna at that position
               j = searchTag(tags,tagId);
               tags(j).founded = 1;
               
               for i = 0:antennas-1
                   [distance,angleRadians] = getRelativePosition(robotPosition,tags(j).position,i);
                   evalCounter = evalCounter + 1;
                   evaluations(evalCounter) = struct('distance',distance,'angleRadians',angleRadians,'detected',detections(i+1),'tagId',tagId,'antenna',i);
               end     
        end 
    end
end

% Eliminating not used allocated memory
evaluations = evaluations(1:evalCounter);

