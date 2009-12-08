function [likelihoodMatrixPolar,stepDistance,stepAngle] = getLikelihoodMatrixPolar(evaluations,stepDistance,stepAngle)


if (nargin < 2)
    stepDistance = 0.2; %% in meters
    stepAngle = 5*pi/180;
end


maxDistance = 0;
for k = 1:length(evaluations)
    maxDistance = max(maxDistance,evaluations(k).distance);
end
maxDistance = ceil(maxDistance);

% Creating Grid of Detections Polar

detection = struct('tested',0,'detected',0);
detections = repmat(detection,maxDistance/stepDistance,pi/stepAngle);  %% six meters, pi radians

for k = 1:length(evaluations)
    
    evaluation = evaluations(k);
    
    d = floor(evaluation.distance/stepDistance)+1;
    a = floor(abs(evaluation.angleRadians)/stepAngle)+1;
    

    if (d <= size(detections,1)) 
    
        detections(d,a).tested = detections(d,a).tested + 1;
        detections(d,a).detected = detections(d,a).detected + evaluation.detected;
 
    end        
end

likelihoodMatrixPolar = -ones(maxDistance/stepDistance,pi/stepAngle);

for i = 1:size(likelihoodMatrixPolar,1)
    for j = 1:size(likelihoodMatrixPolar,2) 
        if (detections(i,j).tested > 1)
            likelihoodMatrixPolar(i,j) = detections(i,j).detected/detections(i,j).tested;
        end
    end
end


maxs = max(likelihoodMatrixPolar,[],2);

while( (maxs(length(maxs)) == -1))
    likelihoodMatrixPolar = likelihoodMatrixPolar(1:size(likelihoodMatrixPolar,1)-1,:) ;
    maxs = max(likelihoodMatrixPolar,[],2);
end

boolZeroLineDeleted = 0;
while( (maxs(length(maxs)) == 0))
    boolZeroLineDeleted = 1;
    likelihoodMatrixPolar = likelihoodMatrixPolar(1:size(likelihoodMatrixPolar,1)-1,:) ;
    maxs = max(likelihoodMatrixPolar,[],2);
end
if(~boolZeroLineDeleted)
    warning('Model does not have probability == 0 at the higher distance');
end