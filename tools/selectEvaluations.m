function newEvaluations = selectEvaluations(evaluations,tagId,antenna)
%
% function newEvaluations = selectEvaluations(evaluations,tagId,antenna)
%

newEvaluations = evaluations;
evaluationCounter = 0;

if (nargin == 1)
    return
elseif (nargin == 2)

    for j = 1:size(evaluations,2)
        if (strcmp(evaluations(j).tagId,tagId))
            evaluationCounter = evaluationCounter + 1;
            newEvaluations(evaluationCounter) = evaluations(j);
        end
    end
   
    
elseif (nargin == 3)
   
   if (strcmp('',tagId))
       
    for j = 1:size(evaluations,2)
        if (evaluations(j).antenna == antenna)
            evaluationCounter = evaluationCounter + 1;
            newEvaluations(evaluationCounter) = evaluations(j);
        end
    end

   else

       
    for j = 1:size(evaluations,2)
        if (evaluations(j).antenna == antenna)
            if (strcmp(evaluations(j).tagId,tagId))
                evaluationCounter = evaluationCounter + 1;
                newEvaluations(evaluationCounter) = evaluations(j);
            end
        end
    end
   end
    
    
end

newEvaluations = newEvaluations(1:evaluationCounter);