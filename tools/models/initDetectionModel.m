function detectionModel = initDetectionModel(cartesianModel)

detectionModel = cartesianModel;

maxs = max(detectionModel.likelihood);

while( (maxs(1) == 0) && (maxs(length(maxs)) == 0) )
    detectionModel.likelihood = detectionModel.likelihood(:,2:size(detectionModel.likelihood,2)-1) ;
    maxs = max(detectionModel.likelihood);
end


maxs = max(detectionModel.likelihood,[],2);

while( (maxs(1) == 0) && (maxs(length(maxs)) == 0) )
    detectionModel.likelihood = detectionModel.likelihood(2:size(detectionModel.likelihood,1)-1,:) ;
    maxs = max(detectionModel.likelihood,[],2);
end


[m,n] = size(detectionModel.likelihood);

sum = 0;

for i= 1:m
    for j =1:n
       sum = sum + detectionModel.likelihood(i,j); 
    end
end


for i= 1:m
    for j =1:n
       detectionModel.likelihood(i,j) =  detectionModel.likelihood(i,j) / sum; 
    end
end

 firstBlockPositionX = -floor(m/2)*detectionModel.stepDistance;
 firstBlockPositionY = -floor(n/2)*detectionModel.stepDistance;
 
 detectionModel = setfield(detectionModel,'firstBlockPosition',[firstBlockPositionX firstBlockPositionY]);