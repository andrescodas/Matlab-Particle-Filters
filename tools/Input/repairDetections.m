function [problems,good,tagsbad,tagsgood] = repairDetections(detectionsFile,realTags,outputFileName,detectionPolarModel)
%
% evaluations = detectionFile2Evaluations(detectionsFile,realTags)
%
tag = struct('tagId','32432frdes','position',[0 0],'founded',1); %%initialize founded
tags = repmat(tag,1,length(realTags));

for i = 1:length(realTags)
    tags(i).tagId = realTags(i).tagId;
    tags(i).position = realTags(i).position;
end

%

problems = zeros(1,8);
good = zeros(1,8);
tagsbad = zeros(1,length(tags));
tagsgood = zeros(1,length(tags));

outputFile = fopen(outputFileName,'w');

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
fclose(readingFile);
totalLines = lineCounter;




%% Some variables initialization
antennas = 8;
robotPositionAnt = [-inf -inf -inf];
lineCounter = 0;

%% Creating information Structures

readingFile = fopen(detectionsFile,'r');
while(1)

    line = fgetl(readingFile);
    if (~ischar(line))
        break;
    else
        %%       porcent = lineCounter / totalLines*100
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

                    fprintf(outputFile,'%0.5f %0.5f %0.5f %s',robotPositionAnt(1),robotPositionAnt(2),robotPositionAnt(3),tags(j).tagId);

                    for i = 0:antennas-1

                        [distance,angleRadians] = getRelativePosition(robotPositionAnt,tags(j).position,i);
                        p = getDetectionProbabilityPolar(detectionPolarModel,distance,angleRadians);

                        if(i == 5)
                            if(detections(i+1) ==1 )
                                warning('Antenna 5 detected')
                            end
                            p = 0;
                        end

                        if (p > 0.5)
                            problems(i+1) = problems(i+1)+1;
                            tagsbad(j) = tagsbad(j) + 1; 
                            fprintf(outputFile,' %d',1);
                        else
                            good(i+1) = good(i+1)+1;
                             tagsgood(j) = tagsgood(j) +1;
                            fprintf(outputFile,' %d',0);
                        end

                    end
                    fprintf(outputFile,'\n');
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
                fprintf(outputFile,'%0.5f %0.5f %0.5f %s',robotPositionAnt(1),robotPositionAnt(2),robotPositionAnt(3),tags(j).tagId);

                for i = 0:antennas-1

                    [distance,angleRadians] = getRelativePosition(robotPositionAnt,tags(j).position,i);
                    p = getDetectionProbabilityPolar(detectionPolarModel,distance,angleRadians);

                    if(i == 5)
                        if(detections(i+1) ==1 )
                            warning('Antenna 5 detected')
                        end
                        p = 0;
                    end

                    if (p > 0.5)
                        if(detections(i+1) ~= 1)
                            problems(i+1) = problems(i+1)+1;
                            tagsbad(j) = tagsbad(j) +1 ;
                        else
                            good(i+1) = good(i+1);
                             tagsgood(j) = tagsgood(j) +1;
                        end
                        fprintf(outputFile,' %d',1);
                    else
                        if(detections(i+1) ~= 0)
                            problems(i+1) = problems(i+1)+1;
                            tagsbad(j) = tagsbad(j) +1 ;
                        else
                            good(i+1) = good(i+1)+1;
                            tagsgood(j) = tagsgood(j) +1;
                        end
                        fprintf(outputFile,' %d',0);
                    end

                end
                fprintf(outputFile,'\n');
                tags(j).founded = 1;
            end

        else
            %% A Tag was detected by some antenna at that position
            j = searchTag(tags,tagId);
            tags(j).founded = 1;

            fprintf(outputFile,'%0.5f %0.5f %0.5f %s',robotPositionAnt(1),robotPositionAnt(2),robotPositionAnt(3),tags(j).tagId);

            for i = 0:antennas-1

                [distance,angleRadians] = getRelativePosition(robotPositionAnt,tags(j).position,i);
                p = getDetectionProbabilityPolar(detectionPolarModel,distance,angleRadians);

                if(i == 5)
                    if(detections(i+1) ==1 )
                        warning('Antenna 5 detected');
                    end
                    p = 0;
                end

                if (p > 0.5)
                    if(detections(i+1) ~= 1)
                        problems(i+1) = problems(i+1)+1;
                        tagsbad(j) = tagsbad(j) +1 ;
                    else
                        good(i+1) = good(i+1)+1;
                        tagsgood(j) = tagsgood(j) +1;
                    end
                    fprintf(outputFile,' %d',1);
                else
                    if(detections(i+1) ~= 0)
                        problems(i+1) = problems(i+1)+1;
                        tagsbad(j) = tagsbad(j) +1 ;
                    else
                        good(i+1) = good(i+1)+1;
                        tagsgood(j) = tagsgood(j) +1;
                    end
                    fprintf(outputFile,' %d',0);
                end

            end
            fprintf(outputFile,'\n');
        end
    end
end
fclose(readingFile);
fclose(outputFile);
