function p = likelihoodDetection(x,y,theta)

distance = sqrt(x^2+y^2);
angle = angleWrap(theta+pi);

p = antennaModelGeom(distance,angle);