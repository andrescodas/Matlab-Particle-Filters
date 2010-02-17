function [] = plotResults(robotPositions,rflexPositions,rfidPositions,tagPos)


robotPath = getRobotPath();
robotPathClosed = [robotPath;robotPath(1,:)];


positionsXM = robotPositions(:,1);
positionsYM = robotPositions(:,2);
positionsTM = robotPositions(:,3);


figure

%positionsXMD = positionsXM - [0 positionsXM(1:(length((positionsXM))-1))];
%positionsYMD = positionsYM - [0 positionsYM(1:(length((positionsYM))-1))];
%positionsTMD = positionsTM - [0 positionsTM(1:(length((positionsTM))-1))];

hold off
%  plot(positionsXM,positionsYM,'h',positionsXM,positionsYM)
plot(positionsXM,positionsYM);
xlim([-1.5 3])
hold all


positionsXO = rflexPositions(:,1);
positionsYO = rflexPositions(:,2);
positionsTO = rflexPositions(:,3);


grid on
figure
%plot(positionsXO,positionsYO,'o',positionsXO,positionsYO)
plot(robotPathClosed(:,1),robotPathClosed(:,2),'r')
hold all
plot(positionsXO,positionsYO)
grid on
legend('Reference Trajectory','Odometry Trajectory');
xlabel('position (m)')
ylabel('position (m)')

%positionsXOD = positionsXO - [0 positionsXO(1:(length((positionsXO))-1))];
%positionsYOD = positionsYO - [0 positionsYO(1:(length((positionsYO))-1))];
%positionsTOD = positionsTO - [0 positionsTO(1:(length((positionsTO))-1))];

positionsXRF = rfidPositions(:,1);
positionsYRF = rfidPositions(:,2);
positionsTRF = rfidPositions(:,3);


figure
%plot(positionsXRF,positionsYRF,'h',positionsXRF,positionsYRF)
plot(robotPathClosed(:,1),robotPathClosed(:,2),'r')
hold all
plot(positionsXRF,positionsYRF)
grid on
legend('Reference Trajectory','Odometry-RFID Trajectory');
xlabel('position (m)')
ylabel('position (m)')
%
%positionsXRFD = positionsXRF - [0 positionsXRF(1:(length((positionsXRF))-1))];
%positionsYRFD = positionsYRF - [0 positionsYRF(1:(length((positionsYRF))-1))];
%positionsTRFD = positionsTRF - [0 positionsTRF(1:(length((positionsTRF))-1))];


errorO = distanceMatlab(positionsXO-positionsXM,positionsYO-positionsYM);
errorRF = distanceMatlab(positionsXRF-positionsXM,positionsYRF-positionsYM);




figure
hold off
%plot(errorO,'o')

%plot(errorRF,'h')
plot(errorO)
hold all
plot(errorRF)
grid on
title('Error Comparison respect to Motion Capture System ')
xlabel('Iteration Step')
ylabel('Absolute error (m)')
legend('Odometry','Odometry-RFID')





figure
subplot(3,2,1)
hold off
plot(positionsXO-positionsXM,'o')
hold all
plot(positionsXO-positionsXM)
plot(positionsXRF-positionsXM,'h')
plot(positionsXRF-positionsXM)
grid on

subplot(3,2,2)
hold off
plot(abs(positionsXO-positionsXM),'o')
hold all
plot(abs(positionsXO-positionsXM))
plot(abs(positionsXRF-positionsXM),'h')
plot(abs(positionsXRF-positionsXM))
grid on

subplot(3,2,3)
hold off
plot(positionsYO-positionsYM,'o')
hold all
plot(positionsYRF-positionsYM,'h')
plot(positionsYO-positionsYM)
plot(positionsYRF-positionsYM)
grid on


subplot(3,2,4)
hold off
plot(abs(positionsYO-positionsYM),'o')
hold all
plot(abs(positionsYO-positionsYM))
plot(abs(positionsYRF-positionsYM),'h')
plot(abs(positionsYRF-positionsYM))
grid on

subplot(3,2,5)
hold off
plot(180/pi*angleWrap(positionsTO-positionsTM),'o')
hold all
plot(180/pi*angleWrap(positionsTO-positionsTM))
plot(180/pi*angleWrap(positionsTRF-positionsTM),'h')
plot(180/pi*angleWrap(positionsTRF-positionsTM))
grid on

subplot(3,2,6)
hold off
plot(abs(180/pi*angleWrap(positionsTO-positionsTM)),'o')
hold all
plot(abs(180/pi*angleWrap(positionsTRF-positionsTM)),'h')
plot(abs(180/pi*angleWrap(positionsTO-positionsTM)))
plot(abs(180/pi*angleWrap(positionsTRF-positionsTM)))
grid on

xlabel('Iteration Step')
ylabel('Absolute angle error (degree)')
legend('Odometry','Odometry-RFID')


if (nargin >3)

    positionsXT = tagPos(:,1);
    positionsYT = tagPos(:,2);

    tagRealPos = [1.5 0.5];

    figure
    plot(positionsXT,positionsYT,tagRealPos(1),tagRealPos(2),'k*')

    title('Tag position Estimation')
    xlabel('position (m)')
    ylabel('position (m)')
    legend('Estimations','Real Position')
    grid on

    figure
    tagErrorX = positionsXT - tagRealPos(1)*ones(size(positionsXT));
    tagErrorY = positionsYT - tagRealPos(2)*ones(size(positionsYT));
    errorTag = distanceMatlab(tagErrorX,tagErrorY);
    plot(errorTag);

    xlabel('Iteration Step')
    ylabel('Distance Between Real Position and Estimated Position (m)')
    grid on


end