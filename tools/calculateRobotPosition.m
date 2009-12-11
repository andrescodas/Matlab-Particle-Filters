function robotPosition = calculateRobotPosition(tag,antenna,distance,anglePolar,angleRadians)
robotPosition = [0 0 0];

robotPosition(1) = tag.position(1) + distance*cos(anglePolar);
robotPosition(2) = tag.position(2) + distance*sin(anglePolar);
robotPosition(3) = angleWrap(anglePolar + pi + angleRadians - getAntennaAngle(antenna));
