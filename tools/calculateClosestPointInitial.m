function x0 = calculateClosestPointInitial(realTags,inferredTags)


if(length(inferredTags)>1)
    angleReal = atan2(realTags(1).position(2)-realTags(2).position(2),realTags(1).position(1)-realTags(2).position(1));
    angleInferred = atan2(realTags(1).position(2)-realTags(2).position(2),realTags(1).position(1)-realTags(2).position(1));

    angle = angleReal-angleInferred;

else
    angle = 0;

end

if(~isempty(inferredTags))
    translation = realTags(1).position - rotation(inferredTags(1).estimatedPosition,angle);
    
  
else
    translation = [0 0];
end

  x0 = [angle,translation];