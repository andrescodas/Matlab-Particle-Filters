function newPosition = rotation(position,theta)

newPosition = position;

costheta = cos(theta);
sintheta = sin(theta);

newPosition(1) = costheta*position(1) - sintheta*position(2);
newPosition(2) = sintheta*position(1) + costheta*position(2);
