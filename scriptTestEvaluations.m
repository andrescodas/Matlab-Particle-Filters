
stepDistance = 0.1;

[likelihoodMatrixSquare,numEvaluationsMatrix] = getLikelihoodMatrixCartesian(evaluations,stepDistance);

[reducedX,reducedY] = size(likelihoodMatrixSquare);

figure

for i = 1:reducedX
    for j = 1:reducedY
        if(numEvaluationsMatrix(i,j) > 20)
            numEvaluationsMatrix(i,j) = 20;
        end
    end
end

if((reducedX ~= 0) && (reducedY ~= 0))

    surf((-floor(reducedY/2):floor(reducedY/2))*stepDistance,(-floor(reducedX/2):floor(reducedX/2))*stepDistance,likelihoodMatrixSquare);
    figure
    surf((-floor(reducedY/2):floor(reducedY/2))*stepDistance,(-floor(reducedX/2):floor(reducedX/2))*stepDistance,numEvaluationsMatrix);
end
title('All Evaluations');


for a = 0:7

    eval = selectEvaluations(evaluations,'',a);

    likelihoodMatrixSquare = getLikelihoodMatrixCartesian(eval,stepDistance);

    [reducedX,reducedY] = size(likelihoodMatrixSquare);

    figure

    if((reducedX ~= 0) && (reducedY ~= 0))
        surf((-floor(reducedY/2):floor(reducedY/2))*stepDistance,(-floor(reducedX/2):floor(reducedX/2))*stepDistance,likelihoodMatrixSquare);
    end
    title(strcat('Evaluations from antenna == ',num2str(a)))
end


for t = 1:length(tags)

    eval = selectEvaluations(evaluations,tags(t).tagId);

    likelihoodMatrixSquare = getLikelihoodMatrixCartesian(eval,stepDistance);

    [reducedX,reducedY] = size(likelihoodMatrixSquare);

    figure
    if((reducedX ~= 0) && (reducedY ~= 0))
        surf((-floor(reducedY/2):floor(reducedY/2))*stepDistance,(-floor(reducedX/2):floor(reducedX/2))*stepDistance,likelihoodMatrixSquare);
    end
    title(strcat('Evaluations with tagId == ',tags(t).tagId))

end




% for a = 0:7
%
%     plotEvaluations(evaluations,'',a)
%
% end
%
%
% scriptRealTagsPosition
% for t = 1:length(tags)
%
%     plotEvaluations(evaluations,tags(t).tagId)
%
% end