function [ cost grad] = closestPointCostFunc(realTags,inferredTags,x0)

rotationAngle = x0(1);
translation = x0(2:3);

cost = 0;

cosr = cos(rotationAngle);
sinr = sin(rotationAngle);

rot = [cosr -sinr;sinr cosr];
devrot = [-sinr -cosr;cosr -sinr];


grad = [0;0;0];

for i = 1:length(realTags)
    cost = cost + 2*(translation-realTags(i).position)*rot*inferredTags(i).position' + translation*(translation'-2*realTags(i).position');
    grad(2:3) = grad(2:3) + rot*inferredTags(i).position' + translation' - realTags(i).position';
    grad(1) = grad(1) + (translation-realTags(i).position)*devrot*inferredTags(i).position';

end

grad = 2 * grad;
