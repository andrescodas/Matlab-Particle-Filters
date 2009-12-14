function [likelihoodMatrixSquare,numEvaluationsMatrix,stepDistance] = getLikelihoodMatrixCartesian(evaluations,stepDistance)


if (nargin < 2)
    stepDistance = 0.2; %% in meters
end

maxDistance = 0;
for k = 1:length(evaluations)
    maxDistance = max(maxDistance,evaluations(k).distance);
end
maxDistance = ceil(maxDistance);


% Creating Grid of Detections Cartesian case

tamMatrix = ceil(2*maxDistance/stepDistance);
tamMatrix = tamMatrix + ~mod(tamMatrix,2);  % must be odd

center = ceil(tamMatrix/2);
detection = struct('tested',0,'detected',0);
detections = repmat(detection,tamMatrix,tamMatrix);

%% remember, the side of the matrix must be odd

for k = 1:length(evaluations)

    evaluation = evaluations(k);

    x = round(evaluation.distance/stepDistance*cos(evaluation.angleRadians));
    y = round(evaluation.distance/stepDistance*sin(evaluation.angleRadians));

    if (x+center > size(detections,1))
        error('Look for bugs')
    elseif(y+center > size(detections,1))
        error('Look for bugs')
    elseif (x+center < 1 )
        error('Look for bugs')
    elseif (y+center < 1 )
        error('Look for bugs')
    else

        detections(x+center,y+center).tested = detections(x+center,y+center).tested + 1;
        detections(x+center,y+center).detected = detections(x+center,y+center).detected + evaluation.detected;
    end
end

likelihoodMatrixSquare = -ones(tamMatrix,tamMatrix);

for i = 1:size(likelihoodMatrixSquare,1)
    for j = 1:size(likelihoodMatrixSquare,2)

        if (detections(i,j).tested > 1)
            likelihoodMatrixSquare(i,j) = detections(i,j).detected/detections(i,j).tested;
        end
    end
end


maxs = max(likelihoodMatrixSquare);
if(~isempty(maxs))

    while( (maxs(1) == -1) && (maxs(length(maxs)) == -1) && (~isempty(maxs)))
        likelihoodMatrixSquare = likelihoodMatrixSquare(:,2:size(likelihoodMatrixSquare,2)-1) ;
        maxs = max(likelihoodMatrixSquare);
        if(isempty(maxs))
            break;
        end
    end
end
maxs = max(likelihoodMatrixSquare,[],2);

if(~isempty(maxs))

    while( (maxs(1) == -1) && (maxs(length(maxs)) == -1) && (~isempty(maxs)))
        likelihoodMatrixSquare = likelihoodMatrixSquare(2:size(likelihoodMatrixSquare,1)-1,:) ;
        maxs = max(likelihoodMatrixSquare,[],2);
        if(isempty(maxs))
            break;
        end
    end
end

if (nargout > 1)

    numEvaluationsMatrix = -ones(tamMatrix,tamMatrix);

    for i = 1:size(numEvaluationsMatrix,1)
        for j = 1:size(numEvaluationsMatrix,2)

            if (detections(i,j).tested > 1)
                numEvaluationsMatrix(i,j) = detections(i,j).tested;
            end
        end
    end
    maxs = max(numEvaluationsMatrix);
    if(~isempty(maxs))
        while( (maxs(1) == -1) && (maxs(length(maxs)) == -1) && (~isempty(maxs)))
            numEvaluationsMatrix = numEvaluationsMatrix(:,2:size(numEvaluationsMatrix,2)-1) ;
            maxs = max(numEvaluationsMatrix);
            if(isempty(maxs))
                break;
            end
        end
    end
    maxs = max(numEvaluationsMatrix,[],2);
    if(~isempty(maxs))
        while( (maxs(1) == -1) && (maxs(length(maxs)) == -1) && (~isempty(maxs)))
            numEvaluationsMatrix = numEvaluationsMatrix(2:size(numEvaluationsMatrix,1)-1,:) ;
            maxs = max(numEvaluationsMatrix,[],2);
            if(isempty(maxs))
                break;
            end
        end
    end
end