function newRobotByParticules = locateRobot(polarModel,detections,movementSimulation,inferingTags,robotByParticules,numberParticulesRobot,inertiaRobot,antennas)

if(nargin<8)
    antennas = 8;
    if(nargin<7)
        inertiaRobot = 0.99;
        if(nargin<6)
            numberParticulesRobot = 100;
            if(nargin<5)
                robotParticule = struct('position',[0 0 0],'weight',1/numberParticulesRobot);
                particuleSet = repmat(robotParticule,1,numberParticulesRobot);
                robotByParticules = struct('particuleSet',particuleSet,'estimatedPosition',[0 0 0]);
                if(nargin<4)
                    inferingTags = [];
                    if(nargin < 3)
                        robotPosition = [(rand-0.5)*6 (rand-0.5)*6 (rand-0.5)*2*pi];
                        piloMove = [(rand-0.5)*6 (rand-0.5)*6 (rand-0.5)*2*pi] - robotPosition;
                        movementSimulation = simulateMovement(piloMove,robotPosition);
                        if(nargin < 2)
                            tag.tagId = 'a';
                            tag.position = [0 1];
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
                            detections = rfidSimulation(robotPosition,realTags,polarmodel);
                            if(nargin<1)
                                load polarModel
                            end
                        end
                    end
                end
            end
        end
    end
end

newRobotByParticules = transitionModel(robotByParticules,movementSimulation.rflexPosition,movementSimulation.rflexPositionBefore,movementSimulation.rflexCov);

newRobotByParticules = updateRobotParticules(newRobotByParticules,inferingTags,detections,numberParticulesRobot,inertiaRobot,antennas,polarModel);

if (nargout<1)
    plotRobotEstimation(newRobotByParticules,inferingTags)
end
