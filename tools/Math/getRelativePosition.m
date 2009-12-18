function [distance,angleRadians] =  getRelativePosition(robotPosition,tagPosition,antennaNumber)


% TODO
antennaRadius = 0.35;


% Antenna direction relative to -->  center:  robot position , direction: global x axis direction
% double thetaAntenna = ANTENNA_POSITION_ANGLES[antenna_number]+ robot_position_theta;
thetaAntenna = getAntennaAngle(antennaNumber) + robotPosition(3);

%antenna absolute position
xa = robotPosition(1) + antennaRadius * cos(thetaAntenna);
ya = robotPosition(2) + antennaRadius * sin(thetaAntenna);


distance = sqrt((tagPosition(1)-xa)^2 + (tagPosition(2)-ya)^2);

% Tag angleRadians relative to --> center: antenna position, direction: global x axis direction
thetaTag = atan2((tagPosition(2)-ya),(tagPosition(1)-xa));

angleRadians = angleWrap(thetaTag - thetaAntenna);

