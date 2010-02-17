function [angle,translation,fval] = iterativeClosestPoint(realTagsDisordered,inferredTags,angle,translation)

realTags = repmat(realTagsDisordered(1),1,length(inferredTags));

for i = 1:length(inferredTags)
   k = searchTag(realTagsDisordered,inferredTags(i).tagId);
   realTags(i) = realTagsDisordered(k);
end

if(nargin<3)
    x0 = calculateClosestPointInitial(realTags,inferredTags);
else
    x0 = [angle translation];
end

costFunc = @(x) closestPointCostFunc(realTags,inferredTags,x);


optimizationOptions = optimset;
optimizationOptions = optimset(optimizationOptions,'GradObj','on');

x0 = fminunc(costFunc,x0,optimizationOptions);


angle = x0(1);
translation = x0(2:3);

fval = meanDistances(realTags,inferredTags,angle,translation);
