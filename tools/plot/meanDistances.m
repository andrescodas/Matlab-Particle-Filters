function  cost  = meanDistances(realTags,inferredTags,rotationAngle,translation)


cost = 0;

cosr = cos(rotationAngle);
sinr = sin(rotationAngle);

rot = [cosr -sinr;sinr cosr];


for i = 1:length(realTags)
    error = inferredTags(i).position * rot + translation -realTags(i).position ;
    cost = cost + sqrt(  error*error');  
end

cost = cost/length(realTags);